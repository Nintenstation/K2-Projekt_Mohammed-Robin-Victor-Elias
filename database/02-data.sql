/*Lägg in testdata (i denna ordning)*/
USE EventFlow;
GO

-- Kategori
INSERT INTO Categories (Namn)
VALUES  
    (N'Musik'),
    (N'Sport'),
    (N'Kultur'),
    (N'Familj'),
    (N'Äventyr');

-- Arrangör
INSERT INTO Organizers (Namn, Telefon, Email)
VALUES  
    (N'Malmö Kulturhus', N'040123456', N'kultur@example.com'),
    (N'Malmö Idrottsförening', N'040234567', N'idrott@example.com'),
    (N'Event Malmö', N'040345678', N'event@example.com');

-- Besökare
INSERT INTO Attendees (Namn, Email, Telefon)
VALUES  
    (N'Anna Andersson', N'anna@example.com', N'0701111111'),
    (N'Erik Svensson', N'erik@example.com', N'0702222222'),
    (N'Sara Nilsson', N'sara@example.com', N'0703333333'),
    (N'Johan Karlsson', N'johan@example.com', N'0704444444');

-- Evenemang
INSERT INTO Events (Titel, Beskrivning, Datum, Tid, Plats, Pris, KategoriId, ArrangörId)
VALUES  
    (N'Livekonsert', N'En kväll med livemusik.', '2026-11-15', '18:30', N'Malmö Kulturhus', 150.00, 1, 1),
    (N'Fotbollsturnering', N'En lokal fotbollsturnering.', '2026-11-20', '10:00', N'Malmö Idrottsplats', 50.00, 2, 2),
    (N'Konstutställning', N'En utställning med lokal konst.', '2026-12-05', '13:00', N'Galleri Malmö', 0.00, 3, 1),
    (N'Familjedag', N'Aktiviteter för hela familjen.', '2026-12-12', '11:00', N'Folkets Park', 0.00, 4, 3),
    (N'Movie Night', N'En sen natt där besökare kollar på en film', '2026-12-28', '23:59:59.99', N'Malmö Filmfestival', 259.00, 3, 1);

-- Anmälning
INSERT INTO Registrations (BesökareId, EvenemangId, Anmälningsdatum, AntalPlatser)
VALUES  
    (1, 1, '2026-10-19', 2),
    (2, 1, '2026-10-19', 1),
    (1, 2, '2026-10-19', 1),
    (3, 3, '2026-10-19', 2),
    (4, 4, '2026-10-19', 3);


/*Relevant kantfall
  
INSERT INTO Evenemang
(Titel, Beskrivning, Datum, Tid, Plats, Pris, KategoriId, ArrangörId)
VALUES
(N'Movie Night', N'En sen natt där besökare kollar på en film', '2026-12-28', '23:59:00', N'Malmö Filmfestival', 259.00, 3, 1);*/
