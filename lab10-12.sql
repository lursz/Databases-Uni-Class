-- Zadanie 2
-- Napisz zapytanie wyświetlające informacje na temat zamówień (dataRealizacji, idzamowienia) używając odpowiedniego operatora in/not in/exists/any/all, które:

-- zostały złożone przez klientów z mieszkań (zwróć uwagę na /**/pole ulica),
SELECT dataRealizacji, idzamowienia, idklienta
FROM zamowienia
WHERE idklienta IN (SELECT idklienta FROM klienci WHERE ulica LIKE '%/%');

-- zostały złożone przez klienta, który ma na imię Antoni,
SELECT dataRealizacji, idzamowienia, idklienta
FROM zamowienia
WHERE idklienta IN (SELECT idklienta FROM klienci WHERE nazwa LIKE '%Antoni');

-- ★ zostały złożone przez klienta z Krakowa do realizacji w listopadzie 2013 roku.
SELECT dataRealizacji, idzamowienia, idklienta
FROM zamowienia
WHERE datarealizacji::TEXT LIKE '2013-11-__'
  AND idklienta IN (SELECT idklienta FROM klienci WHERE klienci.miejscowosc LIKE 'Kraków');

-- Zadanie 3
-- 10.3.5
-- Napisz zapytanie wyświetlające informacje na temat klientów (nazwa, ulica, miejscowość), używając odpowiedniego operatora in/not in/exists/any/all, którzy zamówili pudełka, które zawierają czekoladki z migdałami,

SELECT DISTINCT klienci.nazwa, klienci.ulica, klienci.miejscowosc, czekoladki.orzechy
FROM klienci
         JOIN zamowienia USING (idklienta)
         JOIN artykuly USING (idzamowienia)
         JOIN pudelka USING (idpudelka)
         JOIN zawartosc USING (idpudelka)
         JOIN czekoladki USING (idczekoladki)
WHERE czekoladki.orzechy LIKE 'migdały';

-- 10.3.6
-- Napisz zapytanie wyświetlające informacje na temat klientów (nazwa, ulica, miejscowość), używając odpowiedniego operatora in/not in/exists/any/all, którzy złożyli przynajmniej jedno zamówienie,

SELECT DISTINCT klienci.nazwa, klienci.ulica, klienci.miejscowosc
FROM klienci
WHERE klienci.idklienta IN (SELECT idklienta
                            FROM klienci
                                     JOIN zamowienia USING (idklienta));
-- 10.3.7
-- Napisz zapytanie wyświetlające informacje na temat klientów (nazwa, ulica, miejscowość), używając odpowiedniego operatora in/not in/exists/any/all, którzy nie złożyli żadnych zamówień.
SELECT DISTINCT klienci.nazwa, klienci.ulica, klienci.miejscowosc
FROM klienci
WHERE klienci.idklienta NOT IN (SELECT idklienta FROM zamowienia);
-- Zadanie 4
-- 10.4.7
-- Napisz zapytanie wyświetlające informacje na temat pudełek z czekoladkami (nazwa, opis, cena), używając odpowiedniego operatora, np. in/not in/exists/any/all, które nie zawierają czekoladek w gorzkiej czekoladzie,

SELECT pudelka.nazwa, pudelka.opis, pudelka.cena
FROM pudelka
WHERE pudelka.idpudelka NOT IN (SELECT zawartosc.idpudelka
                                FROM zawartosc
                                         JOIN czekoladki USING (idczekoladki)
                                WHERE czekoladki.czekolada LIKE 'gorzka');


-- 10.4.8
-- Napisz zapytanie wyświetlające informacje na temat pudełek z czekoladkami (nazwa, opis, cena), używając odpowiedniego operatora, np. in/not in/exists/any/all, które nie zawierają czekoladek z orzechami,
SELECT DISTINCT pudelka.nazwa, pudelka.opis, pudelka.cena
FROM pudelka
WHERE pudelka.idpudelka NOT IN (SELECT zawartosc.idpudelka
                                FROM zawartosc
                                         JOIN czekoladki USING (idczekoladki)
                                WHERE czekoladki.orzechy IS NULL);

-- Zadanie 5
-- 10.5.1
-- Wyświetl wartości kluczy głównych oraz nazwy czekoladek, których koszt jest większy od czekoladki o wartości klucza głównego równej D08
SELECT DISTINCT czekoladki.idczekoladki, czekoladki.nazwa, czekoladki.koszt
FROM czekoladki
WHERE czekoladki.koszt > (SELECT czekoladki.koszt FROM czekoladki WHERE idczekoladki LIKE '___' LIMIT 1);

-- 10.5.2
--  Kto (nazwa klienta) złożył zamówienia na takie same czekoladki (pudełka) jak zamawiała Gorka Alicja.
-- POJEBANE
WITH pudelka_alicji AS (SELECT pudelka.idpudelka
                        FROM klienci
                                 JOIN zamowienia USING (idklienta)
                                 JOIN artykuly USING (idzamowienia)
                                 JOIN pudelka USING (idpudelka)
                        WHERE klienci.nazwa = 'Górka Alicja'),
     klienci_pudelka_alicji AS (SELECT DISTINCT klienci.idklienta, pudelka_alicji.idpudelka
                                FROM klienci
                                         JOIN zamowienia USING (idklienta)
                                         JOIN artykuly USING (idzamowienia)
                                         JOIN pudelka_alicji USING (idpudelka)),
     klienci_wymagane_pudelka AS (SELECT DISTINCT klienci.idklienta, pudelka_alicji.idpudelka
                                  FROM klienci,
                                       pudelka_alicji),
     klienci_z_brakami AS (SELECT DISTINCT klienci_wymagane_pudelka.idklienta
                           FROM klienci_wymagane_pudelka
                                    LEFT JOIN klienci_pudelka_alicji ON klienci_wymagane_pudelka.idklienta =
                                                                        klienci_pudelka_alicji.idklienta AND
                                                                        klienci_wymagane_pudelka.idpudelka =
                                                                        klienci_pudelka_alicji.idpudelka
                           WHERE klienci_pudelka_alicji.idpudelka IS NULL),
     klienci_ze_wszyskim AS (SELECT idklienta FROM klienci EXCEPT SELECT idklienta FROM klienci_z_brakami)

SELECT klienci.nazwa
FROM klienci
         JOIN klienci_ze_wszyskim USING (idklienta)
ORDER BY klienci.nazwa;



SELECT klienci.nazwa
FROM klienci
ORDER BY klienci.nazwa;

INSERT INTO artykuly(idzamowienia, idpudelka, sztuk)
SELECT 150, pudelka.idpudelka, 1
FROM klienci
         JOIN zamowienia USING (idklienta)
         JOIN artykuly USING (idzamowienia)
         JOIN pudelka USING (idpudelka)
WHERE klienci.nazwa = 'Górka Alicja';


/* -------------------------------------------------------------------------- */
/*                                   LAB 11                                   */
/* -------------------------------------------------------------------------- */


-- TEMPLATE
CREATE OR REPLACE FUNCTION nazwa(zmienna CHAR(4))
    RETURNS INTEGER AS
$$
DECLARE
    w INTEGER;
BEGIN

END;
$$
    LANGUAGE plpgsql;



-- Zadanie 1
-- Napisz funkcję masaPudelka wyznaczającą masę pudełka jako sumę masy czekoladek w nim zawartych. Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION masaPudelka(idPudelka_ CHAR(4))
    RETURNS INTEGER AS
$$
DECLARE
    result INTEGER;
BEGIN
    SELECT SUM(masa)
    INTO result
    FROM zawartosc
             JOIN czekoladki USING (idczekoladki)
    WHERE (idpudelka = idPudelka_);
    RETURN result;
END;
$$
    LANGUAGE plpgsql;

SELECT masaPudelka('autu');

-- Napisz funkcję liczbaCzekoladek wyznaczającą liczbę czekoladek znajdujących się w pudełku. Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION liczbaCzekoladek(idPudelka_ CHAR(4))
    RETURNS INTEGER AS
$$
DECLARE
    result INTEGER;
BEGIN
    SELECT COUNT(idczekoladki)
    INTO result
    FROM zawartosc
             JOIN czekoladki USING (idczekoladki)
    WHERE (idpudelka = idPudelka_);
    RETURN result;
END;
$$
    LANGUAGE plpgsql;

SELECT liczbaCzekoladek('autu');

-- Zadanie 2
-- Napisz funkcję zysk obliczającą zysk jaki cukiernia uzyskuje ze sprzedaży jednego pudełka czekoladek, zakładając, że zysk ten jest różnicą między ceną pudełka, a kosztem wytworzenia zawartych w nim czekoladek i kosztem opakowania (0,90 zł dla każdego pudełka). Funkcja jako argument przyjmuje identyfikator pudełka. Przetestuj działanie funkcji na podstawie prostej instrukcji select.
CREATE OR REPLACE FUNCTION zysk(idPudelka_ CHAR(4))
    RETURNS FLOAT AS
$$
DECLARE
    result                  FLOAT;
    koszt_czekoladek        FLOAT;
    koszt_papierka CONSTANT FLOAT := 0.9;
BEGIN
    SELECT SUM(czekoladki.koszt)
    INTO koszt_czekoladek
    FROM pudelka
             JOIN zawartosc USING (idpudelka)
             JOIN czekoladki USING (idczekoladki)
    WHERE (idpudelka = idPudelka_);
    SELECT pudelka.cena - koszt_czekoladek - koszt_papierka
    INTO result
    FROM pudelka
             JOIN zawartosc USING (idpudelka)
             JOIN czekoladki USING (idczekoladki)
    WHERE (idpudelka = idPudelka_);
    RETURN result;
END;
$$
    LANGUAGE plpgsql;

DROP FUNCTION zysk();
SELECT zysk('autu');


-- Napisz instrukcję select obliczającą zysk jaki cukiernia uzyska ze sprzedaży pudełek zamówionych w wybranym dniu.
CREATE OR REPLACE FUNCTION zyskDnia(dataRealizacji_ DATE)
    RETURNS FLOAT AS
$$
DECLARE
    result      FLOAT;
    id_pudelek_ CHAR(4);

BEGIN

    SELECT artykuly.idpudelka
    INTO id_pudelek_
    FROM artykuly
             JOIN zamowienia USING (idzamowienia)
    WHERE (datarealizacji = dataRealizacji_);


    SELECT SUM(zysk(id_pudelek_))
    INTO result;
    RETURN result;

END;
$$
    LANGUAGE plpgsql;

SELECT zyskDnia('2013-11-02');

-- Zadanie 3
-- Napisz funkcję sumaZamowien obliczającą łączną wartość zamówień złożonych przez klienta, które czekają na realizację (są w tabeli Zamowienia). Funkcja jako argument przyjmuje identyfikator klienta. Przetestuj działanie funkcji.
CREATE OR REPLACE FUNCTION sumaZamowien(id_klienta_ INTEGER)
    RETURNS FLOAT AS
$$
DECLARE
    result FLOAT;
BEGIN
    SELECT SUM(artykuly.sztuk * pudelka.cena)
    INTO result
    FROM klienci
             JOIN zamowienia USING (idklienta)
             JOIN artykuly USING (idzamowienia)
             JOIN pudelka USING (idpudelka)
    WHERE (klienci.idklienta = id_klienta_);
    RETURN result;
END;
$$
    LANGUAGE plpgsql;

SELECT sumaZamowien(1)
--
-- Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient składający zamówienie. Funkcja jako argument przyjmuje identyfikator klienta. Rabat wyliczany jest na podstawie wcześniej złożonych zamówień w sposób następujący:
-- 4 % jeśli wartość zamówień jest z przedziału 101-200 zł;
-- 7 % jeśli wartość zamówień jest z przedziału 201-400 zł;
-- 8 % jeśli wartość zamówień jest większa od 400 zł.

CREATE OR REPLACE FUNCTION rabat(id_klienta_ INTEGER)
    RETURNS FLOAT AS
$$
DECLARE
    result FLOAT;
BEGIN
    result := sumaZamowien(id_klienta_);
    IF result >= 101.00 AND result < 201.00
    THEN
        RETURN 0.04 * result;
    ELSEIF result >= 201.00 AND result < 400.00
    THEN
        RETURN 0.07 * result;
    ELSEIF result >= 401.00
    THEN
        RETURN 0.08 * result;
    ELSE
        RETURN 0.00;
    END IF;
END;
$$
    LANGUAGE plpgsql;

SELECT rabat(1);


-- Zadanie 4
-- Napisz bezargumentową funkcję podwyzka, która dokonuje podwyżki kosztów produkcji czekoladek o:
--
-- 3 gr dla czekoladek, których koszt produkcji jest mniejszy od 20 gr;
-- 4 gr dla czekoladek, których koszt produkcji jest z przedziału 20-29 gr;
-- 5 gr dla pozostałych.
-- Funkcja powinna ponadto podnieść cenę pudełek o tyle o ile zmienił się koszt produkcji zawartych w nich czekoladek.
--
-- Przed testowaniem działania funkcji wykonaj zapytania, które umieszczą w plikach dane na temat kosztów czekoladek i cen pudełek tak, aby można było później sprawdzić poprawność działania funkcji podwyzka. Przetestuj działanie funkcji.

CREATE OR REPLACE FUNCTION podwyzka()
    RETURNS VOID AS
$$
DECLARE
    zmiana     NUMERIC(7, 2);
    DECLARE c1 RECORD;
    DECLARE c2 RECORD;
BEGIN
    FOR c1 IN SELECT * FROM czekoladki
        LOOP

            IF
                zmiana := CASE
                              WHEN c1.koszt < 0.20 THEN 0.03
                              WHEN c1.koszt BETWEEN 0.20 AND 0.29 THEN 0.04
                              ELSE 0.05 END;

            UPDATE czekoladki
            SET koszt = koszt + zmiana
            WHERE idczekoladki = c1.idczekoladki;

            FOR c2 IN SELECT * FROM zawartosc WHERE idczekoladki = c1.idczekoladki
                LOOP

                    UPDATE pudelka SET cena = cena + (zmiana * c2.sztuk) WHERE idpudelka = c2.idpudelka;

                END LOOP;

        END LOOP;
END;
$$ LANGUAGE PLpgSQL;

SELECT podwyzka();


-- Zadanie 6
-- Napisz funkcję zwracającą informacje o zamówieniach złożonych przez klienta, którego identyfikator podawany jest jako argument wywołania funkcji. W/w informacje muszą zawierać: idzamowienia, idpudelka, datarealizacji. Przetestuj działanie funkcji. Uwaga: Funkcja zwraca więcej niż 1 wiersz!
CREATE OR REPLACE FUNCTION podwyzka(idklienta_ INT)
    RETURNS TABLE
            (
                r_idzamowienia_   INT,
                r_idpudelka_      VARCHAR(4),
                r_datarealizacji_ DATE
            )
AS
$$
BEGIN
    RETURN QUERY SELECT z.idzamowienia, a.idpudelka, z.datarealizacji
                 FROM zamowienia z
                          NATURAL JOIN artykuly a
                 WHERE z.idklienta = idklienta_;
END;
$$ LANGUAGE PLpgSQL;


-- Zadanie 7
-- Napisz funkcję rabat obliczającą rabat jaki otrzymuje klient kwiaciarni składający zamówienie. Funkcję utwórz w schemacie kwiaciarnia. Rabat wyliczany jest na podstawie zamówień bieżących (tabela zamowienia) i z ostatnich siedmiu dni (tabela historia) w sposób następujący:
--
-- 5 % jeśli wartość zamówień jest większa od 0 lecz nie większa od 100 zł;
-- 10 % jeśli wartość zamówień jest z przedziału 101-400 zł;
-- 15 % jeśli wartość zamówień jest z przedziału 401-700 zł;
-- 20 % jeśli wartość zamówień jest większa od 700 zł.

CREATE OR REPLACE FUNCTION kwiaciarnia.rabat(IN arg1 VARCHAR(10))
    RETURNS INTEGER AS
$$
DECLARE
    wynik                   INTEGER;
    DECLARE wartoscZamowien INTEGER;
    DECLARE wartoscHistorii INTEGER;
    DECLARE wartoscSuma     INTEGER;
BEGIN
    SELECT SUM(cena)
    INTO wartoscZamowien
    FROM kwiaciarnia.zamowienia
    WHERE idklienta = arg1;

    SELECT SUM(cena)
    INTO wartoscHistorii
    FROM kwiaciarnia.historia
    WHERE idklienta = arg1
      AND termin > CURRENT_DATE - INTERVAL '7 days';

    wartoscSuma := COALESCE(wartoscZamowien, 0) + COALESCE(wartoscHistorii, 0);

    IF wartoscSuma BETWEEN 1 AND 100 THEN
        wynik := 5;
    ELSIF wartoscSuma BETWEEN 101 AND 400 THEN
        wynik := 10;
    ELSIF wartoscSuma BETWEEN 401 AND 700 THEN
        wynik := 15;
    ELSIF wartoscSuma > 700 THEN
        wynik := 20;
    ELSE
        wynik := 0;
    END IF;

    RETURN wynik;
END;
$$ LANGUAGE PLpgSQL;

SELECT kwiaciarnia.rabat('msowins');



/* -------------------------------------------------------------------------- */
/*                                   LAB 12                                   */
/* -------------------------------------------------------------------------- */


-- Zadanie 1
-- Utwórz (i przetestuj działanie) wyzwalacz (w schemacie kwiaciarnia), który przy złożeniu zamówienia przez klienta:
-- oblicza rabat dla sprzedającego (użyj funkcji z zadania 11.7) i modyfikuje pole cena w dodawanym rekordzie,
-- zmniejsza liczbę dostępnych kompozycji w tabeli kompozycje,
-- dodaje rekord do tabeli zapotrzebowanie, jeśli stan danej kompozycji spada poniżej stanu minimalnego.


CREATE OR REPLACE FUNCTION kwiaciarnia.fn_przedZamowieniem()
    RETURNS TRIGGER AS
$$
DECLARE
    rabat INT;
BEGIN
    --  oblicza rabat dla sprzedającego i modyfikuje pole cena w dodawanym rekordzie,
    rabat := rabat(new.idklienta);
    IF rabat > 0 THEN
        new.cena = new.cena - (new.cena * (rabat::DECIMAL / 100::DECIMAL));
    END IF;

-- zmniejsza liczbę dostępnych kompozycji w tabeli kompozycje
    UPDATE kompozycje SET stan = stan - 1 WHERE idkompozycji = new.idkompozycji;


    IF kompozycje.stan < kompozycje.minimum THEN
        INSERT INTO zapotrzebowanie (data, idkompozycji)
        VALUES (CURRENT_DATE, idkompozycji)
        ON CONFLICT DO UPDATE SET data=CURRENT_DATE;
    END IF;
    RETURN new;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_przedZamowieniem
    BEFORE INSERT
    ON kwiaciarnia.zamowienia
    FOR EACH ROW
EXECUTE PROCEDURE kwiaciarnia.fn_przedZamowieniem();

-- ★ Utwórz wyzwalacz (w schemacie kwiaciarnia), który automatycznie usuwa rekordy z tabeli zapotrzebowanie, jeżeli po dostawie (after update) wzrasta stan danej kompozycji powyżej minimum. Przetestuj działanie wyzwalacza.
CREATE OR REPLACE FUNCTION kwiaciarnia.fn_poDostawie()
    RETURNS TRIGGER AS
$$
BEGIN
    IF new.stan > new.minimum AND old.stan <= old.minimum THEN
        DELETE FROM kwiaciarnia.zapotrzebowanie WHERE idkompozycji = new.idkompozycji;
    END IF;

    RETURN new;
END;
$$ LANGUAGE PLpgSQL;

CREATE TRIGGER tr_poDostawie
    AFTER UPDATE
    ON kwiaciarnia.kompozycje
    FOR EACH ROW
EXECUTE PROCEDURE kwiaciarnia.fn_poDostawie();

-- Zadanie 2
-- Utwórz wyzwalacz modyfikujący (po aktualizacji rekordów w tabeli pudelka) pole cena w tabeli pudelka, jeżeli cena jest mniejsza niż 105% kosztów wytworzenia danego pudełka czekoladek (koszt wytworzenia czekoladek + koszt pudełka 0,90 zł). W takim przypadku cenę należy ustawić na kwotę 105% kosztów wytworzenia
CREATE OR REPLACE FUNCTION fn_aktualizacjaCeny()
    RETURNS TRIGGER AS
$$
DECLARE
    rzecz_cena_pudelka INT;
BEGIN
    SELECT SUM(z.sztuk * cz.koszt)::DECIMAL + 0.9::DECIMAL
    INTO rzecz_cena_pudelka
    FROM zawartosc z
             NATURAL JOIN czekoladki cz
    WHERE z.idpudelka = new.idpudelka
    GROUP BY z.idpudelka;


    IF new.cena < 1.05 * rzecz_cena_pudelka THEN
        new.cena = rzecz_cena_pudelka * 1.05;
    END IF;
    RETURN NEW;

END;
$$ LANGUAGE PLpgSQL;

CREATE TRIGGER tr_aktualizacjaCeny
    AFTER UPDATE
    ON public.pudelka
    FOR EACH ROW
EXECUTE PROCEDURE fn_aktualizacjaCeny();

-- Utwórz wyzwalacz modyfikujący (przy aktualizacji rekordów w tabeli czekoladki) pole cena w tabeli pudelka, jeżeli cena jest mniejsza niż 105% kosztów wytworzenia danego pudełka czekoladek (koszt wytworzenia czekoladek + koszt pudełka 0,90 zł). W takim przypadku cenę należy ustawić na kwotę 105% kosztów wytworzenia.
CREATE OR REPLACE FUNCTION fn_przyAktualizacjiCzekoladki()
    RETURNS TRIGGER AS
$$
DECLARE
    cena_pudelka_ NUMERIC(7, 2);
    iid_pud       VARCHAR(4);
BEGIN
    FOR iid_pud IN SELECT idpudelka FROM zawartosc WHERE idczekoladki = new.idczekoladki
        LOOP
            SELECT SUM(z.sztuk * cz.koszt)::DECIMAL + 0.9::DECIMAL
            INTO cena_pudelka_
            FROM zawartosc z
                     NATURAL JOIN czekoladki cz
            WHERE z.idpudelka = iid_pud
            GROUP BY z.idpudelka;

            IF (SELECT p.cena FROM pudelka p WHERE idpudelka = iid_pud) < (1.05 * cena_pudelka_) THEN
                UPDATE pudelka SET cena = cena_pudelka_ * 1.05;
            END IF;
        END LOOP;
    RETURN NEW;

END;

$$ LANGUAGE PLPGSQL;

CREATE TRIGGER tr_przyAktualizacjiCzekoladki
    AFTER UPDATE
    ON public.czekoladki
    FOR EACH ROW
EXECUTE PROCEDURE fn_przyAktualizacjiCzekoladki();

