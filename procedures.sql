CREATE PROCEDURE BoroughCases()
BEGIN
    SELECT b.boro_name as Borough, SUM(`4-16-2020_Positive`) as PositiveCases
    FROM Cases c
    JOIN ZipCodes z ON c.GEOID10 = z.GEOID10
    JOIN Boroughs b ON z.boro_code = b.boro_code
    GROUP BY boro_name;
END;

# CREATE PROCEDURE AllBoroughCases()
# BEGIN
#     CREATE TEMPORARY TABLE IF NOT EXISTS cases
#     SELECT b.boro_name as Borough, SUM(`4-16-2020_Positive`) as PositiveCases
#     FROM Cases c
#     JOIN ZipCodes z ON c.GEOID10 = z.GEOID10
#     JOIN Boroughs b ON z.boro_code = b.boro_code
#     GROUP BY boro_name;
#
#     CREATE TEMPORARY TABLE IF NOT EXISTS patients
#     SELECT b.boro_name as Borough, SUM(RESULTS) as PositiveCases
#     FROM PatientTests pt
#     JOIN Patients p ON pt.PID = p.PID
#     JOIN ZipCodes z ON p.GEOID10 = z.GEOID10
#     JOIN Boroughs b ON z.boro_code = b.boro_code
#     GROUP BY boro_name;
#
#     SELECT Borough, SUM(tbl.PositiveCases) AS PositiveCases
#     FROM (SELECT * FROM cases
#     UNION ALL
#     SELECT * FROM patients) tbl
#     GROUP BY Borough;
# END;

CREATE PROCEDURE AllBoroughCases()
BEGIN
    SELECT Borough, SUM(tbl.PositiveCases) AS PositiveCases
    FROM (SELECT * FROM (SELECT b.boro_name as Borough, SUM(`4-16-2020_Positive`) as PositiveCases
    FROM Cases c
    JOIN ZipCodes z ON c.GEOID10 = z.GEOID10
    JOIN Boroughs b ON z.boro_code = b.boro_code
    GROUP BY boro_name) cases
    UNION ALL
    SELECT * FROM (SELECT b.boro_name as Borough, SUM(RESULTS) as PositiveCases
    FROM PatientTests pt
    JOIN Patients p ON pt.PID = p.PID
    JOIN ZipCodes z ON p.GEOID10 = z.GEOID10
    JOIN Boroughs b ON z.boro_code = b.boro_code
    GROUP BY boro_name) patients
        ) tbl
    GROUP BY Borough;
END;

CREATE PROCEDURE HospitalsByBorough(IN in_borough VARCHAR(32))
BEGIN
    SELECT HOSPITAL_NAME, LATITUDE, LONGITUDE
    FROM Hospitals h
    JOIN ZipCodes z ON h.GEOID10 = z.GEOID10
    JOIN Boroughs b ON z.boro_code = b.boro_code
    WHERE b.boro_name = in_borough;
END;

CREATE PROCEDURE InsertPatient(IN first_name VARCHAR(32), IN last_name VARCHAR(32), IN id INT, IN latitude FLOAT, IN longitude FLOAT, IN zip_code INT, IN symptoms TEXT)
BEGIN
START TRANSACTION;
    INSERT INTO Patients(PID, FIRST_NAME, LAST_NAME, LATITUDE, LONGITUDE, GEOID10, SYMPTOMS)
    VALUES(id, first_name, last_name, latitude, longitude, zip_code, symptoms);

    IF (SELECT EXISTS (SELECT 1
               FROM Patients
               WHERE PID = (id)))
        THEN
        INSERT INTO PatientTests(PID) VALUE(id);
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END;

CREATE PROCEDURE PatientIds()
BEGIN
    SELECT PID
    FROM Patients;
END;

CREATE PROCEDURE DeletePatient(IN in_PID INT)
BEGIN
    DELETE FROM covid_db.PatientTests WHERE PID = in_PID;
    DELETE FROM covid_db.Patients WHERE PID = in_PID;
END;

CREATE PROCEDURE UpdatePatient(IN in_PID INT, IN in_results BOOLEAN)
BEGIN
    UPDATE PatientTests
    SET RESULTS = in_results, `DATE` = (SELECT CONVERT_TZ(NOW(),'+00:00','-4:00'))
    WHERE PID = in_PID;
END;


CREATE PROCEDURE ZipByBorough(IN in_boro VARCHAR(32))
BEGIN
    SELECT z.GEOID10
    FROM ZipCodes z
    JOIN Boroughs b ON z.boro_code = b.boro_code
    WHERE b.boro_name = in_boro;
END;


CREATE PROCEDURE PopByZip(IN in_boro VARCHAR(32))
BEGIN
    SELECT *
    FROM ZipCodes z
    JOIN Demographics d on z.GEOID10 = d.GEOID10
    JOIN Boroughs b ON z.boro_code = b.boro_code
    WHERE b.boro_name = in_boro;
END;