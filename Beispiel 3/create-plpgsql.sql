/* Der Verfasser des Berichts zu einem Ereignis muss zum Datum der Eintragung des Berichts volljährig 
sein (>= 18 Jahre), sowie selbst am Einsatz beteiligt gewesen sein (mit der Mannschaft, in der er sich
befindet). 
Schreiben Sie einen Trigger für die Tabelle Bericht, der diese beiden Bedingungen sicherstellt. */

create or replace function check_bericht() returns trigger as $$
declare
   gebdat Date;
   ms Person.Mannschaft%type;
begin
   select geburtsdatum, mannschaft into gebdat, ms from person where id = new.verfasser; 

   if extract(year from age(new.datum, gebdat)) >= 18 then
      if exists(select * from Einsatz where ereignis = new.ereignis_id and mannschaft = ms) then
         return new;
      else
         raise exception 'Der Verfasser muss am Einsatz beteiligt sein!';
      end if;
      return new;
   else
      raise exception 'Der Verfasser des Berichts muss volljaehrig sein!';
   end if;
end;
$$ LANGUAGE plpgsql;

create trigger t_before_bericht before insert on Bericht for each row
execute procedure check_bericht();


/* Es macht natürlich Sinn, dass eine Mannschaft nur einmal zu einem bestimmten Ereignis 
fahren kann, genauso soll ein Fahrzeug bei einem bestimmten Ereignis nur einmal eingesetzt 
werden (= ein Eintrag in der Tabelle Einsatz). 

Beispielhaft ausgedrückt:
Fährt Mannschaft A mit dem Fahrzeug X zu einem Ereignis 1, dann soll  Mannschaft A nicht 
mit einem anderen Fahrzeug zum gleichen Ereignis fahren dürfen (die Mannschaft ist ja 
bereits vor Ort). Genauso soll verhindert werden, dass eine andere Mannschaft mit dem 
Fahrzeug X zu Ereignis 1 fährt (es ist ja bereits Mannschaft A mit diesem Fahrzeug im 
Einsatz).
Schreiben Sie einen Trigger für die Tabelle Einsatz der dieses Verhalten garantiert. */

create or replace function check_einsatz() returns trigger as $$
declare

begin
   if exists(select * from Einsatz where ereignis = new.ereignis and mannschaft = new.mannschaft) then
      raise exception 'Eine Mannschaft faehrt nur einmal zu einem Ereignis!';
   else
      if exists(select * from Einsatz where ereignis = new.ereignis and fahrzeug = new.fahrzeug) then
         raise exception 'Ein Fahrzeug wird bei einem Ereignis nur von einer Mannschaft eingesetzt!';
      else
         return new;
      end if;
   end if;
end;
$$ LANGUAGE plpgsql;

create trigger t_before_einsatz before insert on Einsatz for each row
execute procedure check_einsatz();


/* Schreiben Sie eine Funktion f_bonus, welche als Parameter die ID einer Person erhält. 
Für gute Platzierungen in einem Wettbewerb erhalten die Wettkampftruppen-Mitglieder 
Bonuszahlungen. Im Falle eines Wettbewerbssieges werden 100% der für die Truppe 
festgelegten Bonuszahlung ausgeschüttet. Ein zweiter Platz bringt 50% der Bonuszahlung 
und ein dritter Platz immerhin noch 25%. Alle anderen Platzierungen erhalten keinen 
Bonus für die Absolvierung des Wettbewerbs.
Die Funktion f_bonus soll nun für eine Person, anhand der von ihr in Wettkampftruppen 
bestrittenen Wettkämpfe, den Gesamtbonus nach dem obigen Schema berechnen und 
zurückliefern.
Hat eine Person gar keinen Wettkampf bestritten, oder wurde nie eine Platzierung innerhalb 
der ersten drei Ränge erreicht, soll der Wert 0.0 zurückgeliefert werden.
Stellen Sie sicher, dass die übergebene ID auch tatsächlich existiert, andernfalls 
beenden Sie die Verarbeitung mit einer Exception samt passendem Hinweis. */

CREATE OR REPLACE FUNCTION f_bonus(person INTEGER) RETURNS NUMERIC(7,2) AS $$
DECLARE
   rowvar1 RECORD;
   cursor1 REFCURSOR;
   summe_bonus NUMERIC(7,2);
BEGIN

   if not exists (select * from Person p where p.ID = person) then
      raise exception 'Person mit ID % nicht vorhanden!', person;
   end if;
   summe_bonus := 0.0;

   OPEN cursor1 FOR SELECT  
      sonderzahlung,
      (SELECT COUNT(*) FROM absolviert WHERE absolviert.truppen_id = TruppenMitglied.truppen_id AND platzierung = 1) ersterPlatz,
      (SELECT COUNT(*) FROM absolviert WHERE absolviert.truppen_id = TruppenMitglied.truppen_id AND platzierung = 2) zweiterPlatz,
      (SELECT COUNT(*) FROM absolviert WHERE absolviert.truppen_id = TruppenMitglied.truppen_id AND platzierung = 3) dritterPlatz
      FROM TruppenMitglied JOIN Wettkampftruppe ON Wettkampftruppe.id = TruppenMitglied.truppen_id
          WHERE person_id = person;
   FETCH cursor1 INTO rowvar1;

   WHILE found LOOP
      summe_bonus := 
         summe_bonus +
         rowvar1.sonderzahlung * rowvar1.ersterPlatz + 
         rowvar1.sonderzahlung * rowvar1.zweiterPlatz * 0.5 +
         rowvar1.sonderzahlung * rowvar1.dritterPlatz * 0.25;

      FETCH cursor1 INTO rowvar1;
   END LOOP;

   RETURN summe_bonus;
END;
$$ LANGUAGE plpgsql;

/* Schreiben Sie eine Prozedur p_erhoehe_dienstgrad, welche als Parameter eine Zahl (Integer) 
erhält. Diese Zahl beschreibt die Zeitspanne in Jahren, die vergehen muss, bevor eine Person 
zum nächsthöheren Dienstgrad aufsteigen kann.
Betrachten Sie für alle Personen, wie lange sich diese Person bereits in ihrem Dienstgrad 
befindet (Differenz zwischen dem aktuellen Datum und dem gespeicherten Wert der jeweiligen 
Person). Ist dieser Wert größer oder gleich dem Wert des Parameters, dann steigt diese 
Person um einen Dienstgrad auf. Hat eine Person den höchstmöglichen Dienstgrad erreicht, dann 
verbleibt sie natürlich in diesem.
Geben Sie für jede Person aus, ob diese einen Dienstgrad aufgestiegen ist oder nicht. Wenn ja, 
dann geben Sie auch die Bezeichnung des neuen, als auch des alten Dienstgrades aus.
Stellen Sie sicher, dass es sich beim Parameter um einen positiven Wert handelt, andernfalls 
brechen Sie die Verarbeitung mit einer passenden Exception inklusive Fehlermeldung ab. */

CREATE OR REPLACE FUNCTION p_erhoehe_dienstgrad(jahre INTEGER) RETURNS VOID AS $$
DECLARE
   rowvar1 RECORD;
   cursor1 REFCURSOR;
   neuer_dienstgrad INTEGER;
   alter_dienstgrad_name VARCHAR(40);
   neuer_dienstgrad_name VARCHAR(40);
BEGIN
   IF jahre < 0 THEN
      RAISE EXCEPTION 'Anzahl der notwendigen Dienstjahre muss groesser als 0 sein!';
   END IF;

   OPEN cursor1 FOR SELECT id, vorname, nachname, dienstgrad 
      FROM Person WHERE EXTRACT(YEAR FROM AGE(dienstgrad_seit)) >= jahre;
   FETCH cursor1 INTO rowvar1;

   WHILE found LOOP
      SELECT vorgesetzter, bezeichnung FROM Dienstgrad 
         WHERE id = rowvar1.dienstgrad 
         INTO neuer_dienstgrad, alter_dienstgrad_name;

      IF neuer_dienstgrad IS NOT NULL THEN
         SELECT bezeichnung FROM Dienstgrad WHERE id = neuer_dienstgrad INTO neuer_dienstgrad_name;

         UPDATE Person SET dienstgrad = neuer_dienstgrad, dienstgrad_seit = CURRENT_DATE WHERE id = rowvar1.id;

		   RAISE NOTICE '% % wurde befoerdert von % zu %!', rowvar1.vorname, rowvar1.nachname, alter_dienstgrad_name, neuer_dienstgrad_name;
      END IF;

      FETCH cursor1 INTO rowvar1;
   END LOOP;
END;
$$ LANGUAGE plpgsql;

