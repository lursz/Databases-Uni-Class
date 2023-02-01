-- 2021.2
CREATE OR REPLACE FUNCTION fn_Reservations()
    RETURNS TRIGGER AS
$$
BEGIN
    IF new.isCancelled = TRUE THEN
        UPDATE daysreservations
        SET isCancelled = TRUE
        WHERE reservationID = new.reservationID;
        UPDATE EventsReservations
        SET isCancelled = TRUE
        WHERE reservationID = new.reservationID;
    END IF;
END;
$$
    LANGUAGE plpgsql;

CREATE TRIGGER tr_eventsReservations
    AFTER UPDATE
    ON Reservations
    FOR EACH ROW
EXECUTE PROCEDURE fn_Reservations()

-- 2021.1
WITH most_reservations AS (SELECT r.participantID,
                                  p.firstName,
                                  p.lastName,
                                  SUM(DATE_PART('day', c.endDate) - DATE_PART('day', c.startDate)) AS days_sum
                           FROM participants
                                    NATURAL JOIN Reservations r
                                    NATURAL JOIN Conferences c
                           WHERE r.isPaid = TRUE
                             AND r.isCancelled = FALSE
                           GROUP BY participantID;
)
SELECT participantID, firstName, lastName
FROM most_reservations
WHERE days_sum = (SELECT MAX(days_sum) FROM most_reservation)

-- 2021.3
CREATE ROLE biuro;
CREATE ROLE anna LOGIN;
GRANT biuro TO anna;
GRANT INSERT, UPDATE ON TABLE DaysReservations TO GROUP biuro;
GRANT INSERT, UPDATE ON TABLE Reservations TO GROUP biuro;
GRANT INSERT, UPDATE ON TABLE EventsReservations TO GROUP biuro;
REVOKE DELETE ON TABLE DaysReservations FROM GROUP biuro;
REVOKE DELETE ON TABLE Reservations FROM GROUP biuro;
REVOKE DELETE ON TABLE EventsReservations FROM GROUP biuro;


-- 2019.3
CREATE ROLE staff;
CREATE ROLE ewa LOGIN;
CREATE ROLE adam LOGIN;
GRANT UPDATE ON DaysReservations, EventsReservations, Reservations TO staff;
GRANT INSERT ON Conferences, ConferenceDays, ConferenceEvents TO ewa;

-- 2019.2
CREATE OR REPLACE FUNCTION fn_afterEventsReservation()
    RETURNS TRIGGER AS
$$
DECLARE
    date_            DATE;
    conferencedayid_ INT;
BEGIN
    SELECT eventDate
    INTO date_
    FROM ConferenceEvents
             NATURAL JOIN EventsReservations
    WHERE participantID = new.participantID
      AND conferenceEventID = new.conferenceEventID;

    IF ! EXISTS(SELECT conferenceDayID INTO conferencedayid_ FORM DaysReservations NATURAL JOIN ConferenceDays WHERE
                DaysReservations.participantID = new.participantID AND conferenceDays.date = date_)
    THEN
        INSERT INTO DaysReservations (reservationID, conferenceDayID, participantID, specialDiscount, isCancelled)
        VALUES (new.reservationID, conferencedayid_, new.participantID, new.specialDiscount, FALSE);
    END IF;
END;
$$ LANGUAGE PLPGSQL;

CREATE TRIGGER tr_afterEventsReservation
    AFTER INSERT
    ON EventsReservations
    FOR EACH ROW
EXECUTE PROCEDURE fn_afterEventsReservation();

-- 2019.1

SELECT (SELECT SUM(ConferenceDays.price - (ConferenceDays.price * studentDiscount))
        FROM Reservations
                 NATURAL JOIN DaysReservations
                 NATURAL JOIN ConferenceDays
        WHERE DaysReservations.reservationID = 7
          AND DaysReservations.isCancelled = FALSE
          AND Reservations.isCancelled = FALSE)
           +
       (SELECT SUM(ConferenceEvents.price - (ConferenceEvents.price * studentDiscount))
        FROM Reservations
                 NATURAL JOIN EventsReservations
                 NATURAL JOIN ConferenceEvents
        WHERE EventsReservations.reservationID = 7
          AND EventsReservations.isCancelled = FALSE
          AND Reservations.isCancelled = FALSE)
           /
       (SELECT COUNT(DaysReservation.participantID)
        FROM Reservations
                 NATURAL JOIN EventsReservations
                 NATURAL JOIN ConferenceEvents
        WHERE EventsReservations.reservationID = 7
          AND EventsReservations.isCancelled = FALSE
          AND Reservations.isCancelled = FALSE)


-- 2017.3
CREATE ROLE adam LOGIN;
CREATE ROLE ewa LOGIN;
CREATE ROLE karol LOGIN;
CREATE ROLE dzial_pomiarow;
GRANT dzial_pomiarow TO adam, ewa, karol;
REVOKE ALL PRIVILEGES ON pomiary, ostrzezenia FROM PUBLIC;
GRANT SELECT, UPDATE, INSERT, DELETE ON pomiary, ostrzezenia TO dzial_pomiarow;

CREATE ROLE adam LOGIN;
CREATE ROLE dzal_zamowien;
GRANT dzial_zamowien TO adam;
REVOKE ALL PRIVILEGES ON zamowione_meble, zamowione_paczki, zamowienia FROM PUBLIC;
GRANT SELECT, INSERT, UPDATE, DELETE ON zamowione_meble, zamowione_paczki, zamowienia TO dzial_zamowien;


