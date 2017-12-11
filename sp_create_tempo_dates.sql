/*
Run this in the beginning of each year
CALL sp_create_tempo_dates('2017-01-01','2017-12-31');
*/
DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_create_tempo_dates`$$

CREATE PROCEDURE `sp_create_tempo_dates`(_init_date DATE, _end_date DATE)
BEGIN
	
	DECLARE _un VARCHAR(128);
	DECLARE _date DATE;
	
	DECLARE _records CURSOR FOR		
	SELECT DISTINCT Username 
	FROM jiraanalysis.tmp_tempo_users;

	CALL jiraanalysis.sp_create_pdev_users(); -- creates list of PDEV users
	
#	select '|',_init_date,_end_date;

	DROP TABLE IF EXISTS jiraanalysis.annual_tempo_dates;
	CREATE TABLE jiraanalysis.annual_tempo_dates (username VARCHAR(128), work_day DATE, day_name VARCHAR(32));
	CREATE INDEX username_index ON jiraanalysis.annual_tempo_dates (`username`);
	CREATE INDEX work_day_index ON jiraanalysis.annual_tempo_dates (`work_day`);
	
	OPEN _records;
	
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH _records INTO _un;
			SET _date = _init_date;
			WHILE _date < _end_date DO
				INSERT INTO jiraanalysis.annual_tempo_dates VALUES (_un, _date, DATE_FORMAT(_date, '%a'));
				SET _date = DATE_ADD(_date, INTERVAL 1 DAY);
			END WHILE;
			
		END LOOP;
	END;
	CLOSE _records;	
	
	-- remove Sat & Sun
	DELETE FROM jiraanalysis.annual_tempo_dates WHERE day_name IN ('Sat','Sun');
	
	-- cleanup holidays
	DELETE FROM jiraanalysis.annual_tempo_dates 
	WHERE work_day IN ('2016-01-01','2016-05-30','2016-07-04','2016-09-05','2016-11-24','2016-11-25','2016-12-25');
	
	DELETE FROM jiraanalysis.annual_tempo_dates 
	WHERE work_day >= DATE_FORMAT(NOW(), '%Y-%m-%d');

	DELETE t.*
	FROM jiraanalysis.annual_tempo_dates t
	INNER JOIN jiraanalysis.non_tempo_users n
		ON n.username = t.username
		AND t.work_day < n.join_date;	
	
### uncomment this later
####	CALL jiraanalysis.sp_create_exceptions_lt8hrs();
	
    END$$

DELIMITER ;