DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_create_exceptions_lt8hrs`$$

CREATE PROCEDURE `sp_create_exceptions_lt8hrs`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.tempo_exceptions_lt8hrs;
	
	CREATE TABLE jiraanalysis.tempo_exceptions_lt8hrs
	SELECT atd.work_day, atd.day_name, tu.*
	FROM jiraanalysis.annual_tempo_dates atd
	INNER JOIN `tmp_tempo_users` tu
		ON tu.username = atd.username
	WHERE NOT EXISTS(
		SELECT *
		FROM jiraanalysis.tempo_data_no_sprint td
		WHERE td.`Username` = atd.username
		AND td.`Work Day` = atd.work_day)
	AND atd.work_day >= '2017-01-01'
	AND atd.day_name NOT IN ('Sat','Sun');
	
	ALTER TABLE jiraanalysis.tempo_exceptions_lt8hrs ADD COLUMN `Work Year` INT;
	ALTER TABLE jiraanalysis.tempo_exceptions_lt8hrs ADD COLUMN `Work Month` INT;
	ALTER TABLE jiraanalysis.tempo_exceptions_lt8hrs ADD COLUMN `Work Quarter` INT;
	ALTER TABLE jiraanalysis.tempo_exceptions_lt8hrs ADD COLUMN `Work Week` INT;
	ALTER TABLE jiraanalysis.tempo_exceptions_lt8hrs ADD COLUMN `Work Hours` DECIMAL(10,2);

	UPDATE jiraanalysis.tempo_exceptions_lt8hrs
	SET `Work Year` = YEAR(work_day)	
	,`Work Month` = MONTH(work_day)
	,`Work Quarter` = QUARTER(work_day)		
	,`Work Week` = WEEKOFYEAR(work_day)
	,`Work Hours` = 0;

	INSERT INTO jiraanalysis.tempo_exceptions_lt8hrs
	SELECT `Work Day`, `Day Name`, `Username`, `Full Name`, `Job Title`,Department, Contractor,`Sprint Team`, `Work Year`, `Work Month`,`Work Quarter`, `Work Week`,SUM(Hours) AS hrs 
	FROM jiraanalysis.tempo_data_no_sprint
	WHERE `LT8Hrs` = 1
	AND `Day Name` NOT IN ('Sat','Sun')
	GROUP BY `Work Day`, `Day Name`, `Username`, `Full Name`, `Job Title`,Department, Contractor,`Sprint Team`, `Work Year`, `Work Month`,`Work Quarter`, `Work Week`
	;

	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs 
	WHERE work_day >= DATE_FORMAT(NOW(), '%Y-%m-%d');
	
	-- remove Sat & Sun
	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs WHERE day_name IN ('Sat','Sun');
	
	-- remove Greg Gallardo's entries
	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs 
	WHERE username = 'ggallardo' 
	AND work_day >= '2016-02-01';	

	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs 
	WHERE username = 'pmoore' 
	AND work_day <= '2016-02-05';	

	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs 
	WHERE username = 'rwhipple' 
	AND work_day <= '2016-01-08';	
	
	DELETE FROM jiraanalysis.tempo_exceptions_lt8hrs 
	WHERE username = 'spatton' 
	AND work_day <= '2016-04-06';	
		
    END$$

DELIMITER ;