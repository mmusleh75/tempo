DROP TABLE IF EXISTS jiraanalysis.tempo_data_2016;
CREATE TABLE jiraanalysis.tempo_data_2016
SELECT *
FROM jiraanalysis.tempo_data_no_sprint
WHERE `Work Date` <= '2016-12-31'
;

DELETE
#SELECT *
FROM jiraanalysis.tempo_data_no_sprint
WHERE `Work Date` <= '2016-12-31'
;

SELECT SUM(hours)
FROM jiraanalysis.tempo_data_no_sprint
WHERE `Work Date` > '2016-12-31'
;

-- change beginning time in the sp to 2017-01-01

DROP TABLE IF EXISTS jiraanalysis.monthly_trends_pc_2016;
CREATE TABLE jiraanalysis.monthly_trends_pc_2016
SELECT *
FROM jiraanalysis.monthly_trends_pc
WHERE EndDate LIKE '%2016%';

-- delete
SELECT *
FROM jiraanalysis.monthly_trends_pc
WHERE EndDate LIKE '%2016%';

################################
DROP TABLE IF EXISTS jiraanalysis.monthly_trends_trad_2016;
CREATE TABLE jiraanalysis.monthly_trends_trad_2016
SELECT *
FROM jiraanalysis.monthly_trends_trad
WHERE EndDate LIKE '%2016%';

-- delete
SELECT *
FROM jiraanalysis.monthly_trends_trad
WHERE EndDate LIKE '%2016%';

################################
DROP TABLE IF EXISTS jiraanalysis.swm_monthly_trends_trad_2016;
CREATE TABLE jiraanalysis.swm_monthly_trends_trad_2016
SELECT *
FROM jiraanalysis.swm_monthly_trends_trad
WHERE MY LIKE '%2016%';

-- delete
SELECT *
FROM jiraanalysis.swm_monthly_trends_trad
WHERE MY LIKE '%2016%';

################################
DROP TABLE IF EXISTS jiraanalysis.swm_monthly_trends_pc_2016;
CREATE TABLE jiraanalysis.swm_monthly_trends_pc_2016
SELECT *
FROM jiraanalysis.swm_monthly_trends_pc
WHERE MY LIKE '%2016%';

-- delete
SELECT *
FROM jiraanalysis.swm_monthly_trends_pc
WHERE MY LIKE '%2016%';

CREATE TABLE jiraanalysis.2017_sprint_teams
SELECT * FROM jiraanalysis.2016_sprint_teams;
TRUNCATE TABLE jiraanalysis.2017_sprint_teams;

CREATE TABLE jiraanalysis.2017_sprints
SELECT * FROM jiraanalysis.2016_sprints;
TRUNCATE TABLE jiraanalysis.2017_sprints;

#################################

DROP TABLE IF EXISTS jiraanalysis.tempo_exceptions_lt8hrs_2016;
CREATE TABLE jiraanalysis.tempo_exceptions_lt8hrs_2016
SELECT *
FROM jiraanalysis.`tempo_exceptions_lt8hrs`
WHERE work_day <= '2016-12-31'
;

DELETE
#SELECT *
FROM jiraanalysis.`tempo_exceptions_lt8hrs`
WHERE work_day <= '2016-12-31'
;