CREATE TABLE Boroughs(boro_code INTEGER,
                      boro_name TEXT,
                      shape_area FLOAT,
                      shape_length FLOAT,

                      PRIMARY KEY (boro_code));


CREATE TABLE ZipCodes(ZCTA5CE10 INTEGER,
                      GEOID10 INTEGER,
                      CLASSFP10 VARCHAR(2),
                      MTFCC10 VARCHAR(5),
                      FUNCSTAT10 VARCHAR(1),
                      ALAND10 INTEGER,
                      AWATER10 INTEGER,
                      INTPTLAT10 FLOAT,
                      INTPTLON10 FLOAT,
                      boro_code INTEGER,
					  shape_length FLOAT,

                      PRIMARY KEY (GEOID10),
                      FOREIGN KEY (boro_code) REFERENCES Boroughs(boro_code));

-- NOTE MUST USE BACK TICKS FOR COL NAMES BEGINING WITH NUMBERS
CREATE TABLE Cases(GEOID10 INTEGER,
                   `4-4-2020_Positive` INTEGER,
                   `4-4-2020_Total` INTEGER,
                   `4-4-2020_zcta_cum.perc_pos` FLOAT,
                   `4-5-2020_Positive` INTEGER,
                   `4-5-2020_Total` INTEGER,
                   `4-5-2020_zcta_cum.perc_pos` FLOAT,
                   `4-6-2020_Positive` INTEGER,
                   `4-6-2020_Total` INTEGER,
                   `4-6-2020_zcta_cum.perc_pos` FLOAT,
                   `4-7-2020_Positive` INTEGER,
                   `4-7-2020_Total` INTEGER,
                   `4-7-2020_zcta_cum.perc_pos` FLOAT,
                   `4-8-2020_Positive` INTEGER,
                   `4-8-2020_Total` INTEGER,
                   `4-8-2020_zcta_cum.perc_pos` FLOAT,
                   `4-9-2020_Positive` INTEGER,
                   `4-9-2020_Total` INTEGER,
                   `4-9-2020_zcta_cum.perc_pos` FLOAT,
                   `4-10-2020_Positive` INTEGER,
                   `4-10-2020_Total` INTEGER,
                   `4-10-2020_zcta_cum.perc_pos` FLOAT,
                   `4-11-2020_Positive` INTEGER,
                   `4-11-2020_Total` INTEGER,
                   `4-11-2020_zcta_cum.perc_pos` FLOAT,
                   `4-12-2020_Positive` INTEGER,
                   `4-12-2020_Total` INTEGER,
                   `4-12-2020_zcta_cum.perc_pos` FLOAT,
                   `4-13-2020_Positive` INTEGER,
                   `4-13-2020_Total` INTEGER,
                   `4-13-2020_zcta_cum.perc_pos` FLOAT,
                   `4-14-2020_Positive` INTEGER,
                   `4-14-2020_Total` INTEGER,
                   `4-14-2020_zcta_cum.perc_pos` FLOAT,
                   `4-15-2020_Positive` INTEGER,
                   `4-15-2020_Total` INTEGER,
                   `4-15-2020_zcta_cum.perc_pos` FLOAT,
                   `4-16-2020_Positive` INTEGER,
                   `4-16-2020_Total` INTEGER,
                   `4-16-2020_zcta_cum.perc_pos` FLOAT,

                    PRIMARY KEY (GEOID10),
                    FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));


CREATE TABLE Surge(SurgeID INTEGER NOT NULL AUTO_INCREMENT,
                   HOSPITAL_NAME VARCHAR(500),
                   LICENSED_BEDS INTEGER,
                   STAFFED_BEDS INTEGER,
                   ICU_BEDS INTEGER,
                   ADULT_ICU_BEDS INTEGER,
                   PEDIATRIC_ICU_BEDS INTEGER,
                   BED_UTILIZATION_RATE FLOAT,
                   TOTAL_BEDS INTEGER,
                   POTENTIAL_BED_INCREASE INTEGER,
                   AVG_VENTILATOR_USE FLOAT,
                   LATITUDE FLOAT,
                   LONGITUDE FLOAT,
                   GEOID10 INTEGER,

                   PRIMARY KEY (SurgeID),
                   KEY (HOSPITAL_NAME),
                   FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));


CREATE TABLE Hospitals(HospitalID INTEGER NOT NULL AUTO_INCREMENT,
                       HOSPITAL_NAME VARCHAR(500),
                       LICENSED_BEDS INTEGER,
                       STAFFED_BEDS INTEGER,
                       ICU_BEDS INTEGER,
                       ADULT_ICU_BEDS INTEGER,
                       PEDIATRIC_ICU_BEDS INTEGER,
                       BED_UTILIZATION_RATE FLOAT,
                       TOTAL_BEDS INTEGER,
                       POTENTIAL_BED_INCREASE INTEGER,
                       AVG_VENTILATOR_USE FLOAT,
                       LATITUDE FLOAT,
                       LONGITUDE FLOAT,
                       GEOID10 INTEGER,

                       PRIMARY KEY (HospitalID),
                       KEY (HOSPITAL_NAME),
                       FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Buffer(BufferID INTEGER NOT NULL AUTO_INCREMENT,
                    HOSPITAL_NAME VARCHAR(500),
                    GEOID10 INTEGER NOT NULL REFERENCES ZipCodes(GEOID10),

                    PRIMARY KEY (BufferID),
                    FOREIGN KEY (HOSPITAL_NAME) REFERENCES Hospitals(HOSPITAL_NAME));

CREATE TABLE Age(GEOID10 INTEGER NOT NULL,
                 under_5 INTEGER,
                 per_under_5 FLOAT,
                 5_to_9 INTEGER,
                 per_5_to_9 FLOAT,
                 10_to_14 INTEGER,
                 per_10_to_14 FLOAT,
                 15_to_19 INTEGER,
                 per_15_to_19 FLOAT,
                 20_to_24 INTEGER,
                 per_20_to_24 FLOAT,
                 25_to_29 INTEGER,
                 per_25_to_29 FLOAT,
                 30_to_34 INTEGER,
                 per_30_to_34 FLOAT,
                 35_to_39 INTEGER,
                 per_35_to_39 FLOAT,
                 40_to_44 INTEGER,
                 per_40_to_44 FLOAT,
                 45_to_49 INTEGER,
                 per_45_to_49 FLOAT,
                 50_to_54 INTEGER,
                 per_50_to_54 FLOAT,
                 55_to_59 INTEGER,
                 per_55_to_59 FLOAT,
                 60_to_64 INTEGER,
                 per_60_to_64 FLOAT,
                 65_to_69 INTEGER,
                 per_65_to_69 FLOAT,
                 70_to_74 INTEGER,
                 per_70_to_74 FLOAT,
                 75_to_79 INTEGER,
                 per_75_to_79 FLOAT,
                 80_to_84 INTEGER,
                 per_80_to_84 FLOAT,
                 80_and_over INTEGER,
                 per_80_and_over FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Citizenship(GEOID10 INTEGER NOT NULL,
                 naturalized INTEGER,
                 `non-citizen` INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Demographics(GEOID10 INTEGER NOT NULL,
                tot_pop INTEGER,
                white INTEGER,
                per_white FLOAT,
                black_africanamerican INTEGER,
                per_black_africanamerican FLOAT,
                native INTEGER,
                per_native FLOAT,
                asian INTEGER,
                per_asian FLOAT,
                nativehawaiian_pacislander INTEGER,
                per_nativehawaiian_pacificislander FLOAT,
                some_other_one_race INTEGER,
                per_some_other_one_race FLOAT,
                two_or_more_races INTEGER,
                per_two_or_more_race FLOAT,
                hispanic_latino INTEGER,
                per_hispanic_latino FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Demographics_Latin(GEOID10 INTEGER NOT NULL,
                tot_pop INTEGER,
                white INTEGER,
                per_white FLOAT,
                black_africanamerican INTEGER,
                per_black_africanamerican FLOAT,
                native INTEGER,
                per_native FLOAT,
                asian INTEGER,
                per_asian FLOAT,
                nativehawaiian_pacislander INTEGER,
                per_nativehawaiian_pacificislander FLOAT,
                hispanic_latino INTEGER,
                per_hispanic_latino FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Disability(GEOID10 INTEGER NOT NULL,
                disabled INTEGER,
                per_disabled FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Gender(GEOID10 INTEGER NOT NULL,
                male INTEGER,
                female INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Tenure(GEOID10 INTEGER NOT NULL,
                total_housing INTEGER,
                owner INTEGER,
                rent INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE HouseholdSize(GEOID10 INTEGER NOT NULL,
                2_ppl_fam INTEGER,
                3_to_4_ppl_fam INTEGER,
                5_to_6_ppl_fam INTEGER,
                GT_7_ppl_fam INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Income(GEOID10 INTEGER NOT NULL,
                less_10k INTEGER,
                10k_15k INTEGER,
                15k_25k INTEGER,
                25k_35k INTEGER,
                35k_50k INTEGER,
                50k_75k INTEGER,
                75k_100k INTEGER,
                100k_150k INTEGER,
                150k_200k INTEGER,
                more_200k INTEGER,
                med_income INTEGER,
                mean_income INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Insurance(GEOID10 INTEGER NOT NULL,
                insured INTEGER,
                per_insur FLOAT,
                uninsured INTEGER,
                per_uninsur FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Language(GEOID10 INTEGER NOT NULL,
               speaks_only_english INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Poverty(GEOID10 INTEGER NOT NULL,
               pop_pov INTEGER,
            pop_below_pov FLOAT,
            	pcnt_pov FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Snap(GEOID10 INTEGER NOT NULL,
               tot_households INTEGER,
               	households_SNAP INTEGER,
               	per_households_SNAP FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Ssi(GEOID10 INTEGER NOT NULL,
               security_income INTEGER,
               	social_security INTEGER,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Unemployment(GEOID10 INTEGER NOT NULL,
               unemployment_rate FLOAT,

                 PRIMARY KEY (GEOID10),
                 FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE StagingSurge(SurgeID INTEGER NOT NULL AUTO_INCREMENT,
                   HOSPITAL_NAME VARCHAR(500),
                   LICENSED_BEDS INTEGER,
                   STAFFED_BEDS INTEGER,
                   ICU_BEDS INTEGER,
                   ADULT_ICU_BEDS INTEGER,
                   PEDIATRIC_ICU_BEDS INTEGER,
                   BED_UTILIZATION_RATE FLOAT,
                   TOTAL_BEDS INTEGER,
                   POTENTIAL_BED_INCREASE INTEGER,
                   AVG_VENTILATOR_USE FLOAT,
                   LATITUDE FLOAT,
                   LONGITUDE FLOAT,
                   GEOID10 INTEGER,

                   PRIMARY KEY (SurgeID),
                   KEY (HOSPITAL_NAME),
                   FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE Patients(PID INTEGER NOT NULL,
                   FIRST_NAME VARCHAR(500),
                   LAST_NAME VARCHAR(500),
                   LATITUDE FLOAT,
                   LONGITUDE FLOAT,
                   GEOID10 INTEGER,
                   SYMPTOMS TEXT,
                   DATE DATETIME NOT NULL DEFAULT NOW(),

                   PRIMARY KEY (PID),
                   FOREIGN KEY (GEOID10) REFERENCES ZipCodes(GEOID10));

CREATE TABLE PatientTests(TID INTEGER NOT NULL AUTO_INCREMENT,
                          PID INTEGER NOT NULL,
                          RESULTS BOOLEAN,
                          DATE DATETIME NOT NULL DEFAULT NOW(),

                          PRIMARY KEY (TID),
                          FOREIGN KEY (PID) REFERENCES Patients(PID));

