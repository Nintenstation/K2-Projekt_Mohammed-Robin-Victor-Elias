USE EventFlow;
GO

/*
Syfte: Söka efter ett evenemang baserat på dess titel.
*/

-- SLUTGILTIG VERSION: Fixa sökfunktion med en trim
/*
Förklaring av val:
Det här är vår slutgiltiga procedur eftersom den uppfyller alla krav bäst.
Den tar emot en parameter (@Sökord), filtrerar sökningen tydligt med LIKE, 
och ignorerar stora/små bokstäver. Det viktigaste är att den kombinerar sökningen 
med TRIM() och LEN() > 0. Detta löser problemet vi hade där ett tomt 
mellanslag (' ') annars matchade evenemang som "Movie Night". 
*/
CREATE PROCEDURE dbo.usp_GetEvenemangByTitelTrim
    @Sökord NVARCHAR(150)
AS
BEGIN
    SELECT 
        e.Titel AS EvenemangsTitelAllTrim,
        e.Beskrivning,
        e.Datum,
        e.Tid AS StartTid,
        e.Plats,
        e.Pris,
        c.Namn AS KategoriNamn
    FROM Events AS e
    INNER JOIN Categories AS c 
        ON e.KategoriId = c.KategoriId
    WHERE (e.Titel) LIKE '%' + (@Sökord) + '%' 
    AND LEN(TRIM(@Sökord)) > 0
    ORDER BY e.Datum, e.Tid;
END;
GO

-- Test och resultat för usp_GetEvenemangByTitelTrim:
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = 'live'; 
-- Resultat: Visar 1 rad ("Livekonsert").
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = 'livekonseggg'; 
-- Resultat: Visar 0 rader (tomt resultat, inget SQL-fel).
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = ' '; 
-- Resultat: Visar 0 rader (Trim förhindrar att mellanslag ger felaktiga träffar).
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = 'MoVie Ni'; 
-- Resultat: Visar 1 rad ("Movie Night").
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = 'i'; 
-- Resultat: Visar alla evenemang som innehåller bokstaven "i".
EXEC dbo.usp_GetEvenemangByTitelTrim @Sökord = 'LIVE'; 
-- Resultat: Visar 1 rad ("Livekonsert").
GO

-- ALTERNATIV: 1. Stored Procedure: Exakt titel (skiftlägeskänslig)
/*
Syfte: Söka efter ett evenemang med exakt samma titel.
*/
CREATE PROCEDURE dbo.usp_GetEvenemangByExaktTitel
    @Titel NVARCHAR(150)
AS
BEGIN
    SELECT 
        e.Titel AS EvenemangsTitelExakt,
        e.Beskrivning,
        e.Datum,
        e.Tid AS StartTid,
        e.Plats,
        e.Pris,
        c.Namn AS KategoriNamn
    FROM Events AS e
    INNER JOIN Categories AS c 
        ON e.KategoriId = c.KategoriId
    WHERE e.Titel = @Titel
    ORDER BY e.Datum, e.Tid;
END;
GO

-- Test och resultat för usp_GetEvenemangByExaktTitel:
EXEC dbo.usp_GetEvenemangByExaktTitel @Titel = 'Livekonsert'; 
-- Resultat: Visar 1 rad.
EXEC dbo.usp_GetEvenemangByExaktTitel @Titel = 'Live'; 
-- Resultat: Visar 0 rader.
EXEC dbo.usp_GetEvenemangByExaktTitel @Titel = 'LIVE'; 
-- Resultat: Visar 0 rader.
EXEC dbo.usp_GetEvenemangByExaktTitel @Titel = ' '; 
-- Resultat: Visar 0 rader.
EXEC dbo.usp_GetEvenemangByExaktTitel @Titel = 'LIVEKonSert'; 
-- Resultat: Överraskande nog visade denna 1 rad för att databasens standardinställning redan hanterar stora/små bokstäver här.
GO 

-- ALTERNATIV: 2. Stored Procedure: Exakt titel (oberoende av stora/små bokstäver)
/*
Syfte: Söka efter ett evenemang med exakt titel, men det spelar ingen roll om man skriver med stora eller små bokstäver.
*/
CREATE PROCEDURE dbo.usp_GetEvenemangByExaktTitelNoBokstav
    @Titel NVARCHAR(150)
AS
BEGIN
    SELECT 
        e.Titel AS EvenemangsTitelExaktNoBostav,
        e.Beskrivning,
        e.Datum,
        e.Tid AS StartTid,
        e.Plats,
        e.Pris,
        c.Namn AS KategoriNamn
    FROM Events AS e
    INNER JOIN Categories AS c 
        ON e.KategoriId = c.KategoriId
    WHERE LOWER(e.Titel) = LOWER(@Titel)
    ORDER BY e.Datum, e.Tid;
END;
GO
  
-- Test och resultat för usp_GetEvenemangByExaktTitelNoBokstav:
EXEC dbo.usp_GetEvenemangByExaktTitelNoBokstav @Titel = 'Livekonsert'; 
-- Resultat: Visar 1 rad.
EXEC dbo.usp_GetEvenemangByExaktTitelNoBokstav @Titel = 'Live'; 
-- Resultat: Visar 0 rader (hela namnet måste matcha).
EXEC dbo.usp_GetEvenemangByExaktTitelNoBokstav @Titel = 'LIVE'; 
-- Resultat: Visar 0 rader.
EXEC dbo.usp_GetEvenemangByExaktTitelNoBokstav @Titel = ' '; 
-- Resultat: Visar 0 rader.
EXEC dbo.usp_GetEvenemangByExaktTitelNoBokstav @Titel = 'LIVEKonSert'; 
-- Resultat: Visar 1 rad, fungerar som planerat med LOWER.
GO

-- ALTERNATIV: 3. Stored Procedure: Sök med valfritt ord (del av titel)
/*
Syfte: Söka evenemang genom att skriva ett ord eller några bokstäver som finns i titeln.
*/
CREATE PROCEDURE dbo.usp_GetEvenemangByTitelBokstav
    @Sökord NVARCHAR(150)
AS
BEGIN
    SELECT 
        e.Titel AS EvenemangsTitelAllBokstav,
        e.Beskrivning,
        e.Datum,
        e.Tid AS StartTid,
        e.Plats,
        e.Pris,
        c.Namn AS KategoriNamn
    FROM Events AS e
    INNER JOIN Categories AS c 
        ON e.KategoriId = c.KategoriId
    WHERE (e.Titel) LIKE '%' + (@Sökord) + '%' 
    ORDER BY e.Datum, e.Tid;
END;
GO

-- Test och resultat för usp_GetEvenemangByTitelBokstav:
EXEC dbo.usp_GetEvenemangByTitelBokstav @Sökord = 'live'; 
-- Resultat: Visar 1 rad.
EXEC dbo.usp_GetEvenemangByTitelBokstav @Sökord = 'livekonseggg'; 
-- Resultat: Visar 0 rader (inget SQL-fel).
EXEC dbo.usp_GetEvenemangByTitelBokstav @Sökord = ' '; 
-- Resultat: Detta gav oväntat tillbaka evenemang som hade mellanslag (t.ex. Movie Night). Inte ett bra resultat.
EXEC dbo.usp_GetEvenemangByTitelBokstav @Sökord = 'i'; 
-- Resultat: Visar alla med bokstaven i.
EXEC dbo.usp_GetEvenemangByTitelBokstav @Sökord = 'LIVE'; 
-- Resultat: Visar 1 rad.
GO


-- ALTERNATIV 4: Spelar ingen roll med stora/små bokstäver.
/*
Samma som ovan men använder LOWER() på båda sidor av LIKE-funktionen.
*/
CREATE PROCEDURE dbo.usp_GetEvenemangByTitel
    @Sökord NVARCHAR(150)
AS
BEGIN
    SELECT 
        e.Titel AS EvenemangsTitelAll,
        e.Beskrivning,
        e.Datum,
        e.Tid AS StartTid,
        e.Plats,
        e.Pris,
        c.Namn AS KategoriNamn
    FROM Events AS e
    INNER JOIN Categories AS c 
        ON e.KategoriId = c.KategoriId
    WHERE LOWER(e.Titel) LIKE '%' + LOWER(@Sökord) + '%'
    ORDER BY e.Datum, e.Tid;
END;
GO

-- Test och resultat för usp_GetEvenemangByTitel:
EXEC dbo.usp_GetEvenemangByTitel @Sökord = 'live'; 
-- Resultat: Visar 1 rad.
EXEC dbo.usp_GetEvenemangByTitel @Sökord = 'livekonseggg'; 
-- Resultat: Visar 0 rader (inget SQL-fel).
EXEC dbo.usp_GetEvenemangByTitel @Sökord = ' '; 
-- Resultat: Fortfarande ett problem med tomt mellanslag som visar evenemang. (Detta var anledningen till att vi byggde Trim-versionen längst upp).
EXEC dbo.usp_GetEvenemangByTitel @Sökord = 'i'; 
-- Resultat: Visar alla med bokstaven i.
EXEC dbo.usp_GetEvenemangByTitel @Sökord = 'LIVE'; 
-- Resultat: Visar 1 rad.
GO
