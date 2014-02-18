/*1.Geben Sie ID, Rufname sowie die ID und den Nachnamen des Leiters jener 
    Mannschaften aus, die bereits mit allen Bergefahrzeugen bei Einsätzen waren.*/

SELECT m.id,m.rufname,m.leiter,p.nachname
FROM person p, mannschaft m, einsatz e, bergefahrzeug b
WHERE m.leiter=p.id AND e.fahrzeug=b.id AND m.id=e.mannschaft
GROUP BY m.id,m.rufname,m.leiter,p.nachname
having count(distinct b.id)=(SELECT count(*) FROM bergefahrzeug);



/*2.Wählen Sie per Hand einen Dienstgrad aus, der anderen Dienstgraden 
    untergeordnet ist. Schreiben Sie eine Anfrage, die diesen Dienstgrad ausgibt, sowie 
    rekursiv alle übergeordneten Dienstgrade. Geben Sie für jeden Dienstgrad die ID, 
    Beschreibung sowie das zugehörige Gehalt und den Gehaltsunterschied zum 
    nächstniedrigen Dienstgrad aus. Sollte es keinen niedrigeren Dienstgrad geben, soll 
    der Inhalt der Spalte 0 sein. Passen Sie die Tupel in Ihrer Datenbank so an, dass es 
    zu der von Ihnen ausgewählten Kategorie mindestens zwei Ebenen übergeordneter 
    Kategorien gibt.*/
    
WITH RECURSIVE ueber ( id, bezeichnung,vorgesetzter,gehalt,gehaltsunterschied ) AS (
SELECT a.id, a.bezeichnung,a.vorgesetzter,a.gehalt ,COALESCE((SELECT a.gehalt-gehalt FROM dienstgrad WHERE vorgesetzter=a.id),0.0)
FROM dienstgrad a
WHERE a.id=8
UNION ALL
SELECT b.id, b.bezeichnung,b.vorgesetzter,b.gehalt,b.gehalt-u.gehalt
FROM ueber u,dienstgrad b
WHERE b.id=u.vorgesetzter
)
SELECT id, bezeichnung,gehalt,gehaltsunterschied
FROM ueber;



/*3.Geben Sie die ID, Vor- und Nachname sowie Anzahl der Berichte der Personen aus, 
    die an nicht mehr als drei Einsätzen teilgenommen haben und gleichzeitig die 
    wenigsten Berichte verfasst haben. Sortieren Sie das Ergebnis nach der Anzahl der 
    erstellten Berichte absteigend. [Hinweis nach Rückfragen: Da maximal ein Ergebnis 
    zurückgeliefert wird, ist das Sortieren nicht nötig!] Vergessen Sie nicht darauf, dass 
    im Falle, dass noch keine Berichte erstellt wurden auch die Personen ausgegeben 
    werden, die keine Berichte verfasst haben.*/

SELECT p.id,p.vorname,p.nachname,count(verfasser) as anz_berichte
FROM person p LEFT OUTER JOIN bericht b on (p.id=b.verfasser )
WHERE p.id in (
SELECT p.id 
FROM person p LEFT OUTER JOIN einsatz e on (p.mannschaft=e.mannschaft)
GROUP BY p.id
having count(p.mannschaft)<=3
)
GROUP BY p.id,p.vorname,p.nachname
having count(verfasser)<=ALL(SELECT count(verfasser)
FROM person p LEFT OUTER JOIN bericht b on (p.id=b.verfasser )
WHERE p.id in (
SELECT p.id 
FROM person p LEFT OUTER JOIN einsatz e on (p.mannschaft=e.mannschaft)
GROUP BY p.id
having count(p.mannschaft)<=3
)
GROUP BY p.id,p.vorname,p.nachname);