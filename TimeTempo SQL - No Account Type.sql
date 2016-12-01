DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_time_tempo_data_no_account`$$

CREATE PROCEDURE `sp_time_tempo_data_no_account`()
BEGIN

	SELECT DISTINCT p.pkey `Project Key`
	,it.pname AS `Issue Type`	
	,ji.issuenum `Issue Number`
	FROM jiradb.jiraissue ji
	INNER JOIN jiradb.issuetype it
		ON it.id = ji.issuetype
	INNER JOIN jiradb.worklog wl
		ON ji.id = wl.issueid
	INNER JOIN jiradb.app_user au
		ON au.user_key = wl.author
	INNER JOIN jiradb.cwd_user u
		ON u.lower_user_name = au.lower_user_name
	INNER JOIN jiradb.AO_AEFED0_TEAM_MEMBER_V2 tm
		ON (tm.member_key = au.user_key
		AND tm.member_key = wl.author
		AND tm.team_id = 33) # PDEV			-- keep this
	INNER JOIN jiradb.project p 
		ON p.id = ji.project
	WHERE wl.startdate >= '2016-01-01'
	AND NOT EXISTS (SELECT issue
		FROM jiradb.customfieldvalue cfv
		INNER JOIN jiradb.AO_C3C6E8_ACCOUNT_V1 ac 
			ON (cfv.numbervalue = ac.id
			AND ac.key IN ('OP','CAP','BILL'))
		WHERE cfv.issue = ji.id)
	;


    END$$

DELIMITER ;