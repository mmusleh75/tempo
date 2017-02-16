DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_tickets_all_products_processor`$$

CREATE PROCEDURE `sp_tickets_all_products_processor`()
BEGIN
	DROP TABLE IF EXISTS temp_tickets_all_products_processor;
	CREATE TABLE temp_tickets_all_products_processor
	SELECT
	jira.issuenum AS IssueID
	,IFNULL((SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id),'n/a') AS Severity
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
	,it.pname AS IssueType
	,p.pkey AS pkey
	FROM jiradb.jiraissue jira
	LEFT OUTER JOIN jiradb.resolution rsn ON jira.resolution = rsn.id
	INNER JOIN jiradb.issuetype it ON it.id = jira.issuetype
	INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
	INNER JOIN jiradb.project p ON jira.project = p.id 
	WHERE jira.issuetype IN (10110, 1) # 10110: SWM, 1: Internal Bug 
	AND jira.PROJECT IN (10101, 10701) # 10101: Pulse Systems Project, 10701: PulseCloud
	AND jira.security IS NULL
	ORDER BY jira.created DESC;

	DROP TABLE IF EXISTS jiraanalysis.temp_tickets_all_nonPLSPC_products;
	
	CREATE TABLE jiraanalysis.temp_tickets_all_nonPLSPC_products
	SELECT * FROM jiraanalysis.temp_tickets_all_products_processor;
	
	DELETE FROM jiraanalysis.temp_tickets_all_products_processor 
	WHERE product IN ('NHA','Secure Connect','Pulse Mobile','Pulse Patient Portal')
	;

END$$

DELIMITER ;