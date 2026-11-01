/*
Fråga: Evenemang och respektive arrangör visas och sorteras från tidigast starttid.
Typ av fråga: JOIN-query.
En resultatrad representerar: Informationen för ett evenemang och arrangörens kontaktuppgifter.
Kontroll: Victors (arrangören) data visas upp för evenemanget BigSlap, som är ansluten till Victors arrangörId.
*/
SELECT
	e.Titel AS EvenemangsTitel,
	e.Beskrivning,
	e.Datum,
	e.Tid AS StartTid,
	e.Plats,
	e.Pris,
	o.Namn AS ArrangörensNamn,
	o.Email AS ArrangörensMejl,
	o.Telefon AS ArrangörensTelefon
FROM Events AS e
INNER JOIN Organizers AS o
	ON e.ArrangörId = o.ArrangörId
ORDER BY e.Tid;

/*
Fråga: Filtrera antal evenemang per kategori.
Typ av fråga: AGGREGAT-query.
En resultatrad representerar: Namnet på en viss kategori (utan dess Id eller duplikation) som grupp, och hur många gånger den används i Evenemang tabellen. 
Kontroll: Kategorin Festival finns som en grupp i resultattabellen, och i kolumnen skapad av Count-aggregaten är det “2”, som visar att Festival användes för två evenemang.
*/
SELECT
	c.Namn AS KategoriNamn,
	COUNT(e.EvenemangId) AS AntalEvenemang
FROM Categories AS c
INNER JOIN Events AS e
	ON e.KategoriId = c.KategoriId
GROUP BY c.Namn
ORDER BY c.Namn;








