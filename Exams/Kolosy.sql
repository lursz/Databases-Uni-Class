/* -------------------------------------------------------------------------- */
/*                                 KOLOS 2022                                 */
/* -------------------------------------------------------------------------- */
CREATE SCHEMA dietetyka;

CREATE TABLE klienci
(
    id_klienta  int4 PRIMARY KEY,
    nazwa       VARCHAR(130) NOT NULL,
    ulica       VARCHAR(130) NOT NULL,
    miejscowosc VARCHAR(130) NOT NULL,
    kod         bpchar(6)    NOT NULL,
    telefon     VARCHAR(130) NOT NULL

);

CREATE TABLE zamowienia
(
    id_zamowienia   int4 PRIMARY KEY,
    id_klienta      int4 NOT NULL,
    id_diety        int4 NOT NULL,
    data_zalozenia  DATE NOT NULL,
    data_dostawy_od DATE NOT NULL,
    data_dostawy_do DATE NOT NULL

);

CREATE TABLE dania
(
    id_dania          int4 PRIMARY KEY,
    nazwa             VARCHAR(255)  NOT NULL,
    gramatura         int4          NOT NULL,
    kalorycznosc      int4          NOT NULL,
    kuchnia           VARCHAR(100),
    wymaga_podgrzania bool          NOT NULL,
    koszt_produkcji   NUMERIC(5, 2) NOT NULL
);



CREATE TABLE diety
(
    id_diety       int4 PRIMARY KEY,
    nazwa          VARCHAR(150)  NOT NULL,
    gluten         bool          NOT NULL,
    laktoza        bool          NOT NULL,
    wege           bool          NOT NULL,
    keto           bool          NOT NULL,
    opakowania_eko bool          NOT NULL,
    cena_dzien     NUMERIC(5, 2) NOT NULL
);


CREATE TABLE wybory
(
    id_zamowienia int4 REFERENCES zamowienia (id_zamowienia) NOT NULL,
    id_dania      int4 REFERENCES dania (id_dania),
    data_dostawy  DATE                                       NOT NULL
);


CREATE TABLE dostepnosc
(
    id_diety     int4 REFERENCES diety (id_diety),
    id_dania     int4 REFERENCES dania (id_dania),
    data_dostawy DATE    NOT NULL,
    pora_dnia    VARCHAR NOT NULL
);

ALTER TABLE dostepnosc
    ADD CONSTRAINT dostepnosc_fk
        PRIMARY KEY (data_dostawy, id_diety, id_dania);

ALTER TABLE wybory
    ADD CONSTRAINT wybory_fk
        PRIMARY KEY (data_dostawy, id_zamowienia, id_dania);


INSERT INTO dania
VALUES (1, 'SZPAGET', 12, 12, 'ITALIABNOI', TRUE, 10);
INSERT INTO diety
VALUES (1, 'SZPAGETTDIETA', TRUE, FALSE, FALSE, FALSE, FALSE, 12);
INSERT INTO diety
VALUES (2, 'SZPAGETTDIETA2', TRUE, FALSE, FALSE, FALSE, FALSE, 12);
INSERT INTO dostepnosc
VALUES (1, 1, '10-01-2023', 'sniadanie');
INSERT INTO dostepnosc
VALUES (2, 1, '10-01-2023', 'sniadanie');
INSERT INTO dania
VALUES (2, 'szpinak', 12, 12, 'ITALIABNOI', TRUE, 10);
INSERT INTO dostepnosc
VALUES (1, 2, '10-01-2023', 'sniadanie');
INSERT INTO klienci
VALUES (1, 'kasia', 'kapitol', 'krk', '12-222', 'innejedzenie');
INSERT INTO klienci
VALUES (2, 'kasi2a', 'kapitol', 'krk', '12-222', 'jedzenie');
INSERT INTO zamowienia
VALUES (1, 1, 1, '10-10-2010', '12-10-2010', '20-02-2024');
INSERT INTO zamowienia
VALUES (2, 1, 1, '10-10-2010', '12-10-2010', '20-02-2024');
INSERT INTO zamowienia
VALUES (3, 1, 1, '10-10-2010', '12-10-2010', '20-02-2024');
INSERT INTO zamowienia
VALUES (4, 2, 2, '10-10-2010', '12-10-2010', '20-02-2024');

-- Wybierz diety gdzie danie ma kaloryczność mniej niż 300 i dieta zostało zamówione w 126, 48 lub 7 razy
SELECT DISTINCT id_diety
FROM diety d
         JOIN dostepnosc USING (id_diety)
WHERE 300 > ALL (SELECT kalorycznosc
                 FROM dania
                          JOIN dostepnosc USING (id_dania)
                 WHERE dostepnosc.id_diety = d.id_diety)
  AND (SELECT COUNT(id_zamowienia) FROM zamowienia WHERE zamowienia.id_diety = d.id_diety GROUP BY id_diety) IN
      (1, 33, 2);

SELECT COUNT(id_klienta) AS twojas
FROM zamowienia;

-- Napisz funkcje która dla danej daty (argument) przekopiuje dania dla diety z zeszlego tygodnia i wlozy je do dostpenosc i
-- przy okazji zwroci je w formie tabeli i jeszcze stworzy pokój na świecie


CREATE OR REPLACE FUNCTION pokojNaSwiecie(data_ DATE)
    RETURNS TABLE
            (
                id_dania_ INTEGER,
                id_diety_ INT
            )
AS
$$
DECLARE
    record_ RECORD;
BEGIN
    FOR record_ IN SELECT * FROM dostepnosc
        LOOP
            IF record_.data_dostawy = data_ - 7 THEN
                INSERT INTO dostepnosc
                VALUES (record_.id_diety, record_.id_dania, data_, record_.pora_dnia)
                ON CONFLICT (id_diety, id_dania, data_dostawy) DO UPDATE SET data_dostawy = record_.data_dostawy + 1;
            END IF;
        END LOOP;
--     INSERT INTO dostepnosc SELECT id_diety, id_dania, data_dostawy + 7, pora_dnia FROM dostepnosc WHERE data_dostawy + 7 = data_;
    RETURN QUERY SELECT id_dania, id_diety FROM dostepnosc WHERE data_dostawy = data_ - 7;
END;
$$ LANGUAGE PLpgSQL;

SELECT pokojNaSwiecie('17-01-2023');


/* -------------------------------------------------------------------------- */
/*                                 KOLOS 2021                                 */
/* -------------------------------------------------------------------------- */
/* --------------------------------- KOLOS A -------------------------------- */
-- zad 3
CREATE SCHEMA spotify;

CREATE TABLE spotify.albumy
(
    idalbumu     INTEGER     NOT NULL PRIMARY KEY,
    idwykonawcy  INTEGER     NOT NULL REFERENCES wykonawcy (idwykonawcy),
    nazwa        VARCHAR(50) NOT NULL,
    gatunek      VARCHAR(20) NOT NULL,
    data_wydania DATE        NOT NULL,
    CONSTRAINT nazwa CHECK gatunek(nazwa IN ('Metal', 'Pop'))
        );
--     NOT NULL
--     UNIQUE
--     PRIMARY KEY
--     DEFAULT WARTOSC
--     CHECK (WARUNERK)
--     REFERENCES


CREATE TABLE spotify.wykonawcy
(
    idwykonawcy      INTEGER PRIMARY KEY,
    nazwa            VARCHAR(100) NOT NULL,
    kraj             VARCHAR(30)  NOT NULL,
    data_debiutu     DATE         NOT NULL,
    data_zakonczenia DATE
);
ALTER TABLE klienci
    ADD CONSTRAINT CHECK (LENGTH(klienci.login) >= 5);


ALTER TABLE spotify.wykonawcy
    ADD FOREIGN KEY (nazwa) REFERENCES tabela (rekord);
ALTER TABLE spotify.wykonawcy
    ALTER COLUMN kraj DROP NOT NULL;
ALTER TABLE spotify.wykonawcy
    ALTER COLUMN kraj SET NOT NULL;
ALTER TABLE spotify.wykonawcy
    ADD CONSTRAINT chuj UNIQUE (kraj);

ALTER TABLE wykonawcy
    ADD CHECK (LENGTH(nazwa) > 50)


-- zad 4

SELECT p.idplaylisty
FROM playlisty p
WHERE 300 < ALL (SELECT u.dlugosc
                 FROM zawartosc z
                          NATURAL JOIN utwory u
                 WHERE z.idplaylisty = p.idplaylisty)
  AND 'POP' = ANY (SELECT a.gatunek
                   FROM albumy a
                            JOIN utworu u USING (idalbumu)
                            JOIN zawartosc z USING (idutworu)
                   WHERE p.idplaylisty = z.idplaylisty);
-- zad 5

CREATE OR REPLACE FUNCTION uzupelnij_playliste(idplaylisty_od INT, idplaylisty_do INT, polub BOOL)
    RETURNS TABLE
            (
                idutworu_ INTEGER,
                idalbumu_ INTEGER,
                nazwa_    VARCHAR(100),
                dl_       INTEGER
            )
AS

$$
DECLARE
    c1           RECORD;
    DECLARE c2   RECORD;
    DECLARE bool BOOL;
BEGIN
    FOR c1 IN SELECT *
              FROM utwory
                       JOIN zawartosc z USING (idutworu)
              WHERE z.idplaylisty = idplaylisty_od
        LOOP
            bool := FALSE;
            FOR c2 IN SELECT *
                      FROM utwory
                               JOIN zawartosc z USING (idutworu)
                      WHERE z.idplaylisty = idplaylisty_do
                LOOP
                    IF (c1.idutworu = c2.idutworu) THEN
                        IF (c1.idutworu = c2.idutworu) THEN
                            bool := TRUE;
                        END IF;
                    END LOOP;
                    IF (! bool) THEN
                        IF (polub AND (SELECT *
                                       FROM oceny
                                       WHERE idutworu = c1.idutworu
                                         AND idklienta = (SELECT idklienta
                                                          FROM playlisty
                                                          WHERE idplaylisty = idplaylisty_do)) IS NULL) THEN
                            INSERT INTO oceny
                            VALUES (c1.idutworu,
                                    (SELECT idklienta
                                     FROM playlisty
                                     WHERE idplaylisty = idplaylisty_do),
                                    TRUE);
                        END IF;
                        INSERT INTO zawartosc VALUES (idplaylisty_do, c1.idutworu);
                    END IF;

                END LOOP;
            RETURN QUERY SELECT *
                         FROM utwory u
                                  JOIN zawartosc z ON u.idutworu = z.idutworu
                         WHERE z.idplaylisty = idplaylisty_do;

        END;

$$
    LANGUAGE plpgsql;


-- zad 3

SELECT p.idplaylisty
FROM playlisty p
WHERE 300 < ALL (SELECT utwory.dlugosc
                 FROM utwory
                          JOIN zawartosc USING (idutworu)
                 WHERE playlisty.idplaylisty = p.idplaylisty)
  AND "POP" = ANY (SELECT albumy.gatunek
                   FROM albumy
                            JOIN utwory USING (idutworu)
                            JOIN zawartosc USING (idutworu)
                   WHERE playlisty.idplaylisty = p.idplaylisty);


/* --------------------------------- KOLOS B -------------------------------- */
CREATE SCHEMA spotify;

SET search_path TO spotify;

CREATE TABLE spotify.klienci
(
    idklienta        INT PRIMARY KEY,
    login            VARCHAR(50) NOT NULL,
    data_rejestracji DATE        NOT NULL,
    data_urodzenia   DATE        NOT NULL
);

CREATE TABLE spotify.playlisty
(
    idplaylisty INT PRIMARY KEY,
    idklienta   INT REFERENCES klienci (idklienta) NOT NULL,
    nazwa       VARCHAR(30)                        NOT NULL CHECK (LENGTH(nazwa) >= 5)

);
ALTER TABLE wykonawcy
    ADD CONSTRAINT chuj CHECK kraj IN ("Polska", "Niemcy", "Twstara");

-- zad4
SELECT p.idplaylisty
FROM playlisty p
WHERE (300 < ANY (SELECT dlugosc
                  FROM utowry
                           NATURAL JOIN zawartosc
                  WHERE zawartosc.idplaylisty = p.idplaylisty))
  AND ('POP' = ALL (SELECT gatunek
                    FROM albumy a
                             NATURAL JOIN utwory
                             NATURAL JOIN zawartosc
                    WHERE zawartosc.idplaylisty = p.idplaylisty));



