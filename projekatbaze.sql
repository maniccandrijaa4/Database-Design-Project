/*CREATE SCHEMA RezervacijaKursa
go*/

IF OBJECT_ID('RezervacijaKursa.Rezervacija', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Rezervacija;
GO

IF OBJECT_ID('RezervacijaKursa.Radi', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Radi;
GO

IF OBJECT_ID('RezervacijaKursa.Kurs', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Kurs;
GO

IF OBJECT_ID('RezervacijaKursa.UlazniTest', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.UlazniTest;
GO

IF OBJECT_ID('RezervacijaKursa.Kandidat', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Kandidat;
GO

IF OBJECT_ID('RezervacijaKursa.Nivo', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Nivo;
GO

IF OBJECT_ID('RezervacijaKursa.Intenzitet', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Intenzitet;
GO

IF OBJECT_ID('RezervacijaKursa.Jezik', 'U') IS NOT NULL
    DROP TABLE RezervacijaKursa.Jezik;
GO

--seq
IF OBJECT_ID('RezervacijaKursa.RezervacijaSeq', 'SO') IS NOT NULL
    DROP SEQUENCE RezervacijaKursa.RezervacijaSeq;
GO

CREATE SEQUENCE RezervacijaKursa.RezervacijaSeq
START WITH 1
INCREMENT BY 1;
go

IF OBJECT_ID('RezervacijaKursa.KandidatSeq', 'SO') IS NOT NULL
    DROP SEQUENCE RezervacijaKursa.KandidatSeq;
GO

CREATE SEQUENCE RezervacijaKursa.KandidatSeq
START WITH 1
INCREMENT BY 1;
go


--ddl
CREATE TABLE RezervacijaKursa.Kandidat(
kandidatID INT NOT NULL PRIMARY KEY DEFAULT (NEXT VALUE FOR RezervacijaKursa.KandidatSeq),
ime VARCHAR(20) NOT NULL,
prezime VARCHAR(20) NOT NULL,
email VARCHAR(25) NULL UNIQUE,
telefon VARCHAR(12) NULL UNIQUE
);
go

CREATE TABLE RezervacijaKursa.Nivo(
nivoID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
naziv VARCHAR(20) NULL,
oznaka VARCHAR(20) NOT NULL,
opis VARCHAR(20) NOT NULL,
CONSTRAINT CK_Nivo_oznaka CHECK (oznaka IN ('A1', 'A2', 'B1', 'B2', 'C1', 'C2'))
);
go

CREATE TABLE RezervacijaKursa.Intenzitet(
intenzitetID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
tip VARCHAR(20) NOT NULL,
CONSTRAINT CK_Intenzitet_tip CHECK (tip IN ('Osnovni', 'Srednji', 'Intenzivni'))
);
go

CREATE TABLE RezervacijaKursa.Jezik(
jezikID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
naziv VARCHAR(20) NOT NULL
);
go

CREATE TABLE RezervacijaKursa.UlazniTest(
ulazniTestID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
brojPoena INT NOT NULL,
datumRada DATE NOT NULL DEFAULT GETDATE(),
nivoID INT NOT NULL,
jezikID INT NOT NULL,
CONSTRAINT FK_UlazniTest_Nivo FOREIGN KEY (nivoID) REFERENCES RezervacijaKursa.Nivo(nivoID),
CONSTRAINT FK_UlazniTest_Jezik FOREIGN KEY (jezikID) REFERENCES RezervacijaKursa.Jezik(jezikID),
CONSTRAINT CK_BrojPoeni CHECK (brojPoena BETWEEN 0 AND 100)
);
go

CREATE TABLE RezervacijaKursa.Radi(
osvojeniPoeni INT NOT NULL,
kandidatID INT NOT NULL,
ulazniTestID INT NOT NULL,
CONSTRAINT PK_Rad PRIMARY KEY (kandidatID, ulazniTestID),
CONSTRAINT FK_Rad_Kandidat FOREIGN KEY (kandidatID) REFERENCES RezervacijaKursa.Kandidat(kandidatID),
CONSTRAINT FK_Rad_UlazniTest FOREIGN KEY (ulazniTestID) REFERENCES RezervacijaKursa.UlazniTest(ulazniTestID),
CONSTRAINT CK_OsvojeniPoeni CHECK (osvojeniPoeni BETWEEN 0 AND 100)
);
go 

CREATE TABLE RezervacijaKursa.Kurs(
kursID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
aktivan BIT NOT NULL,
naziv VARCHAR(20) NULL,
minPolaznika INT NOT NULL,
maxPolaznika INT NOT NULL,
nivoID INT NOT NULL,
intenzitetID INT NOT NULL,
jezikID INT NOT NULL,
CONSTRAINT FK_Kurs_Nivo FOREIGN KEY (nivoID) REFERENCES RezervacijaKursa.Nivo(nivoID),
CONSTRAINT FK_Kurs_Intenzitet FOREIGN KEY (intenzitetID) REFERENCES RezervacijaKursa.Intenzitet(intenzitetID),
CONSTRAINT FK_Kurs_Jezik FOREIGN KEY (jezikID) REFERENCES RezervacijaKursa.Jezik(jezikID),
CONSTRAINT CK_Kurs_min CHECK (minPolaznika >= 1),
CONSTRAINT CK_Kurs_max CHECK (maxPolaznika <=60)
);
go

CREATE TABLE RezervacijaKursa.Rezervacija(
rezervacijaID INT NOT NULL DEFAULT (NEXT VALUE FOR RezervacijaKursa.RezervacijaSeq),
datumRez DATE NOT NULL DEFAULT GETDATE(),
kursID INT NOT NULL,
kandidatID INT NOT NULL,
CONSTRAINT PK_Rezervacija PRIMARY KEY (rezervacijaID, kursID),
CONSTRAINT FK_Rezervacija_Kurs FOREIGN KEY (kursID) REFERENCES RezervacijaKursa.Kurs(kursID),
CONSTRAINT FK_Rervacija_Kandidat FOREIGN KEY (kandidatID) REFERENCES RezervacijaKursa.Kandidat(kandidatID)
);
go


--dml
INSERT INTO RezervacijaKursa.Nivo (naziv, oznaka, opis) VALUES 
('Početni 1', 'A1', 'Nivo A1.1'),
('Početni 2', 'A1', 'Nivo A1.2'),
('Osnovni 1', 'A2', 'Nivo A2.1'),
('Osnovni 2', 'A2', 'Nivo A2.2'),
('Srednji 1', 'B1', 'Nivo B1.1'),
('Srednji 2', 'B1', 'Nivo B1.2'),
('Viši srednji 1', 'B2', 'Nivo B2.1'),
('Viši srednji 2', 'B2', 'Nivo B2.2'),
('Napredni 1', 'C1', 'Nivo C1.1'),
('Ekspertski 1', 'C2', 'Nivo C2.1');

INSERT INTO RezervacijaKursa.Intenzitet (tip) VALUES 
('Osnovni'), ('Srednji'), ('Intenzivni'), 
('Osnovni'), ('Srednji'), ('Intenzivni'), 
('Osnovni'), ('Srednji'), ('Intenzivni'), 
('Intenzivni');

INSERT INTO RezervacijaKursa.Jezik (naziv) VALUES 
('Engleski'), ('Nemački'), ('Francuski'), ('Italijanski'), ('Španski'), 
('Ruski'), ('Norveški'), ('Švedski'), ('Kineski'), ('Japanski');

INSERT INTO RezervacijaKursa.Kandidat (ime, prezime, email, telefon) VALUES 
('Marko', 'Marković', 'marko@mail.com', '064111222'),
('Ana', 'Anić', 'ana@mail.com', '064333444'),
('Petar', 'Petrović', 'petar@mail.com', '065555666'),
('Jelena', 'Jelić', 'jelena@mail.com', '061777888'),
('Nikola', 'Nikić', 'nikola@mail.com', '062999000'),
('Sara', 'Sarić', 'sara@mail.com', '063123456'),
('Luka', 'Lukić', 'luka@mail.com', '066456789'),
('Milica', 'Milić', 'milica@mail.com', '060111999'),
('Stefan', 'Stević', 'stefan@mail.com', '069222888'),
('Ivana', 'Ivić', 'ivana@mail.com', '067333777');

INSERT INTO RezervacijaKursa.UlazniTest (brojPoena, datumRada, nivoID, jezikID) VALUES 
(85, '2026-05-01', 1, 1),
(45, '2026-05-02', 2, 2),
(92, '2026-05-03', 9, 1),
(70, '2026-05-04', 5, 3),
(30, '2026-05-05', 1, 5),
(100, '2026-05-06', 10, 1),
(55, '2026-05-07', 3, 2),
(88, '2026-05-08', 7, 1),
(62, '2026-05-09', 5, 4),
(75, '2026-05-10', 8, 2);

INSERT INTO RezervacijaKursa.Radi (osvojeniPoeni, kandidatID, ulazniTestID) VALUES 
(85, 1, 1), (45, 2, 2), (92, 3, 3), (70, 4, 4), (30, 5, 5),
(100, 6, 6), (55, 7, 7), (88, 8, 8), (62, 9, 9), (75, 10, 10);

INSERT INTO RezervacijaKursa.Kurs (aktivan, naziv, minPolaznika, maxPolaznika, nivoID, intenzitetID, jezikID) VALUES 
(1, 'Engleski A1', 5, 12, 1, 1, 1),
(1, 'Nemački A1', 4, 10, 2, 2, 2),
(1, 'Engleski C1', 3, 8, 9, 3, 1),
(0, 'Francuski B1', 5, 12, 5, 1, 3),
(1, 'Španski A1', 6, 15, 1, 1, 5),
(1, 'Ruski A2', 4, 10, 3, 2, 6),
(1, 'Engleski B2', 5, 12, 7, 3, 1),
(1, 'Italijanski B1', 4, 10, 5, 1, 4),
(1, 'Norveški A1', 3, 6, 1, 1, 7),
(0, 'Japanski A1', 2, 5, 1, 1, 10);

INSERT INTO RezervacijaKursa.Rezervacija (datumRez, kursID, kandidatID) VALUES 
('2026-05-01', 1, 1),
('2026-05-01', 1, 2),
('2026-05-02', 2, 3),
('2026-05-03', 3, 4),
('2026-05-04', 5, 5),
('2026-05-05', 6, 6),
('2026-05-05', 7, 7),
('2026-05-06', 8, 8),
('2026-05-07', 1, 9),
('2026-05-08', 2, 10);

--upiti
--prvi

SELECT UPPER(k.ime) AS ImeKandidata, LOWER(k.prezime) AS PrezimeKandidata, LTRIM(RTRIM(ku.naziv)) AS Kurs, 
STUFF(n.oznaka, 1, 0, 'Nivo-') AS OznakaNivoa,
CASE 
    WHEN ku.naziv LIKE '%A%' THEN 'Osnovni'
    WHEN ku.naziv LIKE '%B' THEN 'Srednji'
    ELSE 'Napredni'
END AS TipKursa
FROM RezervacijaKursa.Kandidat k
JOIN RezervacijaKursa.Rezervacija r ON k.kandidatID = r.kandidatID
JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
JOIN RezervacijaKursa.Nivo n ON ku.nivoID = n.nivoID;


--drugi

SELECT UPPER(ku.naziv) AS Kurs, UPPER(j.naziv) AS Jezik, n.oznaka AS Nivo, COUNT(r.rezervacijaID) AS BrojNaListiCekanja,
MIN(r.datumRez) AS PrvaRezervacija, MAX(r.datumRez) AS PoslednjaRezervacija, DATEDIFF(DAY, MIN(r.datumRez), 
MAX(r.datumRez)) AS RasponDana, CONVERT(VARCHAR(10), DATEADD(DAY, 30, MAX(r.datumRez)), 104) AS OcekivaniPocetak
FROM RezervacijaKursa.Kurs ku
JOIN RezervacijaKursa.Rezervacija r ON ku.kursID = r.kursID
JOIN RezervacijaKursa.Jezik j ON ku.jezikID = j.jezikID
JOIN RezervacijaKursa.Nivo n ON ku.nivoID = n.nivoID
GROUP BY ku.naziv, j.naziv, n.oznaka;

--treci

SELECT k.ime, k.prezime, ra.osvojeniPoeni,(CAST(ra.osvojeniPoeni AS NVARCHAR(20)) + '%') AS ProcentualniUspeh,
CASE 
   WHEN ra.osvojeniPoeni >= 90 THEN 'Odlican'
   WHEN ra.osvojeniPoeni >= 75 THEN 'Vrlo dobar'
   WHEN ra.osvojeniPoeni >= 50 THEN 'Dovoljan'
   ELSE 'Nedovoljan'
END AS EvaluacijaTesta
FROM RezervacijaKursa.Kandidat k
JOIN RezervacijaKursa.Radi ra ON k.kandidatID = ra.kandidatID
WHERE ra.osvojeniPoeni > (
    SELECT AVG(CAST(osvojeniPoeni AS NUMERIC(10,2))) FROM RezervacijaKursa.Radi
);

--cetvrti

SELECT k.ime + ' ' + k.prezime AS Polaznik, j.naziv AS Jezik, i.tip AS Intenzitet, r.datumRez
FROM RezervacijaKursa.Kandidat k
JOIN RezervacijaKursa.Rezervacija r ON k.kandidatID = r.kandidatID
JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
JOIN RezervacijaKursa.Jezik j ON ku.jezikID = j.jezikID
JOIN RezervacijaKursa.Intenzitet i ON ku.intenzitetID = i.intenzitetID
WHERE MONTH(r.datumRez) = 5 AND YEAR(r.datumRez) = 2026;

--peti

SELECT CONCAT(LTRIM(RTRIM(k.ime)), ' ', LTRIM(RTRIM(k.prezime))) AS Polaznik, j.naziv AS Jezik, 
LOWER(i.tip) AS IntenzitetKursa, CONVERT(VARCHAR(10), r.datumRez, 104) AS FormatiranDatumRezervacije,
CASE 
  WHEN CAST(r.datumRez AS DATE) = EOMONTH(r.datumRez) THEN 'Last-Minute upis'
  ELSE 'Regularan period upisa'
END AS StatusUpisa
FROM RezervacijaKursa.Kandidat k
JOIN RezervacijaKursa.Rezervacija r ON k.kandidatID = r.kandidatID
JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
JOIN RezervacijaKursa.Jezik j ON ku.jezikID = j.jezikID
JOIN RezervacijaKursa.Intenzitet i ON ku.intenzitetID = i.intenzitetID
WHERE MONTH(r.datumRez) = 5 AND YEAR(r.datumRez) = 2026;


--index

CREATE NONCLUSTERED INDEX IDX_Kandidat_Prezime
ON RezervacijaKursa.Kandidat (prezime) INCLUDE (ime, email);
GO
SELECT prezime, ime, email 
FROM RezervacijaKursa.Kandidat 
WHERE prezime = 'Marković';
GO

--procedure


--kandidat radi ulazni test, na osnovu poena se kroz CASE određuje nivo (A1-C2), 
--evidentira se test u UlazniTest i Radi, a kursor traži aktivan kurs za taj jezik/nivo i vraća ga kroz OUTPUT. Sve u TRY/CATCH sa THROW za greške.
--prva
IF OBJECT_ID('RezervacijaKursa.usp_EvidentirajTestIDodeliKurs', 'P') IS NOT NULL
    DROP PROC RezervacijaKursa.usp_EvidentirajTestIDodeliKurs;
GO

CREATE PROC RezervacijaKursa.usp_EvidentirajTestIDodeliKurs
    @kandidatID INT,
    @jezikID INT,
    @poeni INT,
    @kursID INT = NULL OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM RezervacijaKursa.Kandidat WHERE kandidatID = @kandidatID)
            THROW 50001, 'Greska: Kandidat sa datim ID ne postoji.', 1;

        IF NOT EXISTS (SELECT 1 FROM RezervacijaKursa.Jezik WHERE jezikID = @jezikID)
            THROW 50002, 'Greska: Jezik sa datim ID ne postoji.', 1;

        IF @poeni < 0 OR @poeni > 100
            THROW 50003, 'Greska: Broj poena mora biti izmedju 0 i 100.', 1;

        DECLARE @oznakaNivoa VARCHAR(2);

        SET @oznakaNivoa = CASE
            WHEN @poeni BETWEEN  0 AND  15 THEN 'A1'
            WHEN @poeni BETWEEN 16 AND  30 THEN 'A2'
            WHEN @poeni BETWEEN 31 AND  45 THEN 'B1'
            WHEN @poeni BETWEEN 46 AND  60 THEN 'B1'
            WHEN @poeni BETWEEN 61 AND  75 THEN 'B2'
            WHEN @poeni BETWEEN 76 AND  90 THEN 'C1'
            WHEN @poeni BETWEEN 91 AND 100 THEN 'C2'
        END;

        DECLARE @nivoID INT;

        SELECT TOP 1 @nivoID = nivoID 
        FROM RezervacijaKursa.Nivo 
        WHERE oznaka = @oznakaNivoa;

        IF @nivoID IS NULL
            THROW 50004, 'Greska: Nije pronadjen odgovarajuci nivo za date poene.', 1;

        DECLARE @ulazniTestID INT;

        INSERT INTO RezervacijaKursa.UlazniTest (brojPoena, datumRada, nivoID, jezikID)
        VALUES (@poeni, GETDATE(), @nivoID, @jezikID);

        SET @ulazniTestID = SCOPE_IDENTITY();

        INSERT INTO RezervacijaKursa.Radi (osvojeniPoeni, kandidatID, ulazniTestID)
        VALUES (@poeni, @kandidatID, @ulazniTestID);

        PRINT 'Test evidentiran | KandidatID: ' + CAST(@kandidatID AS VARCHAR) +
              ' | Poeni: ' + CAST(@poeni AS VARCHAR) +
              ' | Nivo: ' + @oznakaNivoa;

        DECLARE @pronadjeniKursID INT;
        DECLARE @pronadjeniNaziv VARCHAR(20);
        DECLARE @pronadjen BIT = 0;

        DECLARE kursor_kursevi CURSOR FOR
            SELECT ku.kursID, ku.naziv
            FROM RezervacijaKursa.Kurs ku
            WHERE ku.jezikID = @jezikID
              AND ku.nivoID = @nivoID
              AND ku.aktivan = 1;

        OPEN kursor_kursevi;
        FETCH NEXT FROM kursor_kursevi INTO @pronadjeniKursID, @pronadjeniNaziv;

        WHILE @@FETCH_STATUS = 0 AND @pronadjen = 0
        BEGIN
            SET @kursID = @pronadjeniKursID;
            SET @pronadjen = 1;

            PRINT 'Pronadjen odgovarajuci kurs: ' + ISNULL(@pronadjeniNaziv, 'Bez naziva') +
                  ' (KursID: ' + CAST(@pronadjeniKursID AS VARCHAR) + ')';

            FETCH NEXT FROM kursor_kursevi INTO @pronadjeniKursID, @pronadjeniNaziv;
        END

        CLOSE kursor_kursevi;
        DEALLOCATE kursor_kursevi;

        IF @pronadjen = 0
            PRINT 'Napomena: Nema aktivnog kursa za nivo ' + @oznakaNivoa + ' i odabrani jezik.';

    END TRY
    BEGIN CATCH
        PRINT 'GRESKA: ' + ERROR_MESSAGE();

        CLOSE kursor_kursevi;
        DEALLOCATE kursor_kursevi;

    END CATCH

END;
GO

--test
DECLARE @predlozenKurs INT;
EXEC RezervacijaKursa.usp_EvidentirajTestIDodeliKurs
    @kandidatID = 5,
    @jezikID = 1,
    @poeni = 85,
    @kursID = @predlozenKurs OUTPUT;
SELECT @predlozenKurs AS 'ID predlozenog kursa';
GO

EXEC RezervacijaKursa.usp_EvidentirajTestIDodeliKurs
    @kandidatID = 5,
    @jezikID = 1,
    @poeni = 90;
GO






--kursor prolazi kroz sve neaktivne kurseve i briše sve kandidate sa liste čekanja za njih, kroz OUTPUT vraća ukupan broj obrisanih.
--druga
IF OBJECT_ID('RezervacijaKursa.usp_OtkaziRezervacijeNeaktivnihKurseva', 'P') IS NOT NULL
    DROP PROC RezervacijaKursa.usp_OtkaziRezervacijeNeaktivnihKurseva;
GO

CREATE PROC RezervacijaKursa.usp_OtkaziRezervacijeNeaktivnihKurseva
    @brojObrisanih INT = 0 OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RezervacijaKursa.Kurs WHERE aktivan = 0)
    BEGIN
        PRINT 'Nema neaktivnih kurseva, nista nije obrisano.';
        RETURN;
    END

    IF NOT EXISTS (
        SELECT 1 FROM RezervacijaKursa.Rezervacija r
        JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
        WHERE ku.aktivan = 0
    )
    BEGIN
        PRINT 'Nema rezervacija za neaktivne kurseve.';
        RETURN;
    END


    DECLARE @kursID INT;
    DECLARE @nazivKursa VARCHAR(20);
    DECLARE @obrisanoZaKurs INT;

    DECLARE kursor_neaktivni CURSOR FOR
        SELECT DISTINCT ku.kursID, ku.naziv
        FROM RezervacijaKursa.Kurs ku
        JOIN RezervacijaKursa.Rezervacija r ON ku.kursID = r.kursID
        WHERE ku.aktivan = 0;

    OPEN kursor_neaktivni;
    FETCH NEXT FROM kursor_neaktivni INTO @kursID, @nazivKursa;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM RezervacijaKursa.Rezervacija
        WHERE kursID = @kursID;

        SET @obrisanoZaKurs = @@ROWCOUNT;
        SET @brojObrisanih = @brojObrisanih + @obrisanoZaKurs;

        PRINT 'Kurs: ' + ISNULL(@nazivKursa, 'Bez naziva') + 
              ' (ID: ' + CAST(@kursID AS VARCHAR) + ')' +
              ' | Obrisano kandidata sa liste cekanja: ' + CAST(@obrisanoZaKurs AS VARCHAR);

        FETCH NEXT FROM kursor_neaktivni INTO @kursID, @nazivKursa;
    END

    CLOSE kursor_neaktivni;
    DEALLOCATE kursor_neaktivni;

    PRINT '----------------------------------------------';
    PRINT 'Ukupno obrisanih sa liste cekanja: ' + CAST(@brojObrisanih AS VARCHAR);

END;
GO


--test
DECLARE @obrisano INT;
EXEC RezervacijaKursa.usp_OtkaziRezervacijeNeaktivnihKurseva
    @brojObrisanih = @obrisano OUTPUT;
SELECT @obrisano AS 'Ukupno obrisanih sa liste cekanja';
GO

EXEC RezervacijaKursa.usp_OtkaziRezervacijeNeaktivnihKurseva;
GO




--fn

--Multi-Statement Table-Valued funkcija, vraća tabelu sa analizom kandidata (ime, email,
--jezik, poeni, procenat, nivo, rang, status na listi čekanja, rezervisani kurs, datum). Prima minimalan broj poena i opciono jezik.
IF OBJECT_ID('RezervacijaKursa.NaprednaAnalizaKandidata', 'TF') IS NOT NULL 
    DROP FUNCTION RezervacijaKursa.NaprednaAnalizaKandidata;
GO

CREATE FUNCTION RezervacijaKursa.NaprednaAnalizaKandidata (
    @kriterijum_poena INT,
    @jezikID INT = NULL
)
RETURNS @StatistikaTablica TABLE (
    KandidatID INT,
    Polaznik VARCHAR(45),
    KontaktEmail VARCHAR(25),
    Jezik VARCHAR(20),
    Intenzitet VARCHAR(20),
    OsvojeniPoeni INT,
    ProcenatUspeha NVARCHAR(20),
    OdredjenNivo VARCHAR(2),
    RangKandidata VARCHAR(30),
    StatusNaListi VARCHAR(20),
    RezervisaniKurs VARCHAR(20),
    DatumUpisa VARCHAR(10)
)
AS
BEGIN
    INSERT INTO @StatistikaTablica
    SELECT 
        k.kandidatID,
        CONCAT(LTRIM(RTRIM(k.ime)), ' ', LTRIM(RTRIM(k.prezime))) AS Polaznik,
        ISNULL(k.email, 'Nema email') AS KontaktEmail, j.naziv AS Jezik,
        ISNULL(i.tip, 'Nema kursa') AS Intenzitet, ra.osvojeniPoeni AS OsvojeniPoeni,
        (CAST(ra.osvojeniPoeni AS NVARCHAR(20)) + '%') AS ProcenatUspeha,
        CASE
            WHEN ra.osvojeniPoeni BETWEEN  0 AND 15  THEN 'A1'
            WHEN ra.osvojeniPoeni BETWEEN 16 AND 30  THEN 'A2'
            WHEN ra.osvojeniPoeni BETWEEN 31 AND 45  THEN 'B1'
            WHEN ra.osvojeniPoeni BETWEEN 46 AND 60  THEN 'B1'
            WHEN ra.osvojeniPoeni BETWEEN 61 AND 75  THEN 'B2'
            WHEN ra.osvojeniPoeni BETWEEN 76 AND 90  THEN 'C1'
            ELSE                                          'C2'
        END AS OdredjenNivo,
        CASE 
            WHEN ra.osvojeniPoeni >= 90 THEN 'Izuzetan (Nivo C2/C1)'
            WHEN ra.osvojeniPoeni >= 75 THEN 'Prosecan (Nivo B2/B1)'
            WHEN ra.osvojeniPoeni >= 50 THEN 'Dovoljan (Nivo B1/A2)'
            ELSE 'Ispod proseka (Potreban A1/A2)'
        END AS RangKandidata,
        CASE
            WHEN r.rezervacijaID IS NOT NULL THEN 'Na listi cekanja'
            ELSE 'Nije na listi'
        END AS StatusNaListi,

        ISNULL(ku.naziv, 'Nema rezervacije') AS RezervisaniKurs,

        ISNULL(CONVERT(VARCHAR(10), r.datumRez, 104), 'Nije upisan') AS DatumUpisa

    FROM RezervacijaKursa.Kandidat k
    JOIN RezervacijaKursa.Radi ra ON k.kandidatID = ra.kandidatID
    JOIN RezervacijaKursa.UlazniTest ut ON ra.ulazniTestID = ut.ulazniTestID
    JOIN RezervacijaKursa.Jezik j ON ut.jezikID = j.jezikID
    LEFT JOIN RezervacijaKursa.Rezervacija r ON k.kandidatID = r.kandidatID
    LEFT JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
    LEFT JOIN RezervacijaKursa.Intenzitet i ON ku.intenzitetID = i.intenzitetID
    WHERE ra.osvojeniPoeni >= @kriterijum_poena
      AND (@jezikID IS NULL OR ut.jezikID = @jezikID);

    RETURN;
END;
GO

-- test
SELECT *
FROM RezervacijaKursa.NaprednaAnalizaKandidata(50, NULL);
GO

SELECT *
FROM RezervacijaKursa.NaprednaAnalizaKandidata(70, 3);
GO

--trigeri


--kad kandidat položi novi test, kursor briše njegove stare rezervacije za isti jezik ali drugačiji nivo jer više ne odgovaraju.
--prvi
IF OBJECT_ID('RezervacijaKursa.tr_ObrisiZastareluRezervaciju', 'TR') IS NOT NULL
    DROP TRIGGER RezervacijaKursa.tr_ObrisiZastareluRezervaciju;
GO

CREATE TRIGGER RezervacijaKursa.tr_ObrisiZastareluRezervaciju
ON RezervacijaKursa.Radi
AFTER INSERT
AS
BEGIN
    IF @@ROWCOUNT = 0 RETURN;

    SET NOCOUNT ON;

    BEGIN TRY

        DECLARE @kandidatID INT;
        DECLARE @ulazniTestID INT;
        DECLARE @noviNivoID INT;
        DECLARE @jezikID INT;
        DECLARE @stariKursID INT;
        DECLARE @stariNaziv VARCHAR(20);
        DECLARE @obrisano INT = 0;

        SELECT 
            @kandidatID = i.kandidatID,
            @ulazniTestID = i.ulazniTestID,
            @noviNivoID = ut.nivoID,
            @jezikID = ut.jezikID
        FROM inserted i
        JOIN RezervacijaKursa.UlazniTest ut ON i.ulazniTestID = ut.ulazniTestID;

    
        DECLARE kursor_rezervacije CURSOR FOR
            SELECT r.kursID, ku.naziv
            FROM RezervacijaKursa.Rezervacija r
            JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
            WHERE r.kandidatID = @kandidatID
              AND ku.jezikID = @jezikID
              AND ku.nivoID != @noviNivoID;

        OPEN kursor_rezervacije;
        FETCH NEXT FROM kursor_rezervacije INTO @stariKursID, @stariNaziv;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DELETE FROM RezervacijaKursa.Rezervacija
            WHERE kandidatID = @kandidatID
              AND kursID = @stariKursID;

            SET @obrisano = @obrisano + @@ROWCOUNT;

            PRINT 'Obrisana zastarela rezervacija | Kandidat ID: ' + CAST(@kandidatID AS VARCHAR) +
                  ' | Kurs: ' + ISNULL(@stariNaziv, 'Bez naziva') +
                  ' (KursID: ' + CAST(@stariKursID AS VARCHAR) + ')';

            FETCH NEXT FROM kursor_rezervacije INTO @stariKursID, @stariNaziv;
        END

        CLOSE kursor_rezervacije;
        DEALLOCATE kursor_rezervacije;

        IF @obrisano = 0
            PRINT 'Nema zastarelih rezervacija za kandidata ID: ' + CAST(@kandidatID AS VARCHAR);
        ELSE
            PRINT 'Ukupno obrisanih zastarelih rezervacija: ' + CAST(@obrisano AS VARCHAR);

    END TRY
    BEGIN CATCH
        PRINT 'GRESKA u trigeru: ' + ERROR_MESSAGE();        
    END CATCH

END;
GO

--test
INSERT INTO RezervacijaKursa.Radi (osvojeniPoeni, kandidatID, ulazniTestID)
VALUES (95, 2, 3);
GO



--pre upisa provera da kandidat već nema rezervaciju za isti jezik i da kurs nije neaktivan, 
--tek onda dozvoljava upis na listu čekanja.
--drugi
IF OBJECT_ID('RezervacijaKursa.tr_ValidacijaRezervacije', 'TR') IS NOT NULL
    DROP TRIGGER RezervacijaKursa.tr_ValidacijaRezervacije;
GO

CREATE TRIGGER RezervacijaKursa.tr_ValidacijaRezervacije
ON RezervacijaKursa.Rezervacija
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;
    IF @@ROWCOUNT = 0 RETURN;

    SET NOCOUNT ON;

    BEGIN TRY

        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN RezervacijaKursa.Rezervacija r  ON i.kandidatID = r.kandidatID
            JOIN RezervacijaKursa.Kurs ku_novi   ON i.kursID = ku_novi.kursID
            JOIN RezervacijaKursa.Kurs ku_stari  ON r.kursID = ku_stari.kursID
            WHERE ku_novi.jezikID = ku_stari.jezikID
        )
        BEGIN
            PRINT 'GRESKA: Kandidat vec ima rezervaciju za kurs istog jezika. 
                   Dozvoljena je samo jedna rezervacija po jeziku.';
        END
        ELSE
        BEGIN
            IF EXISTS (
                SELECT 1 FROM inserted i
                JOIN RezervacijaKursa.Kurs ku ON i.kursID = ku.kursID
                WHERE ku.aktivan = 0
            )
            BEGIN
                PRINT 'GRESKA: Nije moguce rezervisati mesto na neaktivnom kursu.';
            END
            ELSE
            BEGIN
                INSERT INTO RezervacijaKursa.Rezervacija (rezervacijaID, datumRez, kursID, kandidatID)
                SELECT rezervacijaID, datumRez, kursID, kandidatID
                FROM inserted;

                PRINT 'USPEH: Kandidat je uspesno dodat na listu cekanja.';
            END
        END

    END TRY
    BEGIN CATCH
        PRINT 'GRESKA u trigeru: ' + ERROR_MESSAGE();
    END CATCH

END;
GO

--test
INSERT INTO RezervacijaKursa.Rezervacija (rezervacijaID, datumRez, kursID, kandidatID)
VALUES (20, GETDATE(), 1, 1);
GO

INSERT INTO RezervacijaKursa.Rezervacija (rezervacijaID, datumRez, kursID, kandidatID)
VALUES (21, GETDATE(), 10, 3);
GO



--kursor

--kursor prolazi red po red kroz listu čekanja za dati kurs i ispisuje redni
--broj, ime, email, jezik i datum za svakog kandidata, na kraju ukupan broj.
IF OBJECT_ID('RezervacijaKursa.IzvestajListeCekanja', 'P') IS NOT NULL
    DROP PROC RezervacijaKursa.IzvestajListeCekanja;
GO

CREATE PROC RezervacijaKursa.IzvestajListeCekanja
    @kurs_id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RezervacijaKursa.Kurs WHERE kursID = @kurs_id)
    BEGIN
        PRINT 'Greska: Kurs sa ID-jem ' + CAST(@kurs_id AS VARCHAR) + ' ne postoji.';
        RETURN;
    END

    DECLARE @ime VARCHAR(20);
    DECLARE @prezime VARCHAR(20);
    DECLARE @email VARCHAR(25);
    DECLARE @jezik VARCHAR(20);
    DECLARE @datumRez DATE;
    DECLARE @rbr INT = 1;
    DECLARE @naziv_kursa VARCHAR(20);

    SELECT @naziv_kursa = LTRIM(RTRIM(ku.naziv))
    FROM RezervacijaKursa.Kurs ku
    WHERE ku.kursID = @kurs_id;

    DECLARE kursor_lista CURSOR FOR
        SELECT 
            LTRIM(RTRIM(k.ime)),
            LTRIM(RTRIM(k.prezime)),
            ISNULL(k.email, 'Nema email'),
            j.naziv,
            r.datumRez
        FROM RezervacijaKursa.Rezervacija r
        JOIN RezervacijaKursa.Kandidat k ON r.kandidatID = k.kandidatID
        JOIN RezervacijaKursa.Kurs ku ON r.kursID = ku.kursID
        JOIN RezervacijaKursa.Jezik j ON ku.jezikID = j.jezikID
        WHERE r.kursID = @kurs_id
        ORDER BY r.datumRez ASC;

    OPEN kursor_lista;
    FETCH NEXT FROM kursor_lista INTO @ime, @prezime, @email, @jezik, @datumRez;

    IF @@FETCH_STATUS = -1
    BEGIN
        PRINT 'Nema kandidata na listi cekanja za kurs: ' + ISNULL(@naziv_kursa, 'Nepoznat');
        CLOSE kursor_lista;
        DEALLOCATE kursor_lista;
        RETURN;
    END

    PRINT '----------------------------------------------';
    PRINT 'LISTA CEKANJA ZA KURS: ' + UPPER(ISNULL(@naziv_kursa, 'Nepoznat'));
    PRINT '----------------------------------------------';

    WHILE @@FETCH_STATUS = 0
    BEGIN
        PRINT CAST(@rbr AS VARCHAR) + '. ' +
              @ime + ' ' + @prezime +
              ' | Email: ' + @email +
              ' | Jezik: ' + @jezik +
              ' | Na listi od: ' + CONVERT(VARCHAR(10), @datumRez, 104);

        SET @rbr = @rbr + 1;
        FETCH NEXT FROM kursor_lista INTO @ime, @prezime, @email, @jezik, @datumRez;
    END;

    CLOSE kursor_lista;
    DEALLOCATE kursor_lista;

    PRINT '----------------------------------------------';
    PRINT 'Ukupno na listi cekanja: ' + CAST(@rbr - 1 AS VARCHAR);

END;
GO

-- test
EXEC RezervacijaKursa.IzvestajListeCekanja @kurs_id = 1;
GO



--transakcija

--briše kandidata i sve njegove podatke (rezervacije, testove) unutar transakcije, sa #Log tabelom koja prati svaki korak. 
--Provera za "vredne" kandidate (90+ poena) traži @potvrda=1. ROLLBACK ako nešto pukne, COMMIT ako sve prođe.
IF OBJECT_ID('RezervacijaKursa.usp_ObrisiKandidata', 'P') IS NOT NULL
    DROP PROC RezervacijaKursa.usp_ObrisiKandidata;
GO

CREATE PROC RezervacijaKursa.usp_ObrisiKandidata
    @kandidatID INT,
    @potvrda BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM RezervacijaKursa.Kandidat WHERE kandidatID = @kandidatID)
    BEGIN
        PRINT 'Greska: Kandidat sa ID ' + CAST(@kandidatID AS VARCHAR) + ' ne postoji.';
        RETURN;
    END

    DECLARE @imeKandidata VARCHAR(20);
    DECLARE @prezimeKandidata VARCHAR(20);
    DECLARE @maxPoeni INT;
    DECLARE @obrisanoRez INT;
    DECLARE @obrisanoRadi INT;

    SELECT 
        @imeKandidata = ime,
        @prezimeKandidata = prezime
    FROM RezervacijaKursa.Kandidat 
    WHERE kandidatID = @kandidatID;

    SELECT @maxPoeni = MAX(osvojeniPoeni)
    FROM RezervacijaKursa.Radi
    WHERE kandidatID = @kandidatID;

    IF @maxPoeni >= 90 AND @potvrda = 0
    BEGIN
        PRINT 'UPOZORENJE: Kandidat ' + @imeKandidata + ' ' + @prezimeKandidata + 
              ' ima test sa ' + CAST(@maxPoeni AS VARCHAR) + ' poena (90+).' ;
        PRINT 'Ako ste sigurni da zelite da obrisete kandidata, pozovite proceduru sa @potvrda = 1.';
        RETURN;
    END

    CREATE TABLE #Log (
        Korak INT,
        Opis VARCHAR(100),
        BrojRedova INT,
        Vreme DATETIME DEFAULT GETDATE()
    );

    BEGIN TRANSACTION;

    BEGIN TRY

        DELETE FROM RezervacijaKursa.Rezervacija
        WHERE kandidatID = @kandidatID;

        SET @obrisanoRez = @@ROWCOUNT;

        INSERT INTO #Log (Korak, Opis, BrojRedova)
        VALUES (1, 'Obrisano sa liste cekanja (Rezervacija)', @obrisanoRez);

        DELETE FROM RezervacijaKursa.Radi
        WHERE kandidatID = @kandidatID;

        SET @obrisanoRadi = @@ROWCOUNT;

        INSERT INTO #Log (Korak, Opis, BrojRedova)
        VALUES (2, 'Obrisana evidencija testova (Radi)', @obrisanoRadi);

        DELETE FROM RezervacijaKursa.Kandidat
        WHERE kandidatID = @kandidatID;

        INSERT INTO #Log (Korak, Opis, BrojRedova)
        VALUES (3, 'Obrisan kandidat ' + @imeKandidata + ' ' + @prezimeKandidata, 1);

        COMMIT TRANSACTION;

        PRINT 'Transakcija uspesno zavrsena za kandidata: ' + @imeKandidata + ' ' + @prezimeKandidata;
        PRINT '----------------------------------------------';
        SELECT * FROM #Log ORDER BY Korak;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        INSERT INTO #Log (Korak, Opis, BrojRedova)
        VALUES (99, 'GRESKA: ' + ERROR_MESSAGE(), 0);

        PRINT 'GRESKA: ' + ERROR_MESSAGE();
        PRINT 'Transakcija ponistena, sve promene su vracene.';
        SELECT * FROM #Log ORDER BY Korak;

    END CATCH

    DROP TABLE #Log;

END;
GO


--test
EXEC RezervacijaKursa.usp_ObrisiKandidata @kandidatID = 10;
GO

EXEC RezervacijaKursa.usp_ObrisiKandidata @kandidatID = 10, @potvrda = 1;
GO

SELECT * FROM RezervacijaKursa.Kandidat  WHERE kandidatID = 9;
SELECT * FROM RezervacijaKursa.Rezervacija WHERE kandidatID = 9;
SELECT * FROM RezervacijaKursa.Radi WHERE kandidatID = 9;
GO
