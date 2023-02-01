/* ---------------------------------- LAB 2 --------------------------------- */
--2.1.1--
SELECT *
FROM public.klienci;
--2.1.2--
SELECT *
FROM public.klienci
ORDER BY miejscowosc, nazwa;
--2.1.3--
SELECT *
FROM public.klienci
WHERE miejscowosc = 'Warszawa'
   OR miejscowosc = 'Kraków'
ORDER BY miejscowosc DESC, nazwa ASC;

SELECT *
FROM public.klienci
WHERE miejscowosc IN ('Warszawa', 'Kraków')
ORDER BY miejscowosc DESC, nazwa ASC;
--2.1.4--
SELECT *
FROM public.klienci
ORDER BY miejscowosc DESC;
--2.1.5--
SELECT *
FROM public.klienci
WHERE miejscowosc = 'Kraków'
ORDER BY miejscowosc;
--2.2.1--
SELECT nazwa, masa
FROM public.czekoladki
WHERE masa > 20;
--2.2.2--
SELECT nazwa, masa, koszt
FROM public.czekoladki
WHERE masa > 20
  AND koszt > 0.20
--2.2.3--
SELECT nazwa, masa, koszt * 100 AS koszt_gr
FROM public.czekoladki
WHERE masa > 20
  AND koszt > 0.20

SELECT nazwa, masa, (koszt * 100)::NUMERIC AS koszt_gr
FROM public.czekoladki
WHERE masa > 20
  AND koszt * 100 > 20
--2.2.4--
SELECT nazwa, czekolada, nadzienie, orzechy
FROM public.czekoladki
WHERE (czekolada = 'mleczna' AND nadzienie = 'maliny')
   OR (czekolada = 'mleczna' AND nadzienie = 'truskawki')
   OR (czekolada != 'gorzka' AND orzechy = 'laskowe');
--2.2.5--
SELECT nazwa, koszt
FROM public.czekoladki
WHERE koszt > 0.25;
--2.2.6--
SELECT nazwa, czekolada
FROM public.czekoladki
WHERE czekolada IN ('mleczna', 'biała');
--2.3--
SELECT 124 * 7 + 45;
SELECT 2 ^ 20;
SELECT SQRT(3);
--2.4.1--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 15 AND 24;
--2.4.2--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35;
--2.4.3--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (masa BETWEEN 25 AND 35)
   OR (koszt BETWEEN 0.15 AND 0.24);
--2.5.1--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE orzechy IS NOT NULL;
--2.5.2--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE orzechy IS NULL;
--2.5.3--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE orzechy IS NOT NULL
  AND nadzienie IS NOT NULL;
--2.5.4--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE czekolada IN ('biała', 'mleczna')
  AND orzechy IS NULL
--2.5.5--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE czekolada NOT IN ('biała', 'mleczna')
  AND (orzechy, nadzienie) IS NOT NULL;
--2.5.6--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE nadzienie IS NOT NULL;
--2.5.7--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE nadzienie IS NULL;
--2.5.8--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (nadzienie, orzechy) IS NULL;
--2.5.9--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE czekolada IN ('biała', 'mleczna')
  AND nadzienie IS NULL;
--2.6.1--
--\i {plik}.sql--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 15 AND 24
   OR koszt BETWEEN 0.15 AND 0.24;
--2.6.2--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (masa BETWEEN 15 AND 24 AND koszt BETWEEN 0.15 AND 0.24)
   OR (masa BETWEEN 25 AND 35 AND koszt BETWEEN 0.25 AND 0.35);
--2.6.3--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (masa BETWEEN 15 AND 24 AND koszt BETWEEN 0.15 AND 0.24);
--2.6.4--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (masa BETWEEN 25 AND 35 AND koszt NOT BETWEEN 0.25 AND 0.35);
--2.6.5--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE (masa BETWEEN 25 AND 35 AND koszt NOT BETWEEN 0.15 AND 0.24 AND koszt NOT BETWEEN 0.25 AND 0.35);
/* ---------------------------------- LAB 3 --------------------------------- */
--3.1.1--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE datarealizacji BETWEEN '2013-11-15' AND '2013-11-20'
--3.1.2--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE datarealizacji BETWEEN '2013-12-1' AND '2013-12-6'
   OR datarealizacji BETWEEN '2013-12-15' AND '2013-12-20';
--3.1.3--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE datarealizacji::TEXT LIKE '2013-12-%'
--3.1.4--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE EXTRACT(MONTH FROM datarealizacji) = '11';
---and EXTRACT(year from datarealizacji) = '2013';---
--3.1.4--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE EXTRACT(MONTH FROM datarealizacji) IN ('11', '12');
--3.1.5--
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE EXTRACT(DAY FROM datarealizacji) BETWEEN '17' AND '19';
--3.1.6
SELECT idzamowienia, datarealizacji
FROM public.zamowienia
WHERE EXTRACT(WEEK FROM datarealizacji) BETWEEN '46' AND '47';
--3.2.1--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa LIKE 'S%';
--3.2.2--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa LIKE 'S%i';
--3.2.3--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa LIKE 'S% m%';
--3.2.4--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa SIMILAR TO '(A|B|C)%';
--3.2.5--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa SIMILAR TO '%(O|o)rzech%';
--3.2.6-- 
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa LIKE 'S%m%';
--3.2.7--
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa SIMILAR TO '%(maliny|truskawki)%';
--3.2.8
--nie rozpoczyna się żadną z liter: 'D'-'K', 'S' i 'T',
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa NOT SIMILAR TO '([D-K]|S|T)%'
--3.2.9
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa SIMILAR TO '(Słod)%';
--3.2.10
SELECT idczekoladki, nazwa, czekolada, orzechy, nadzienie
FROM public.czekoladki
WHERE nazwa NOT SIMILAR TO '% %';
--3.3.1--
SELECT miejscowosc
FROM public.klienci
WHERE miejscowosc LIKE '% %';
--3.3.2--
SELECT nazwa
FROM public.klienci
WHERE telefon LIKE '0%'
--3.3.3--
SELECT nazwa
FROM public.klienci
WHERE telefon NOT LIKE '0%'
--3.4.1--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 15 AND 24
UNION
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24;
--3.4.2--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 25 AND 35
INTERSECT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt NOT BETWEEN 0.25 AND 0.35;
--2sposób--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 25 AND 35
EXCEPT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt BETWEEN 0.25 AND 0.35;
--3.4.3--
(SELECT idczekoladki, nazwa, masa, koszt
 FROM public.czekoladki
 WHERE masa BETWEEN 15 AND 24
 INTERSECT
 SELECT idczekoladki, nazwa, masa, koszt
 FROM public.czekoladki
 WHERE koszt BETWEEN 0.15 AND 0.24)
UNION
(SELECT idczekoladki, nazwa, masa, koszt
 FROM public.czekoladki
 WHERE masa BETWEEN 25 AND 35
 INTERSECT
 SELECT idczekoladki, nazwa, masa, koszt
 FROM public.czekoladki
 WHERE koszt BETWEEN 0.25 AND 0.35);
--3.4.4--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 15 AND 24
INTERSECT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt NOT BETWEEN 0.15 AND 0.24;
--3.4.5--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 25 AND 35
INTERSECT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt NOT BETWEEN 0.15 AND 0.24
  AND koszt NOT BETWEEN 0.29 AND 0.35;
--2 sposob--
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE masa BETWEEN 25 AND 35
EXCEPT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt BETWEEN 0.15 AND 0.24
EXCEPT
SELECT idczekoladki, nazwa, masa, koszt
FROM public.czekoladki
WHERE koszt BETWEEN 0.29 AND 0.35;
--3.5.1--
SELECT idklienta
FROM public.klienci
EXCEPT
SELECT idklienta
FROM public.zamowienia;
--3.5.2--
SELECT idpudelka
FROM public.pudelka
EXCEPT
SELECT idpudelka
FROM public.artykuly;
--2sposob
SELECT idpudelka
FROM public.pudelka
EXCEPT
SELECT idpudelka
FROM public.artykuly
         JOIN public.zamowienia USING (idzamowienia);
--3.5.3--
SELECT nazwa
FROM public.czekoladki
WHERE nazwa SIMILAR TO '%(R|r)z%'
UNION
SELECT nazwa
FROM public.klienci
WHERE nazwa SIMILAR TO '%(R|r)z%'
UNION
SELECT nazwa
FROM public.pudelka
WHERE nazwa SIMILAR TO '%(R|r)z%';
--3.5.4--
SELECT idczekoladki
FROM public.czekoladki
EXCEPT
SELECT idczekoladki
FROM zawartosc;
--3.6.1--
SELECT idmeczu,
       gospodarze[1] + gospodarze[2] + gospodarze[3] +
       COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0)                             AS "suma pkt gospod",
       goscie[1] + goscie[2] + goscie[3] + COALESCE(goscie[4], 0) + COALESCE(goscie[5], 0) AS "suma pkt gosci"
FROM siatkowka.statystyki;
--3.6.2
SELECT idmeczu,
       gospodarze[1] + gospodarze[2] + gospodarze[3] +
       COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0)                             AS "suma pkt gospod",
       goscie[1] + goscie[2] + goscie[3] + COALESCE(goscie[4], 0) + COALESCE(goscie[5], 0) AS "suma pkt gosci"
FROM siatkowka.statystyki
WHERE (gospodarze[5] IS NOT NULL OR goscie[5] IS NOT NULL)
  AND (gospodarze[5] = '15' OR goscie[5] = '15')
--3.6.3--
SELECT idmeczu,
       CONCAT(
                   CASE WHEN gospodarze[1] > goscie[1] THEN 1 ELSE 0 END
                   + CASE WHEN gospodarze[2] > goscie[2] THEN 1 ELSE 0 END
                   + CASE WHEN gospodarze[3] > goscie[3] THEN 1 ELSE 0 END
                   + CASE WHEN COALESCE(gospodarze[4], 0) > COALESCE(goscie[4], 0) THEN 1 ELSE 0 END
                   + CASE WHEN COALESCE(gospodarze[5], 0) > COALESCE(goscie[5], 0) THEN 1 ELSE 0 END
           , ':',
                   CASE WHEN goscie[1] > gospodarze[1] THEN 1 ELSE 0 END
                       + CASE WHEN goscie[2] > gospodarze[2] THEN 1 ELSE 0 END
                       + CASE WHEN goscie[3] > gospodarze[3] THEN 1 ELSE 0 END
                       + CASE WHEN COALESCE(goscie[4], 0) > COALESCE(gospodarze[4], 0) THEN 1 ELSE 0 END
                       + CASE WHEN COALESCE(goscie[5], 0) > COALESCE(gospodarze[5], 0) THEN 1 ELSE 0 END
           ) AS wynik
FROM siatkowka.statystyki
--3.6.4--
SELECT idmeczu,
       gospodarze[1] + gospodarze[2] + gospodarze[3] +
       COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0) AS "suma pkt gospod",
       goscie[1] + goscie[2] + goscie[3] +
       COALESCE(goscie[4], 0) + COALESCE(goscie[5], 0)         AS "suma pkt gosci"
FROM siatkowka.statystyki
WHERE gospodarze[1] + gospodarze[2] + gospodarze[3] +
      COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0) > 100;
--3.6.5--
SELECT idmeczu,
       gospodarze[1]                                           AS "pierwszy set gospodarzy",
       gospodarze[1] + gospodarze[2] + gospodarze[3] +
       COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0) AS "suma pkt gospod",
       goscie[1]                                               AS "pierwszy set gosci",
       goscie[1] + goscie[2] + goscie[3] +
       COALESCE(goscie[4], 0) + COALESCE(goscie[5], 0)         AS "suma pkt gosci"
FROM siatkowka.statystyki
WHERE SQRT(gospodarze[1]) < LOG(2, gospodarze[1] + gospodarze[2] + gospodarze[3] +
                                   COALESCE(gospodarze[4], 0) + COALESCE(gospodarze[5], 0))
   OR SQRT(goscie[1]) < LOG(2, goscie[1] + goscie[2] + goscie[3] +
                               COALESCE(goscie[4], 0) + COALESCE(goscie[5], 0));
/* ---------------------------------- LAB 4 --------------------------------- */
--4.1.1--
SELECT k.nazwa
FROM klienci k;
--4.1.2_bezwartościowe--
SELECT k.nazwa, z.idzamowienia
FROM klienci k,
     zamowienia z;
--4.1.3--
SELECT k.nazwa, z.idzamowienia
FROM klienci k,
     zamowienia z
WHERE z.idklienta = k.idklienta;
--4.1.4--
SELECT k.nazwa, z.idzamowienia
FROM klienci k
         NATURAL JOIN zamowienia z;
--4.1.5--
SELECT k.nazwa, z.idzamowienia
FROM klienci k
         JOIN zamowienia z
              ON z.idklienta = k.idklienta;
--4.1.6--
SELECT k.nazwa, z.idzamowienia
FROM klienci k
         JOIN zamowienia z
              USING (idklienta);
--4.2.1--
SELECT datarealizacji, idzamowienia
FROM public.zamowienia z
         JOIN public.klienci k
              USING (idklienta)
WHERE k.nazwa LIKE '%Antoni';
--4.2.2--
SELECT datarealizacji, idzamowienia
FROM public.zamowienia z
         JOIN public.klienci k
              USING (idklienta)
WHERE k.ulica LIKE '%/%';
--4.2.3--
SELECT datarealizacji, idzamowienia
FROM public.zamowienia z
         JOIN public.klienci k
              USING (idklienta)
WHERE k.miejscowosc LIKE 'Kraków'
  AND z.datarealizacji::TEXT SIMILAR TO '2013-11-%';
--4.3.1--
SELECT nazwa, ulica, miejscowosc
FROM public.zamowienia z
         JOIN public.klienci k USING (idklienta)
WHERE EXTRACT(YEAR FROM z.datarealizacji) >= '2017';
--4.3.2--
SELECT DISTINCT k.nazwa, k.ulica, k.miejscowosc
FROM public.klienci k
         INNER JOIN public.zamowienia z ON z.idklienta = k.idklienta
         INNER JOIN public.artykuly a ON a.idzamowienia = z.idzamowienia
         INNER JOIN public.pudelka p ON p.idpudelka = a.idpudelka
WHERE p.nazwa IN ('Kremowa fantazja', 'Kolekcja jesienna')
--4.3.3--
SELECT *
FROM klienci
WHERE idklienta IN (SELECT idklienta FROM zamowienia)
--4.3.4--
SELECT k.*
FROM klienci k
         LEFT JOIN zamowienia z ON k.idklienta = z.idklienta
WHERE z.idzamowienia IS NULL;
--nie musi byc left--
--4.3.5--

--4.3.6--
SELECT DISTINCT k.nazwa, k.ulica, k.miejscowosc
FROM public.klienci k
         JOIN public.zamowienia z ON k.idklienta = z.idklienta
         JOIN public.artykuly a ON z.idzamowienia = a.idzamowienia
         JOIN public.pudelka p ON a.idpudelka = p.idpudelka
WHERE a.sztuk >= 2
  AND (p.nazwa = 'Kremowa fantazja' OR p.nazwa = 'Kolekcja jesienna');
--4.3.7--

--4.4.1--
SELECT DISTINCT p.nazwa, p.opis, p.cena, c.nazwa, c.opis
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki;
--4.4.2--
SELECT DISTINCT p.nazwa, p.opis, p.cena, c.nazwa, c.opis
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE p.idpudelka LIKE '%heav%';
--4.4.3--
SELECT DISTINCT p.nazwa, p.opis, p.cena, c.nazwa, c.opis
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE p.nazwa SIMILAR TO '%(K|k)olekcja%';
--4.5.1--
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE c.idczekoladki = 'd09';
--4.5.2--
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE c.nazwa LIKE 'S%';
--4.5.3--
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE z.sztuk = '4'
--4.5.4--
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE c.nadzienie LIKE 'truskawki'
--4.5.5--
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
EXCEPT
SELECT DISTINCT p.nazwa, p.opis, p.cena
FROM public.pudelka p
         INNER JOIN public.zawartosc z ON z.idpudelka = p.idpudelka
         INNER JOIN public.czekoladki c ON c.idczekoladki = z.idczekoladki
WHERE c.czekolada LIKE 'gorzka'
--4.6.1--
SELECT idczekoladki, nazwa
FROM public.czekoladki
WHERE koszt > (SELECT koszt FROM public.czekoladki WHERE idczekoladki = 'd08');
--4.6.2--

/* ----------------------------------- LAB ---------------------------------- */

--5.1.1
SELECT COUNT(*) AS liczba_cz
FROM public.czekoladki;
SELECT COUNT(*) AS liczba_czekoladek
FROM czekoladki cz;
--5.1.2
SELECT COUNT(*) AS liczba_czekoladek
FROM czekoladki cz
WHERE cz.nadzienie IS NOT NULL;
SELECT COUNT(cz.nadzienie) AS lb_cz_na
FROM public.czekoladki cz;
--5.1.3
SELECT idpudelka, SUM(sztuk) AS suma
FROM pudelka
         JOIN zawartosc USING (idpudelka)
GROUP BY idpudelka
ORDER BY suma DESC
LIMIT 1;
--Drugi sp
SELECT nazwa, SUM(sztuk) AS suma
FROM pudelka
         JOIN zawartosc USING (idpudelka)
GROUP BY idpudelka
HAVING SUM(sztuk) = (SELECT MAX(suma) AS max
                     FROM (SELECT SUM(sztuk) AS suma
                           FROM pudelka
                                    JOIN zawartosc USING (idpudelka)
                           GROUP BY idpudelka) AS random_alias);
--5.2.1--
SELECT p.idpudelka, SUM(cz.masa * z.sztuk) AS masa
FROM czekoladki cz
         INNER JOIN zawartosc z ON cz.idczekoladki = z.idczekoladki
         INNER JOIN pudelka p ON z.idpudelka = p.idpudelka
GROUP BY p.idpudelka
--5.2.2--
SELECT p.idpudelka, SUM(cz.masa * z.sztuk) AS masa
FROM czekoladki cz
         INNER JOIN zawartosc z ON cz.idczekoladki = z.idczekoladki
         INNER JOIN pudelka p ON z.idpudelka = p.idpudelka
GROUP BY p.idpudelka
ORDER BY masa DESC
LIMIT 1;

--5.2.2 drugi sp
SELECT p.idpudelka, SUM(cz.masa * z.sztuk) AS masa
FROM czekoladki cz
         INNER JOIN zawartosc z USING (idczekoladki)
         INNER JOIN pudelka p USING (idpudelka)
GROUP BY p.idpudelka
HAVING SUM(cz.masa * z.sztuk) = (SELECT MAX(masa) AS max
                                 FROM (SELECT p.idpudelka, SUM(cz.masa * z.sztuk) AS masa
                                       FROM czekoladki cz
                                                INNER JOIN zawartosc z USING (idczekoladki)
                                                INNER JOIN pudelka p USING (idpudelka)
                                       GROUP BY p.idpudelka) AS random_alias);
--5.3.1
SELECT DISTINCT COUNT(z.idzamowienia) AS liczba_zamowien, EXTRACT(DAY FROM z.datarealizacji) AS dzien
FROM public.zamowienia z
         INNER JOIN klienci k USING (idklienta)
GROUP BY EXTRACT(DAY FROM z.datarealizacji)
ORDER BY EXTRACT(DAY FROM z.datarealizacji) ASC
--5.3.2
SELECT COUNT(z.idzamowienia) AS liczba_zamowien
FROM public.zamowienia z
         INNER JOIN klienci k USING (idklienta)
--5.4.1
SELECT p.idpudelka, (SUM(cz.masa * z.sztuk) / SUM(z.sztuk)) AS srednia
FROM czekoladki cz
         INNER JOIN zawartosc z ON cz.idczekoladki = z.idczekoladki
         INNER JOIN pudelka p ON z.idpudelka = p.idpudelka
GROUP BY p.idpudelka
--drugi sp
WITH xyz AS (SELECT pud.idpudelka, SUM(zaw.sztuk) AS liczba
             FROM pudelka pud
                      INNER JOIN zawartosc zaw USING (idpudelka)
                      INNER JOIN czekoladki cz USING (idczekoladki)
             WHERE cz.orzechy IS NULL
             GROUP BY pud.idpudelka
             ORDER BY liczba DESC)
SELECT p.idpudelka, SUM(z.sztuk)
FROM pudelka p
         INNER JOIN zawartosc z USING (idpudelka)
         INNER JOIN czekoladki czz USING (idczekoladki)
WHERE czz.orzechy IS NULL
GROUP BY p.idpudelka
HAVING SUM(z.sztuk) = (SELECT MAX(xyz.liczba) FROM xyz);
--5.5.1
SELECT DISTINCT COUNT(z.idzamowienia) AS liczba_zamowien, EXTRACT(QUARTER FROM z.datarealizacji) AS dzien
FROM public.zamowienia z
         INNER JOIN klienci k USING (idklienta)
GROUP BY EXTRACT(QUARTER FROM z.datarealizacji)
ORDER BY EXTRACT(QUARTER FROM z.datarealizacji) ASC
--5.5.2
SELECT DISTINCT COUNT(z.idzamowienia) AS liczba_zamowien, EXTRACT(MONTH FROM z.datarealizacji) AS miesiac
FROM public.zamowienia z
         INNER JOIN klienci k USING (idklienta)
GROUP BY EXTRACT(MONTH FROM z.datarealizacji)

--5.8
CREATE SEQUENCE lp START 1;

SELECT NEXTVAL('lp') AS lp, p.idpudelka
FROM pudelka p
ORDER BY p.idpudelka ASC;

DROP SEQUENCE lp;

/* ---------------------------------- LAB 6 --------------------------------- */
--6.1
INSERT INTO public.czekoladki (idczekoladki, nazwa, czekolada, orzechy, nadzienie, opis, koszt, masa)
VALUES ('W98', 'Biały kieł', 'biała', 'laskowe', 'marcepan', 'Rozpływające się w rękach i kieszeniach', 0.45, 20);
SELECT *
FROM public.czekoladki
WHERE idczekoladki = 'W98';
INSERT INTO klienci (idklienta, nazwa, ulica, miejscowosc, kod, telefon)
VALUES (90, 'Matusiak Edward', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
       (91, 'Matusiak Alina', 'Kropiwnickiego 6/3', 'Leningrad', '31-471', '031 423 45 38'),
       (92, 'Kimono Franek', 'Karateków 8', 'Mistrz', '30-029', '501 498 324');
SELECT *
FROM public.klienci
WHERE idklienta >= 90;
INSERT INTO klienci (idklienta, nazwa, ulica, miejscowosc, kod, telefon)
VALUES (93, 'Iza Matusiak',
        (SELECT ulica FROM public.klienci WHERE idklienta = 91),
        (SELECT miejscowosc FROM public.klienci WHERE idklienta = 91),
        (SELECT kod FROM public.klienci WHERE idklienta = 91),
        (SELECT telefon FROM public.klienci WHERE idklienta = 91));
SELECT *
FROM public.klienci
WHERE idklienta >= 90;
--6.2
INSERT INTO public.czekoladki (idczekoladki, nazwa, czekolada, orzechy, nadzienie, opis, koszt, masa)
VALUES ('X91', 'Nieznana Nieznajoma', NULL, NULL, NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
       ('M98', 'Mleczny Raj', 'mleczna', NULL, NULL, ' Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.',
        0.26, 36);
SELECT *
FROM public.czekoladki
WHERE idczekoladki IN ('X91', 'M98');
--6.3
DELETE
FROM public.czekoladki
WHERE idczekoladki IN ('X91', 'M98');
INSERT INTO public.czekoladki (idczekoladki, nazwa, czekolada, opis, koszt, masa)
VALUES ('X91', 'Nieznana Nieznajoma', NULL, 'Niewidzialna czekoladka wspomagajaca odchudzanie.', 0.26, 0),
       ('M98', 'Mleczny Raj', 'mleczna', ' Aksamitna mleczna czekolada w ksztalcie butelki z mlekiem.', 0.26, 36);
--6.4
UPDATE klienci
SET nazwa = 'Nowak Iza'
WHERE idklienta = 93
UPDATE czekoladki
SET koszt = koszt * 0.9
WHERE idczekoladki IN ('W98', 'M98', 'X91');
SELECT *
FROM public.czekoladki
WHERE idczekoladki IN ('W98', 'X91', 'M98');

UPDATE czekoladki
SET koszt = (SELECT koszt FROM czekoladki WHERE idczekoladki = 'W98')
WHERE nazwa = 'Nieznana Nieznajoma';

UPDATE czekoladki cz1
SET koszt = cz2.koszt
FROM czekoladki cz2
WHERE cz1.nazwa = 'Nieznana Nieznajoma'
  AND cz2.idczekoladki = 'W98';


UPDATE czekoladki cz
SET koszt = cz.koszt + 0.15
WHERE SUBSTR(cz.idczekoladki, 2, 2)::INT > 90

SELECT *
FROM czekoladki cz
WHERE SUBSTR(cz.idczekoladki, 2, 2)::INT > 90

--6.5
DELETE
FROM public.klienci
WHERE nazwa SIMILAR TO '%Matusiak%'
DELETE
FROM public.klienci
WHERE idklienta > 91
DELETE
FROM public.czekoladki
WHERE koszt >= 0.45
   OR masa = 0
   OR masa >= 36