begin;

delete from Einsatz;
delete from Bericht;
delete from Ereignis;
delete from Bergefahrzeug;
delete from Loeschfahrzeug;
delete from Fahrzeug;
delete from absolviert;
delete from Wettkampf;
delete from TruppenMitglied;
delete from Wettkampftruppe;
delete from Mannschaft;
delete from Person;
delete from Dienstgrad;

commit;

insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Hauptbrandinspektor',5500.0, NULL);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Brandinspektor',5000.0, 1);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Hauptbrandmeister',4500.0, 2);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Brandmeister',4000.0, 3);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Hauptloeschmeister',3500.0, 4);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Loeschmeister',3000.0, 5);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Hauptfeuerwehrmann',2500.0, 6);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Feuerwehrmann',2000.0, 7);
insert into Dienstgrad (bezeichnung, gehalt, vorgesetzter) values ('Probefeuerwehrmann',500.0, 8);

begin;

insert into Person (vorname, nachname, geburtsdatum, beitritt, telefon, dienstgrad, dienstgrad_seit, mannschaft) values 
	('Hans', 'Huber', '1960-02-11', '1980-01-31', '0122345', 1, '2005-01-31', 10),
	('Josef', 'Hofer', '1963-03-20', '1981-03-31', '4523423', 2, '2005-03-31',10),
	('Lisa', 'Mueller', '1985-02-19', '2008-04-17', '0135545', 8, '2008-04-17',10),
	('Lara', 'Wagner', '1963-10-29', '1985-03-11', '056465', 3, '2005-03-31',30),
	('Fritz', 'Bachner', '1957-11-05', '1979-01-31', '0909845', 2, '2007-01-31',20),
	('Guido', 'Hammer', '1976-12-10', '1997-03-30', '01823495', 4,'2009-03-30', 20),
	('Peter', 'Peters', '1980-05-21', '2009-01-31', '01973245', 7, '2009-01-31',20),
	('Thomas', 'Unterleger', '1981-07-25', '2003-01-31', '010982345', 6, '2005-01-31',30),
	('Andreas', 'Krallhofer', '1963-09-1', '1978-04-11', '03392345', 5,'2000-04-11', 30);

insert into Mannschaft (rufname, leiter) values
	('MA-1', 1),
	('MA-2', 5),
	('BA-1', 4);
	
commit;

insert into Wettkampftruppe (kategorie, gruendung, sonderzahlung) values
	('Atemschutz', '2005-06-20', 500.0),
	('Staffel', '1995-10-10', 300.0),
	('Bergung', '2000-02-23', 150.0),
	('Hochwasser', '1999-01-07', 750.0),
	('Jugend', '2010-03-05', 50.0);

insert into TruppenMitglied values
	(1, 1, 'Kommandant'),
	(2, 1, 'Organisation'),
	(3, 1, 'Einsatz'),
	(4, 1, 'Einsatz'),
	(3, 2, 'Laeufer'),
	(7, 2, 'Laeufer'),
	(8, 2, 'Kommandant'),
	(1, 3, 'Kommandant'),
	(9, 3, 'Bergegeraet'),
	(8, 3, 'Einsatz'),
	(5, 4, 'Schutzwall'),
	(6, 4, 'Schutzwall'),
	(2, 4, 'Kommandant');

insert into Wettkampf (ort, ausrichter, kategorie, von, bis) values
	('Lienz', 'FF Lienz', 'Staffellauf', '2012-07-07 12:00', '2012-07-08 18:00'),
	('Graz', 'LFV Steiermark', 'Bergetechnik', '2012-06-04 11:00', '2012-06-07 18:00'),
	('Bad Aussee', 'BFV Liezen', 'Hochwasserbekaempfung', '2012-04-20 10:00', '2012-04-20 20:00'),
	('Hartberg', 'BFV Hartberg', 'Staffellauf', '2012-08-01 15:00', '2012-08-04 12:00'),
	('Mattersburg', 'FF Mattersburg', 'Staffellauf', '2012-04-25 12:00', '2012-04-26 18:00'),
	('Wien', 'LVF Wien', 'Atemschutz', '2012-09-20 9:00', '2012-09-21 21:00');

insert into absolviert (truppen_id, wettkampf_id, platzierung) values
	(2, 1, 1),
	(3, 2, 5),
	(4, 3, 2),
	(2, 4, 15),
	(2, 5, 3),
	(1, 6, 4);

insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (3, 2750, 2012, 'Rosenbauer', 'SRF');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (8, 2150, 2009, 'Rosenbauer', 'KDO/MTF');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (3, 4500, 2012, 'Rosenbauer', 'TLF 4000');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (3, 4250, 2011, 'Rosenbauer', 'TLF 3000');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (2, 3750, 2011, 'Rosenbauer', 'TLF 2000');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (3, 4000, 2006, 'Mercedes Benz', '3738');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (2, 2750, 2008, 'Iveco Magirus', 'CCF-M');
insert into Fahrzeug (kapazitaet, gewicht, baujahr, marke, modell) values (2, 4500, 2009, 'Mercedes Benz', 'Special');

insert into Bergefahrzeug (id, zugleistung, hebevorrichtung) values (3, 2000, false);
insert into Bergefahrzeug (id, zugleistung, hebevorrichtung) values (7, 2500, true);
insert into Bergefahrzeug (id, zugleistung, hebevorrichtung) values (8, 4000, true);

insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (1, 2000, 'Wasser');
insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (3, 4000, 'Schaum');
insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (4, 3000, 'Schaum');
insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (5, 2000, 'Wasser');
insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (6, 3500, 'Schaum');
insert into Loeschfahrzeug (id, fuellmenge, loeschmittel) values (7, 2500, 'Wasser');

insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-01-03 14:48', 'Brand', 'Blumenstraße 12', 3);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-01-08 06:13', 'Verkehrsunfall', 'Schubertgasse', 1);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-02-17 19:03', 'Hochwasser', 'Flussstraße', 7);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-02-18 17:32', 'Sonstiges', 'Flussstraße', 0);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-03-07 14:48', 'Brand', 'Industriezentrum Nord', 16);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-04-24 13:39', 'Brand', 'Forstgasse 19', 2);
insert into Ereignis (zeitpunkt, typ, ort, anzbpers) values ('2012-04-24 13:39', 'Verkehrsunfall', 'Hauptstrasse 25', 2);

insert into Einsatz (fahrzeug, mannschaft, ereignis) values (5, 10, 1);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (7, 20, 2);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (1, 10, 3);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (6, 20, 3);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (3, 30, 3);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (2, 20, 4);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (8, 30, 4);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (3, 10, 5);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (6, 20, 5);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (7, 30, 5);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (7, 30, 6);
insert into Einsatz (fahrzeug, mannschaft, ereignis) values (8, 30, 7);

insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (1, 1, 'Zimmerbrand (Herd nicht abgeschaltet)', '2012-01-04', 3);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (2, 1, 'Bergung des Unfallfahrzeugs', '2012-01-10', 5);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (3, 1, 'Hochwassergegenmaßnahmen', '2012-02-19', 3);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (3, 2, 'Hochwassergegenmaßnahmen', '2012-02-20', 5);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (3, 3, 'Hochwassergegenmaßnahmen', '2012-02-20', 4);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (4, 1, 'Aufräumarbeiten nach Hochwasser', '2012-02-19', 6);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (4, 2, 'Aufräumarbeiten nach Hochwasser', '2012-02-19', 4);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (5, 1, 'Großbrand in Tischlerei Huber', '2012-03-08', 3);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (5, 2, 'Großbrand in Tischlerei Huber', '2012-03-09', 4);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (6, 2, 'Kleiner Waldbrand', '2012-04-24', 4);
insert into Bericht (ereignis_id, id, kurzbeschreibung, datum, verfasser) 
    values (7, 1, 'Bergung des Unfallfahrzeugs', '2012-05-03', 8);
