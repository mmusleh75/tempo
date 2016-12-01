DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_techops_data`$$

CREATE PROCEDURE `sp_techops_data`()
BEGIN
	SELECT * FROM jiraanalysis.techops_tickets;	
END$$

DELIMITER ;