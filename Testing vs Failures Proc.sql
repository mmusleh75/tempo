DELIMITER $$

DROP PROCEDURE IF EXISTS `jiraanalysis`.`sp_update_to_status`$$

CREATE

    PROCEDURE `jiraanalysis`.`sp_update_to_status`()

    BEGIN
    DROP TABLE IF EXISTS jiraanalysis.update_to_status;

	CREATE TABLE jiraanalysis.update_to_status
	SELECT DISTINCT 
	CASE 
		WHEN ji.issuetype = 4 THEN 'ENH'
		WHEN ji.issuetype = 10109 THEN 'FEAT'
		WHEN ji.issuetype = 10110 THEN 'SWM'
		WHEN ji.issuetype = 1 THEN 'BUG'
		WHEN ji.issuetype = 10103 THEN 'INT'
		WHEN ji.issuetype = 3 THEN 'TSK'
		ELSE 'N/A'
	END issue_type
	,ci.oldstring jira_status
	,ji.issuenum jira_number
	,YEAR(cg.created) AS year_changed
	,MONTH(cg.created) AS month_changed
	,DAY(cg.created) AS day_changed
	,(SELECT GROUP_CONCAT(pv.vname)
		FROM jiradb.nodeassociation na
		INNER JOIN jiradb.jiraissue j
			ON j.id = na.source_node_id
		INNER JOIN jiradb.projectversion pv
			ON pv.id = na.sink_node_id
		WHERE j.id = ji.id
		AND na.association_type = 'IssueFixVersion'
		GROUP BY j.id) fix_version
	,(SELECT GROUP_CONCAT(a.vname) 
				FROM jiradb.customfieldvalue b 
				INNER JOIN jiradb.projectversion a 
					ON b.numbervalue = a.id 
				 WHERE b.customfield =10404 
				  AND b.issue=ji.id
				 GROUP BY b.issue) planned_version
	FROM jiradb.`jiraissue` ji
	INNER JOIN jiradb.issuetype it
		ON it.id = ji.issuetype
	INNER JOIN jiradb.`changegroup` cg
		ON cg.issueid = ji.id
	INNER JOIN jiradb.`changeitem` ci
		ON ci.groupid = cg.id
	-- WHERE ci.newstring IN ('QA In Progress', 'QA Queue')
	WHERE ci.field = 'status'
	AND ji.PROJECT = 10101 # Pulse Systems Project
--	AND ji.created >= '2015-01-01'
	AND ji.issuetype IN (1, 3, 4, 10109, 10110, 10103)
	;

	UPDATE jiraanalysis.update_to_status
	SET fix_version = planned_version
	WHERE fix_version = 'Backlog'
	AND planned_version IS NOT NULL
	;
	
	UPDATE jiraanalysis.update_to_status
	SET fix_version = planned_version
	WHERE fix_version = 'Pending'
	AND planned_version IS NOT NULL
	;
	
	UPDATE jiraanalysis.update_to_status
	SET fix_version = planned_version
	WHERE fix_version IS NULL
	AND planned_version IS NOT NULL
	;
	
	
	-- TO QA
	DROP TABLE IF EXISTS jiraanalysis.to_qa
	;

	CREATE TABLE jiraanalysis.to_qa
	SELECT DISTINCT *
	FROM jiraanalysis.update_to_status
	WHERE jira_status = 'QA Queue'
	;

	INSERT INTO jiraanalysis.to_qa
	SELECT DISTINCT qaip.*
	FROM jiraanalysis.update_to_status qaip
	LEFT JOIN jiraanalysis.to_qa qaq
		ON qaq.jira_number = qaip.jira_number
	WHERE qaip.jira_status = 'QA In Progress'
	AND qaq.jira_number IS NULL
	;

	INSERT INTO jiraanalysis.to_qa
	SELECT DISTINCT qaip.*
	FROM jiraanalysis.update_to_status qaip
	LEFT JOIN jiraanalysis.to_qa qaq
		ON qaq.jira_number = qaip.jira_number
	WHERE qaip.jira_status = 'QA Line Item'
	AND qaq.jira_number IS NULL
	;


	INSERT INTO jiraanalysis.to_qa
	SELECT DISTINCT qaip.*
	FROM jiraanalysis.update_to_status qaip
	LEFT JOIN jiraanalysis.to_qa qaq
		ON qaq.jira_number = qaip.jira_number
	WHERE qaip.jira_status = 'QA Regression'
	AND qaq.jira_number IS NULL
	;

	INSERT INTO jiraanalysis.to_qa
	SELECT DISTINCT qaip.*
	FROM jiraanalysis.update_to_status qaip
	LEFT JOIN jiraanalysis.to_qa qaq
		ON qaq.jira_number = qaip.jira_number
	WHERE qaip.jira_status = 'QA Validation'
	AND qaq.jira_number IS NULL
	;
		
	UPDATE jiraanalysis.to_qa
	SET jira_status = 'To QA'
	;

	-- QA Fail
	DROP TABLE IF EXISTS jiraanalysis.qa_fail
	;

	CREATE TABLE jiraanalysis.qa_fail
	SELECT DISTINCT *
	FROM jiraanalysis.update_to_status
	WHERE jira_status = 'QA Fail'
	;


	-- To PM
	DROP TABLE IF EXISTS jiraanalysis.to_pm
	;

	CREATE TABLE jiraanalysis.to_pm
	SELECT DISTINCT *
	FROM jiraanalysis.update_to_status
	WHERE jira_status = 'Functional Acceptance'
	;

	-- PM Fail
	DROP TABLE IF EXISTS jiraanalysis.pm_fail
	;

	CREATE TABLE jiraanalysis.pm_fail
	SELECT DISTINCT *
	FROM jiraanalysis.update_to_status
	WHERE jira_status = 'Rejected'
	;


    END$$

DELIMITER ;


