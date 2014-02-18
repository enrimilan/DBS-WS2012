--Einfuegen von Testdaten fuer die Trigger

BEGIN;

INSERT INTO Mannschaft (MID, rufname, leiter) VALUES
	(nextval('seq_mannschaft'),'E', 3),
	(nextval('seq_mannschaft'),'F', 3),
	(nextval('seq_mannschaft'),'G', 4),
	(nextval('seq_mannschaft'),'H', 3);

INSERT INTO Person (PID, vorname, nachname, geburtsdatum, beitrittsdatum, einteilungsdatum, telefonnummer, dienstgrad, mitglied) VALUES
	(5, 'David', 'Alaba', '1995-06-24', '2010-12-12', '2011-02-02', 834334, 1, 50),
	(6,'Anna', 'Mustermann', '1980-05-03', '2010-12-12', '2011-02-02', 343444, 5, 50),
	(7, 'Thomas', 'Helveg', '1989-09-13', '2008-12-12', '2009-02-02', 93459494, 4, 60);
COMMIT;

INSERT INTO Fahrzeug (FID, sitzplaetze, gewicht, marke, modell, baujahr) VALUES 
	(nextval('seq_fahrzeug'), 6, 40000, 'Merzedes', '200xs',2005),
	(nextval('seq_fahrzeug'), 12, 80000, 'Volkswagen', '500bt',2007),
	(nextval('seq_fahrzeug'), 8, 60000, 'Iveco', '200p',2001),
	(nextval('seq_fahrzeug'), 10, 70000, 'Man', '666s',2008),
	(nextval('seq_fahrzeug'), 12, 80000, 'Merzedes', '400xs',2005),
	(nextval('seq_fahrzeug'), 6, 30000, 'Merzedes', '500xs',2000);

INSERT INTO Einsatz (einsatzID, mannschaft, ereignis, fahrzeug) VALUES
	(4,50,4,7),
	(5,50,5,8),
	(6,70,6,9),
	(7,80,4,10);

--Person 5 war mit der Mannschaft 50 an den Einsaetzen 4 und 5 beteiligt, zu den Ereignissen 1 und 2, ist aber nicht volljaehrig.
--Person 6 war mit der Mannschaft 50 an den Einsaetzen 4 und 5 beteiligt, beide zu den Ereignissen 1 und 2, und ist schon volljaehrig.
--Person 7 war mit der Mannschaft 60 an keinem Einsatz beteiligt, und ist volljaehrig.
--Person 8 war mit der Mannschaft 60 an dem Einsatz 7 beteiligt zum Ereignis 2 beteiligt, und ist schon volljaehrig.

-------------
--1.Trigger--
-------------

--Nicht volljaehrig
\echo Erwarte: Verfasser ist juenger als 18
INSERT INTO Bericht(ereignis, verfasser, kurzschreibung, datum) VALUES
	(7, 5, 'Ber1', '2012-11-03');

--Person 6 war zwar an den Einsaetzen 4 und 5 beteiligt und volljaehrig, jedoch nicht zum Ereignis 7
\echo Erwarte: Verfasser ist an keinem Einsatz beteiligt
INSERT INTO Bericht(ereignis, verfasser, kurzschreibung, datum) VALUES
	(7, 6, 'Ber1', '2009-09-09');

--Erfolg weil Person 6 an den Einsaetzen 4 und 5 beteiligt war und volljaehrig ist, zu den Ereignissen 4 und 5
\echo Erwarte: Erfolg
INSERT INTO Bericht(ereignis, verfasser, kurzschreibung, datum) VALUES
	(4, 6, 'Ber1', '2010-09-09');

-------------
--2.Trigger--
-------------
--Mannschaft schon gefahren
\echo Erwarte: Mannschaft ist schon zu diesem Ereignis gefahren
INSERT INTO Einsatz (einsatzID, mannschaft, ereignis, fahrzeug) VALUES
	(8,70,6,10);

--Fahrzeug schon unterwegs
\echo Erwarte: Mit diesem Fahrzeug ist bereits eine andere Mannschaft zu diesem Ereignis gefahren
INSERT INTO Einsatz (einsatzID, mannschaft, ereignis, fahrzeug) VALUES
	(8,80,6,9);

--Erfolg weil noch keine Mannschaft mit diesem Fahrzeug zu diesem Ereignis gefahren ist
\echo Erwarte: Erfolg
INSERT INTO Einsatz (einsatzID, mannschaft, ereignis, fahrzeug) VALUES
	(8,80,2,9);

--Einfügen von Testdaten fuer die Funktion
INSERT INTO Wettkampftruppe (WtID, kategorie, datum, sonderzahlung) VALUES
	(6, 'A', '2011-09-03',4000),
	(7, 'A', '2005-04-01', 5000),
	(8, 'C', '2011-09-03', 3000);

INSERT INTO hat (funktion, person, wettkampftruppe) VALUES
	('Wasserdienst', 5, 6),
	('Fahrmeister', 5, 7),
	('Mechaniker', 5, 8),
	('Mechaniker', 6, 7),
	('Mechaniker', 7, 6);

INSERT INTO absolviert (platzierung, wettkampftruppe, wettkampf) VALUES
	(1, 6, 1),
	(7, 6, 2),
	(2, 6, 3),
	(4, 6, 4),
	(3, 6, 5),
	(1, 7, 1),
	(3, 7, 2),
	(2, 7, 3),
	(4, 7, 4),
	(3, 7, 5),
	(1, 8, 1),
	(5, 8, 2),
	(2, 8, 3),
	(4, 8, 4),
	(1, 8, 5);

--Person 5 ist teil der Wettkampftruppen 6,7 und 8.
--Person 6 ist teil der Wettkampftruppe 7.
--Person 7 ist teil der Wettkampftruppe 6.


--Falsche ID
\echo Erwarte: Person existiert nicht!
SELECT f_bonus(70);

\echo Erwarte: 12250.0
SELECT f_bonus(1);

--Person 2 ist teil der Wettkampftruppe 3, die aber noch keinen Wettkampf absolviert hat
\echo Erwarte: 0.0
SELECT f_bonus(2);

--Person 4 ist nicht teil einer Wettkampftruppe
\echo Erwarte: 0.0
SELECT f_bonus(4);

\echo Erwarte: 24500.0
SELECT f_bonus(5);

\echo Erwarte: 10000.0
SELECT f_bonus(6);

\echo Erwarte: 7000.0
SELECT f_bonus(7);

------------
--Prozedur--
------------

--Parameter 0 oder negativ
\echo Erwarte: Der Parameter ist nicht positiv
SELECT p_erhoehe_dienstgrad(-1);

\echo Erwarte: Keine Aenderungen
SELECT p_erhoehe_dienstgrad(6);

\echo Erwarte:
\echo Gerd Mueller
\echo alter Dienstgrad: General
\echo neuer Dienstgrad: Brigade­general
\echo --------------------------------------------------
\echo Thomas Helveg
\echo alter Dienstgrad: Leutnant
\echo neuer Dienstgrad: Oberst
\echo --------------------------------------------------
SELECT p_erhoehe_dienstgrad(3);

\echo Erwarte:
\echo Enri Miho
\echo alter Dienstgrad: General
\echo neuer Dienstgrad: Brigade­general
\echo --------------------------------------------------
\echo Max Mustermann
\echo alter Dienstgrad: Brigade­general
\echo neuer Dienstgrad: Major
\echo --------------------------------------------------
\echo David Alaba
\echo alter Dienstgrad: General
\echo neuer Dienstgrad: Brigade­general
\echo --------------------------------------------------
SELECT p_erhoehe_dienstgrad(1);