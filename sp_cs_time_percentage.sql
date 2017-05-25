DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_cs_time_percentage`$$

CREATE PROCEDURE `sp_cs_time_percentage`()
BEGIN

	-- Time spent on CS
	DROP TABLE IF EXISTS jiraanalysis.tmp_cs_time;
	CREATE TABLE jiraanalysis.tmp_cs_time
	SELECT t.Username, t.`Full name` AS FullName, SUM(t.Hours) AS Total
	FROM jiraanalysis.tempo_data_no_sprint t
	WHERE t.Department = 'TechOps'
	AND t.`Issue Key` = 'IN-35' -- CS ticket for 2017
	AND t.`Work Date` BETWEEN CONCAT(YEAR(NOW()),'-01-01') AND CONCAT(YEAR(NOW()),'-12-31')
	GROUP BY t.username, t.`Full name`
	;

	-- select * from jiraanalysis.tmp_cs_time

	-- Time spent in year minus PTO
	DROP TABLE IF EXISTS jiraanalysis.tmp_non_pto_time;
	CREATE TABLE jiraanalysis.tmp_non_pto_time
	SELECT t.Username, t.`Full name` AS FullName, SUM(t.Hours) AS Total
	FROM jiraanalysis.tempo_data_no_sprint t
	WHERE t.Department = 'TechOps'
	AND t.`Issue Key` != 'IN-31' -- PTO ticket for 2017
	AND t.`Work Date` BETWEEN CONCAT(YEAR(NOW()),'-01-01') AND CONCAT(YEAR(NOW()),'-12-31')
	GROUP BY t.username, t.`Full name`
	;

	-- select * from jiraanalysis.tmp_non_pto_time

	-- Time spent on PLS
	DROP TABLE IF EXISTS jiraanalysis.tmp_pls_time;
	CREATE TABLE jiraanalysis.tmp_pls_time
	SELECT t.Username, t.`Full name` AS FullName, SUM(t.Hours) AS Total
	FROM jiraanalysis.tempo_data_no_sprint t
	WHERE t.Department = 'TechOps'
	AND t.`Project Key` = 'PLS'
	-- AND t.`Username` = 'mwills'
	AND t.`Work Date` BETWEEN CONCAT(YEAR(NOW()),'-01-01') AND CONCAT(YEAR(NOW()),'-12-31')
	GROUP BY t.username, t.`Full name`
	;

	-- select * from jiraanalysis.tmp_pls_time
	DROP TABLE IF EXISTS jiraanalysis.cs_time_percentage;
	CREATE TABLE jiraanalysis.cs_time_percentage
	SELECT cs.Username, cs.FullName, cs.Total AS CSTime, pto.Total AS nonPTOTime, IFNULL(pls.Total,0) AS PLSTime
	FROM jiraanalysis.tmp_cs_time cs
	INNER JOIN jiraanalysis.tmp_non_pto_time pto
		ON pto.username = cs.username
	LEFT JOIN jiraanalysis.tmp_pls_time pls
		ON pls.username = cs.username
	;

END$$

DELIMITER ;