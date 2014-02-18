/*1.Trigger
Der Verfasser des Berichts zu einem Ereignis muss zum Datum der Eintragung 
des Berichts volljaehrig sein (>= 18 Jahre), sowie selbst am Einsatz beteiligt 
gewesen sein (mit der Mannschaft, in der er sich befindet).*/

CREATE OR REPLACE FUNCTION check_bericht() RETURNS trigger AS $check_bericht$ 
DECLARE
	gebdatum TIMESTAMP;
	diff DOUBLE PRECISION;
	nichtbeteiligt BOOLEAN;
	
BEGIN
	--Ist der Verfasser juenger als 18?
	SELECT geburtsdatum FROM Person WHERE PID=NEW.verfasser INTO gebdatum;
        diff:=date_part('year',age(NEW.datum,gebdatum));
        
	IF diff<18 THEN
		RAISE EXCEPTION 'Verfasser ist juenger als 18';
        END IF;

	--Ist der Verfasser an einem Einsatz beteiligt?
	SELECT count(*)=0 FROM Person,Einsatz WHERE mitglied=mannschaft AND PID=NEW.verfasser AND Einsatz.ereignis=new.ereignis INTO nichtbeteiligt;

	IF nichtbeteiligt THEN
		RAISE EXCEPTION 'Verfasser ist an keinem Einsatz beteiligt';
	END IF;
	    
	RETURN NEW;
END;
$check_bericht$ LANGUAGE plpgsql;

CREATE TRIGGER t_before_bericht BEFORE INSERT ON Bericht
FOR EACH ROW EXECUTE PROCEDURE check_bericht();


/*2.Trigger
Es macht natuerlich Sinn, dass eine Mannschaft nur einmal zu einem bestimmten 
Ereignis fahren kann, genauso soll ein Fahrzeug bei einem bestimmten Ereignis 
nur einmal eingesetzt werden (= ein Eintrag in der Tabelle Einsatz). 
Beispielhaft ausgedrueckt:
Faehrt Mannschaft A mit dem Fahrzeug X zu einem Ereignis 1, dann soll Mannschaft A 
nicht mit einem anderen Fahrzeug zum gleichen Ereignis fahren duerfen 
(die Mannschaft ist ja bereits vor Ort). Genauso soll verhindert werden, dass 
eine andere Mannschaft mit dem Fahrzeug X zu Ereignis 1 faehrt (es ist ja bereits 
Mannschaft A mit diesem Fahrzeug im Einsatz). */

CREATE OR REPLACE FUNCTION check_einsatz() RETURNS trigger AS $check_einsatz$ 
DECLARE
schon_gefahren1 BOOLEAN;
schon_gefahren2 BOOLEAN;
	
BEGIN

	--Eine Mannschaft darf nur einmal zu einem bestimmten Ereignis fahren.
	SELECT count(*)!=0 FROM Einsatz WHERE mannschaft=NEW.mannschaft AND ereignis=NEW.ereignis INTO schon_gefahren1;

	IF schon_gefahren1 THEN
		RAISE EXCEPTION 'Mannschaft ist schon zu diesem Ereignis gefahren';
	END IF;

	--Ein Fahrzeug soll bei einem bestimmten Ereignis nur einmal eingesetzt werden.
	SELECT count(*)!=0 FROM Einsatz WHERE fahrzeug=NEW.fahrzeug AND ereignis=NEW.ereignis INTO schon_gefahren2;
	IF schon_gefahren2 THEN
		RAISE EXCEPTION 'Mit diesem Fahrzeug ist bereits eine andere Mannschaft zu diesem Ereignis gefahren';
	END IF;

	RETURN NEW;
END;
$check_einsatz$ LANGUAGE plpgsql;

CREATE TRIGGER t_before_einsatz BEFORE INSERT ON Einsatz
FOR EACH ROW EXECUTE PROCEDURE check_einsatz();


/*Funktion
Erstellen Sie eine Funktion f_bonus, welche als Parameter die ID einer Person 
erhaelt. Fuer gute Platzierungen in einem Wettbewerb erhalten die Wettkampftruppen-
Mitglieder Bonuszahlungen. Im Falle eines Wettbewerbssieges werden 100% der fuer 
die Truppe festgelegten Bonuszahlung ausgeschuettet. Ein zweiter Platz bringt 50% 
der Bonuszahlung und ein dritter Platz immerhin noch 25%. Alle anderen 
Platzierungen erhalten keinen Bonus fuer die Absolvierung des Wettbewerbs. 
Die Funktion f_bonus soll nun fuer eine Person, anhand der von ihr in 
Wettkampftruppen bestrittenen Wettkaempfe, den Gesamtbonus nach dem obigen 
Schema berechnen und zurueckliefern.
Hat eine Person gar keinen Wettkampf bestritten, oder wurde nie eine Platzierung 
innerhalb der ersten drei Raenge erreicht, soll der Wert 0.0 zurueckgeliefert werden. 
Stellen Sie sicher, dass die uebergebene ID auch tatsaechlich existiert, andernfalls 
beenden Sie die Verarbeitung mit einer Exception samt passendem Hinweis.
*/

CREATE OR REPLACE FUNCTION f_bonus(ID INTEGER) RETURNS NUMERIC(10,2) AS $$

DECLARE
existiert BOOLEAN;
tupel RECORD;
summe NUMERIC(10,2);
BEGIN

--Existiert ueberhaupt diese Person?
SELECT count(*)!=0 FROM Person WHERE ID=PID INTO existiert;
IF NOT existiert THEN
	RAISE EXCEPTION 'Person existiert nicht!';
END IF;

--Bonus
summe:=0.0;

FOR tupel IN SELECT * FROM hat,absolviert,wettkampftruppe WHERE ID=person AND hat.wettkampftruppe=absolviert.wettkampftruppe AND absolviert.wettkampftruppe=wtid LOOP

	IF tupel.platzierung=1 THEN
		summe=summe+tupel.sonderzahlung;
	ELSEIF tupel.platzierung=2 THEN
		summe=summe+(tupel.sonderzahlung)/2;
	ELSEIF tupel.platzierung=3 THEN
		summe=summe+(tupel.sonderzahlung)/4;
	ELSEIF tupel.platzierung>3 THEN
		summe=summe+0.0;
	END IF;

END LOOP;

RETURN summe;

END;
$$ LANGUAGE plpgsql;


/*Prozedur
Erstellen Sie eine Prozedur p_erhoehe_dienstgrad, welche als Parameter eine 
Zahl (Integer) erhaelt. Diese Zahl beschreibt die Zeitspanne in Jahren, die vergehen 
muss, bevor eine Person zum naechsthoeheren Dienstgrad aufsteigen kann. 
Betrachten Sie fuer alle Personen, wie lange sich diese Person bereits in ihrem 
Dienstgrad befindet (Differenz zwischen dem aktuellen Datum und dem 
gespeicherten Wert der jeweiligen Person). Ist dieser Wert groesser oder gleich dem 
Wert des Parameters, dann steigt diese Person um einen Dienstgrad auf. Hat eine 
Person den hoechstmoeglichen Dienstgrad erreicht, dann verbleibt sie natuerlich in 
diesem. 
Geben Sie die Vorname, Nachname und Bezeichnung des neuen als auch des alten 
Dienstgrades aus, bei all jenen Personen, die einen Dienstgrad aufgestiegen sind. 
Stellen Sie sicher, dass es sich beim Parameter der Prozedur um einen positiven 
Wert handelt, andernfalls brechen Sie die Verarbeitung mit einer passenden 
Exception inklusive Fehlermeldung ab.
*/

CREATE OR REPLACE FUNCTION p_erhoehe_dienstgrad(zeitspanne INTEGER) RETURNS VOID AS $$
DECLARE
tupel RECORD;
dienstg INTEGER;
diff INTEGER;
maximum INTEGER; 
dienstg_alt VARCHAR;
dienstg_neu VARCHAR;
BEGIN

--Ist der Parameter positiv?
IF zeitspanne<=0 THEN
	RAISE EXCEPTION 'Der Parameter ist nicht positiv';
END IF;

SELECT max(DID) FROM Dienstgrad INTO maximum;

FOR tupel IN SELECT* FROM Person LOOP
	diff:=date_part('year',age((SELECT CURRENT_DATE),tupel.einteilungsdatum));
	dienstg:=tupel.dienstgrad;
	IF diff>=zeitspanne AND tupel.dienstgrad<maximum THEN
		SELECT bezeichnung FROM Dienstgrad WHERE DID=dienstg INTO dienstg_alt;
		RAISE NOTICE '% %',tupel.vorname, tupel.nachname;
		RAISE NOTICE 'alter Dienstgrad: %', dienstg_alt;
		dienstg=dienstg+1;
		SELECT bezeichnung FROM Dienstgrad WHERE DID=dienstg INTO dienstg_neu;
		RAISE NOTICE 'neuer Dienstgrad: %', dienstg_neu;
		RAISE NOTICE '--------------------------------------------------';
		UPDATE Person SET dienstgrad=dienstg, einteilungsdatum=(SELECT CURRENT_DATE) WHERE PID=tupel.PID;
		
	END IF;

END LOOP;
END;
$$ LANGUAGE plpgsql;