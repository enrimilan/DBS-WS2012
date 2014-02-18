DROP SEQUENCE seq_fahrzeug;
DROP SEQUENCE seq_mannschaft;

DROP TABLE vorgesetzt;
DROP TABLE absolviert;
DROP TABLE hat;
DROP TABLE Wettkampftruppe;
DROP TABLE Wettkampf;
DROP TABLE Einsatz;
DROP TABLE Bericht;
DROP TABLE Ereignis;
ALTER TABLE Person DROP CONSTRAINT mitglied_fk;
ALTER TABLE Mannschaft DROP CONSTRAINT leiter_fk;
DROP TABLE Person;
DROP TABLE Mannschaft;
DROP TABLE Dienstgrad;
DROP TABLE Loeschfahrzeug;
DROP TABLE Bergfahrzeug;
DROP TABLE Fahrzeug;