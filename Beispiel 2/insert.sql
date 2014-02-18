---------------
--Dienstgrade--
---------------
INSERT INTO Dienstgrad (DID, bezeichnung, basisgehalt) VALUES
	(1, 'General', 3500),
	(2, 'Brigade­general', 3750),
	(3, 'Major', 4236),
	(4, 'Leutnant', 3827 ),
	(5, 'Oberst', 3750);

-------------
--    1    --  
--   / \   --
--  2   3  --
-- /       --
--4        --
-------------
--Dienstgrad 1 hat Dienstgrad 2 und 3 untergeordnet.
--Dienstgrad 2 hat Dienstgrad 4 untergeordnet.
INSERT INTO vorgesetzt (untergeordnet, uebergeordnet) VALUES
	(2, 1),
	(3, 1),
	(4, 2);

BEGIN;
--Mannschaft A,D und B haben den Leiter 1, Mannschaft C den Leiter 2.
INSERT INTO Mannschaft (MID, rufname, leiter) VALUES
	(nextval('seq_mannschaft'),'A', 1),
	(nextval('seq_mannschaft'),'D', 1),
	(nextval('seq_mannschaft'),'C', 2),
	(nextval('seq_mannschaft'),'B', 1);

------------
--Personen--
------------
INSERT INTO Person (PID, vorname, nachname, geburtsdatum, beitrittsdatum, einteilungsdatum, telefonnummer, dienstgrad, mitglied) VALUES
	(1, 'Enri', 'Miho', '1990-05-30', '2010-12-12', '2011-02-02', 834334, 1, 10),
	(2,'Max', 'Mustermann', '1980-05-03', '2010-12-12', '2011-02-02', 343444, 2, 30),
	(3, 'Thomas', 'Mueller', '1989-09-13', '2011-12-12', '2012-02-02', 93459494, 4, 30),
	(4, 'Gerd', 'Mueller', '1952-09-18', '2008-12-14', '2009-05-02', 44445555, 1, 30);
COMMIT;

--------------------
--Wettkampftruppen--
--------------------
INSERT INTO Wettkampftruppe (WtID, kategorie, datum, sonderzahlung) VALUES
	(1, 'A', '2011-09-03',4000),
	(2, 'A', '2005-04-01', 5000),
	(3, 'C', '2011-09-03', 5000),
	(4, 'B', '2009-03-21', 4000),
	(5, 'A', '2012-10-29', 6000);

---------------
--Wettkaempfe--
---------------
INSERT INTO Wettkampf (WkID, ort, veranstalter, kategoriebezeichnung, von, bis) VALUES
	(1, 'Wien', 'Veranstalter1','Kategorie1', '2012-12-12 14:00:00', '2012-12-12 17:00:00'),
	(2, 'Wien', 'Veranstalter1', 'Kategorie2', '2013-05-11 14:00:00', '2013-05-11 17:00:00'),
	(3, 'Wien', 'Veranstalter2', 'Kategorie1', '2013-01-17 14:00:00', '2013-01-17 17:00:00'),
	(4, 'Wien', 'Veranstalter3', 'Kategorie3', '2012-12-12 14:00:00', '2012-12-12 17:00:00'),
	(5, 'Muenchen', 'Veranstalter3', 'Kategorie2','2012-11-29 14:00:00', '2012-11-29 17:00:00' );

--------------
--Funktionen--
--------------
INSERT INTO hat (funktion, person, wettkampftruppe) VALUES
	('Wasserdienst', 1, 2),
	('Fahrmeister', 1, 1),
	('Mechaniker', 2, 3);

--Wettkampftruppe 1 absolviert den Wettkampf 1 und bekommnt den ersten Platz.
--Wettkampftruppe 2 absolviert den Wettkampf 1 und bekommnt den ersten Platz.
--Wettkampftruppe 1 absolviert den Wettkampf 3 und bekommnt den zweiten Platz.
--Wettkampftruppe 2 absolviert den Wettkampf 4 und bekommnt den vierten Platz.
--Wettkampftruppe 2 absolviert den Wettkampf 2 und bekommnt den dritten Platz.
INSERT INTO absolviert (platzierung, wettkampftruppe, wettkampf) VALUES
	(1, 1, 1),
	(1, 2, 1),
	(2, 1, 3),
	(4, 2, 4),
	(3, 2, 2);

--------------
--Ereignisse--
--------------
INSERT INTO Ereignis (EID, typ, zeitpunkt, ort, personenanzahl) VALUES
	(1, 'Verkehrsunfall', '2009-11-01 15:32:00', 'Wien', 3),
	(2, 'Brand', '2011-10-03 17:37:00', 'Salzburg', 0),
	(3, 'Verkehrsunfall', '2012-05-01 06:23:26', 'Linz', 6),
	(4, 'Hochwasser', '2012-08-01 15:32:00', 'Wien', 1),
	(5, 'Sonstiges', '2012-08-01 15:32:00', 'Wien', 2),
	(6, 'Verkehrsunfall', '2012-01-07 15:40:00', 'Dortmund', 4);

------------
--Berichte--
------------
INSERT INTO Bericht(ereignis, verfasser, kurzschreibung, datum) VALUES
	(2, 1, 'Ber1', '2009-09-09'),
	(3, 1, 'Ber2', '2010-10-10'),
	(1, 4, 'Ber2', '2012-12-12');

-------------
--Fahrzeuge--
-------------
INSERT INTO Fahrzeug (FID, sitzplaetze, gewicht, marke, modell, baujahr) VALUES 
	(nextval('seq_fahrzeug'), 6, 40000, 'Merzedes', '200xs',2005),
	(nextval('seq_fahrzeug'), 12, 80000, 'Volkswagen', '500bt',2007),
	(nextval('seq_fahrzeug'), 8, 60000, 'Iveco', '200p',2001),
	(nextval('seq_fahrzeug'), 10, 70000, 'Man', '666s',2008),
	(nextval('seq_fahrzeug'), 12, 80000, 'Merzedes', '400xs',2005),
	(nextval('seq_fahrzeug'), 6, 30000, 'Merzedes', '500xs',2000);

--1,2 und 3 sind Loeschfahrzeuge
INSERT INTO Loeschfahrzeug (fahrzeug, hauptloeschmittel, menge) VALUES
        (1, 'Wasser', 40000),
	(2, 'Wasser', 46000),
	(3, 'Druckluftschaum', 50000);

--4,5 und 6 sind Bergfahrzeuge
INSERT INTO Bergfahrzeug (fahrzeug, zugleistung, hebevorrichtung) VALUES
	(4, 580, 'Ja'),
	(5, 590, 'Nein'),
	(6, 700, 'Ja');

-------------
--Einsaetze--
-------------
INSERT INTO Einsatz (einsatzID, mannschaft, ereignis, fahrzeug) VALUES
	(1,10,1,1),
	(2,10,1,1),
	(3,30,3,2);