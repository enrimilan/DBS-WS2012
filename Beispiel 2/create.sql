CREATE TABLE Dienstgrad (
        DID INTEGER PRIMARY KEY,
	bezeichnung VARCHAR(50) NOT NULL,
	basisgehalt NUMERIC(6,2) NOT NULL CHECK (basisgehalt>=0)
);

CREATE TABLE vorgesetzt(
	untergeordnet INTEGER REFERENCES Dienstgrad (DID),
	uebergeordnet INTEGER REFERENCES Dienstgrad (DID),
	PRIMARY KEY(untergeordnet)

);

CREATE TABLE Person (
	PID INTEGER PRIMARY KEY,
	vorname VARCHAR(50) NOT NULL,
	nachname VARCHAR(50) NOT NULL, 
	geburtsdatum TIMESTAMP NOT NULL,
	beitrittsdatum TIMESTAMP NOT NULL,
	einteilungsdatum TIMESTAMP NOT NULL CHECK (einteilungsdatum>=beitrittsdatum),
	telefonnummer INTEGER NOT NULL,
        dienstgrad INTEGER REFERENCES Dienstgrad (DID),
        mitglied INTEGER NOT NULL 
);

CREATE TABLE Mannschaft (
	MID INTEGER PRIMARY KEY,
	rufname VARCHAR(50) NOT NULL,
	leiter INTEGER NOT NULL
);

ALTER TABLE Person ADD CONSTRAINT mitglied_fk FOREIGN KEY (mitglied) REFERENCES Mannschaft (MID) DEFERRABLE INITIALLY DEFERRED;
ALTER TABLE Mannschaft ADD CONSTRAINT leiter_fk FOREIGN KEY (leiter) REFERENCES Person (PID) DEFERRABLE INITIALLY DEFERRED;

CREATE TABLE Wettkampftruppe (
	WtID INTEGER PRIMARY KEY,
	kategorie VARCHAR(50) NOT NULL,
	datum TIMESTAMP NOT NULL CHECK (datum<=CURRENT_DATE),
	sonderzahlung NUMERIC(6,2) NOT NULL
);

CREATE TABLE Wettkampf (
	WkID INTEGER PRIMARY KEY,
	ort VARCHAR(50) NOT NULL,
	veranstalter VARCHAR(50) NOT NULL,
	kategoriebezeichnung VARCHAR(50) NOT NULL,
	von TIMESTAMP NOT NULL,
	bis TIMESTAMP NOT NULL
);

CREATE TABLE absolviert(
	platzierung INTEGER NOT NULL,
	wettkampftruppe INTEGER REFERENCES Wettkampftruppe (WtID),
	wettkampf INTEGER REFERENCES Wettkampf (WkID),
	PRIMARY KEY(wettkampftruppe, wettkampf)
);

CREATE TABLE hat (
	funktion VARCHAR(50) NOT NULL,
	person INTEGER REFERENCES Person (PID),
	wettkampftruppe INTEGER REFERENCES Wettkampftruppe( WtID),
	PRIMARY KEY (person, wettkampftruppe)
);

CREATE TABLE Ereignis (
	EID INTEGER PRIMARY KEY,
	typ VARCHAR(50) NOT NULL CHECK (typ in('Brand', 'Verkehrsunfall', 'Hochwasser', 'Sonstiges')),
	zeitpunkt TIMESTAMP NOT NULL,
	ort VARCHAR(50) NOT NULL,
	personenanzahl INTEGER NOT NULL
);

CREATE TABLE Bericht (
	ereignis INTEGER REFERENCES Ereignis (EID),
	verfasser INTEGER REFERENCES Person (PID),
	kurzschreibung VARCHAR(50) NOT NULL,
	datum TIMESTAMP NOT NULL,
	PRIMARY KEY (ereignis)
);

CREATE TABLE Fahrzeug (
		FID INTEGER PRIMARY KEY,
		sitzplaetze INTEGER NOT NULL,
		gewicht INTEGER NOT NULL,
		marke VARCHAR(50) NOT NULL,
		modell VARCHAR(50) NOT NULL,
		baujahr INTEGER NOT NULL
);

CREATE TABLE Loeschfahrzeug (
	fahrzeug INTEGER REFERENCES Fahrzeug (FID),
	hauptloeschmittel VARCHAR(50) NOT NULL,
	menge INTEGER NOT NULL,
	PRIMARY KEY(fahrzeug)
);

CREATE TABLE Bergfahrzeug (
	fahrzeug INTEGER REFERENCES Fahrzeug (FID),
	zugleistung INTEGER NOT NULL,
	hebevorrichtung VARCHAR(50) NOT NULL,
	PRIMARY KEY(fahrzeug)
);

CREATE TABLE Einsatz (
	einsatzID INTEGER PRIMARY KEY,
	mannschaft INTEGER REFERENCES Mannschaft (MID),
	ereignis INTEGER REFERENCES Ereignis (EID),
	fahrzeug INTEGER REFERENCES Fahrzeug (FID)
);

CREATE SEQUENCE seq_fahrzeug;
CREATE SEQUENCE seq_mannschaft INCREMENT BY 10 MINVALUE 10 NO MAXVALUE NO CYCLE;