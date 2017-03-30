
DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_tickets_trends_client`$$

CREATE PROCEDURE `sp_tickets_trends_client`()
BEGIN

	# ticket trends for PLS and PC across ticket types
	CALL sp_tickets_trends_pulsecloud();
	CALL sp_tickets_trends_traditional();

	# ticket trends for PLS and PC - SWM tickets only
	CALL sp_swm_tickets_trends_traditional();
	CALL sp_swm_tickets_trends_pc();

	# ticket trends for PLS and PC - by Severity
	CALL sp_swm_sev_tickets_trends_traditional();
	CALL sp_swm_sev_tickets_trends_pc();

	# ticket trends for PLS and PC - INT BUG tickets only
	CALL sp_intbug_tickets_trends_traditional();
	CALL sp_intbug_tickets_trends_pc();

	# ticket trends for PLS and PC - INT BUG by Severity
	CALL sp_intbug_sev_tickets_trends_traditional();
	CALL sp_intbug_sev_tickets_trends_pc();
	
	CALL sp_swm_int_tickets_trends_nonPLSPC();	
	CALL sp_swm_int_sev_tickets_trends_nonPLSPC();
	
	CALL sp_refresh_pc_release_data();
	
	CALL sp_automation();
	
	CALL sp_new_fea_enh();

END$$

DELIMITER ;
