DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_time_tempo_data`$$

CREATE PROCEDURE `sp_time_tempo_data`()
BEGIN
	CALL jiraanalysis.sp_refresh_time_tempo_data();
	
	SELECT * FROM jiraanalysis.tempo_data_no_sprint;
	
END$$

DELIMITER ;
