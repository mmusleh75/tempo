DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_create_pdev_users`$$

CREATE PROCEDURE `sp_create_pdev_users`()
BEGIN
	DROP TABLE IF EXISTS jiraanalysis.tmp_tempo_users;
	
	CREATE TABLE jiraanalysis.tmp_tempo_users
	SELECT DISTINCT 
	u.user_name AS `Username`	
	,u.display_name AS `Full name`	
	,d.job AS `Job Title`
	,d.department AS `Department`
	,d.Contractor
	,stm.team AS `Sprint Team`	
	FROM jiradb.app_user au
	INNER JOIN jiradb.cwd_user u
		ON u.lower_user_name = au.lower_user_name	
	INNER JOIN jiradb.AO_AEFED0_TEAM_MEMBER_V2 tm
		ON (tm.member_key = au.user_key
		AND tm.team_id = 33) # PDEV			-- keep this
	LEFT JOIN jiraanalysis.team_lookup d
		ON LOWER(d.username) = LOWER(u.lower_user_name)
	LEFT JOIN jiraanalysis.team_lookup stm
		ON LOWER(stm.username) = LOWER(u.lower_user_name)
	WHERE u.directory_id = 10100
	AND u.active = 1
	;

	DELETE FROM jiraanalysis.tmp_tempo_users
	WHERE `Job Title` IS NULL
	AND Department IS NULL
	AND Contractor IS NULL
	AND `Sprint Team` IS NULL;

	DELETE FROM jiraanalysis.tmp_tempo_users
	WHERE Department = 'N/A';
	
	CREATE INDEX Username_index ON jiraanalysis.tmp_tempo_users (`Username`);
    END$$

DELIMITER ;