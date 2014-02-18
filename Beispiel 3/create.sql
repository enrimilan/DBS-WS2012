create sequence seq_mannschaft 
   increment by 10
   minvalue 10
   no cycle;

create sequence seq_fahrzeug;

create table Fahrzeug (
   id INTEGER PRIMARY KEY DEFAULT nextval('seq_fahrzeug'),
   kapazitaet INTEGER NOT NULL,
   gewicht INTEGER,
   baujahr INTEGER,
   modell VARCHAR(100),
   marke VARCHAR(40)
);

create table Loeschfahrzeug (
   id INTEGER PRIMARY KEY REFERENCES Fahrzeug(id),
   fuellmenge INTEGER NOT NULL,
   loeschmittel VARCHAR(100) NOT NULL
);

create table Bergefahrzeug (
   id INTEGER PRIMARY KEY REFERENCES Fahrzeug(id),
   zugleistung INTEGER NOT NULL,
   hebevorrichtung BOOLEAN
);

create table Dienstgrad (
   id SERIAL PRIMARY KEY,
   bezeichnung VARCHAR(40),
   gehalt NUMERIC(7,2) CHECK (gehalt >= 0),
   vorgesetzter INTEGER REFERENCES Dienstgrad(id)
);

create table Mannschaft (
   id INTEGER PRIMARY KEY DEFAULT nextval('seq_mannschaft'),
   rufname VARCHAR(100),
   leiter INTEGER NOT NULL
);

create table Person (
   id SERIAL PRIMARY KEY,
   vorname VARCHAR(100),
   nachname VARCHAR(100),
   geburtsdatum DATE,
   beitritt DATE,
   telefon VARCHAR(30),
   dienstgrad INTEGER REFERENCES Dienstgrad(id),
   dienstgrad_seit DATE,
   mannschaft INTEGER REFERENCES Mannschaft(id) DEFERRABLE INITIALLY DEFERRED,
   CHECK (dienstgrad_seit >= beitritt)
);

ALTER TABLE Mannschaft ADD CONSTRAINT leiter_fk FOREIGN KEY(leiter) REFERENCES Person(id) DEFERRABLE INITIALLY DEFERRED;

create table Ereignis (
   id SERIAL PRIMARY KEY,
   zeitpunkt TIMESTAMP,
   typ VARCHAR(30) CHECK(typ in ('Brand', 'Verkehrsunfall', 'Hochwasser', 'Sonstiges')),
   ort VARCHAR(100),
   anzBPers INTEGER
);

create table Bericht (
   ereignis_id INTEGER,
   id INTEGER REFERENCES Ereignis(id),
   kurzbeschreibung VARCHAR(100),
   datum TIMESTAMP,
   verfasser INTEGER REFERENCES PERSON(id),
   PRIMARY KEY(ereignis_id, id)
);

create table Wettkampftruppe (
   id SERIAL PRIMARY KEY,
   kategorie VARCHAR(100),
   gruendung DATE CHECK (gruendung <= current_date),
   sonderzahlung numeric(7,2) NOT NULL   
);

create table Wettkampf (
   id SERIAL PRIMARY KEY,
   ort VARCHAR(100) NOT NULL,
   ausrichter VARCHAR(100),
   kategorie VARCHAR(100),
   von TIMESTAMP NOT NULL,
   bis TIMESTAMP NOT NULL,
   CHECK(von < bis)
);

create table Einsatz (
   fahrzeug INTEGER REFERENCES Fahrzeug(id),
   mannschaft INTEGER REFERENCES Mannschaft(id),
   ereignis INTEGER REFERENCES Ereignis(id),
   PRIMARY KEY(fahrzeug, mannschaft, ereignis)
);

create table absolviert (
   truppen_id INTEGER REFERENCES Wettkampftruppe(id),
   wettkampf_id INTEGER REFERENCES Wettkampf(id),
   platzierung INTEGER check (platzierung > 0),
   PRIMARY KEY(truppen_id, wettkampf_id)
);

create table TruppenMitglied (
   person_id INTEGER REFERENCES Person(id),
   truppen_id INTEGER REFERENCES Wettkampftruppe(id),
   funktion VARCHAR(40),
   PRIMARY KEY(person_id, truppen_id)
);
