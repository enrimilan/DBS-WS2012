
/* tables */
drop table TruppenMitglied;
drop table absolviert;
drop table Einsatz;
drop table Wettkampf;
drop table Wettkampftruppe;
drop table Bericht;
drop table Ereignis;
ALTER TABLE Mannschaft DROP CONSTRAINT leiter_fk;
drop table Person;
drop table Mannschaft;
drop table Dienstgrad;
drop table Bergefahrzeug;
drop table Loeschfahrzeug;
drop table Fahrzeug;

/* sequences */
drop sequence seq_fahrzeug;
drop sequence seq_mannschaft;
