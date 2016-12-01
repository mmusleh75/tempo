DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_sprint_time_tempo_data`$$

CREATE PROCEDURE `sp_sprint_time_tempo_data`()
BEGIN

	SELECT * FROM jiraanalysis.tempo_sprint_data;
	
    END$$

DELIMITER ;