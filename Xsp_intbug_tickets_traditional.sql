DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_intbug_tickets_traditional`$$

CREATE PROCEDURE `sp_intbug_tickets_traditional`()
BEGIN
	DROP TABLE IF EXISTS temp_intbug_tickets_traditional;
	CREATE TABLE temp_intbug_tickets_traditional
	SELECT
	jira.issuenum AS IssueID
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id) AS Severity
	,(SELECT b.stringvalue 
		FROM jiradb.customfieldvalue b 
		WHERE b.customfield =10208 AND issue=jira.id) AS PivotalIDs
	,IFNULL((SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=jira.id),'n/a') AS Product
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10403 AND issue=jira.id) AS DSA
	,(SELECT b.datevalue FROM jiradb.customfieldvalue b WHERE b.customfield =10506 AND issue=jira.id) AS DevCompletion

	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10222 AND issue=jira.id) AS EscalationState
	,(SELECT datevalue FROM jiradb.customfieldvalue WHERE customfield = 10601 AND issue = jira.id) AS SICreated
	,(SELECT datevalue FROM jiradb.customfieldvalue WHERE customfield = 10602 AND issue = jira.id) AS SIClosed

	,(SELECT GROUP_CONCAT(pv.vname)
	FROM jiradb.nodeassociation na
	INNER JOIN jiradb.jiraissue j
		ON j.id = na.source_node_id
	INNER JOIN jiradb.projectversion pv
		ON pv.id = na.sink_node_id
	WHERE j.id = jira.id
	AND na.association_type = 'IssueVersion'
	GROUP BY j.id) AS AffectsVersion
	,(SELECT GROUP_CONCAT(pv.vname)
	FROM jiradb.nodeassociation na
	INNER JOIN jiradb.jiraissue j
		ON j.id = na.source_node_id
	INNER JOIN jiradb.projectversion pv
		ON pv.id = na.sink_node_id
	WHERE j.id = jira.id
	AND na.association_type = 'IssueFixVersion'
	GROUP BY j.id) AS FixedVersion
	,jira.Summary AS Summary
	,jira.created AS CreateDate
	,jira.updated AS UpdatedDate
	,jira.Resolutiondate AS ResolvedDate

	,iss.pname AS STATUS
	,rsn.pname AS Resolution_Type
	,jira.assignee AS AssignedTo
	,jira.Reporter

	FROM jiradb.jiraissue jira
	LEFT OUTER JOIN jiradb.resolution rsn ON jira.resolution = rsn.id
	INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
	INNER JOIN jiradb.project p ON jira.project = p.id 
	WHERE jira.issuetype=1 # intbug 
	AND jira.PROJECT = 10101 # Pulse Systems Project
	AND jira.security IS NULL
	ORDER BY jira.created DESC;

	DELETE FROM jiraanalysis.temp_intbug_tickets_traditional 
	WHERE product IN ('NHA','Secure Connect','Pulse Mobile','Pulse Patient Portal')
	;

END$$

DELIMITER ;