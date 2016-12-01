DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_refresh_techops_data`$$

CREATE PROCEDURE `sp_refresh_techops_data`()
BEGIN
	DROP TABLE IF EXISTS jiraanalysis.techops_tickets_tmp;
	
	CREATE TABLE jiraanalysis.techops_tickets_tmp
	SELECT
	p.pname project
	,p.pkey
	,it.pname AS issue_type
	,jira.issuenum AS IssueID
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id) AS Severity
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11407 AND issue=jira.id) AS `Client Type`
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11409 AND issue=jira.id) AS `Deployment Type`
	,(SELECT GROUP_CONCAT(a.customvalue) 
	FROM jiradb.customfieldvalue b 
	INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
	WHERE b.customfield =10202 
	AND issue=jira.id
	GROUP BY jira.id) AS `Client`
/*	,(SELECT a.customvalue 
	FROM jiradb.customfieldvalue b 
	INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
	WHERE b.customfield =10202 AND issue=jira.id) as `Client`*/
	,(SELECT b.stringvalue 
		FROM jiradb.customfieldvalue b 
		WHERE b.customfield =10208 AND issue=jira.id) AS PivotalIDs
	,jira.Summary AS Summary
	,jira.created AS CreateDate
	,jira.updated AS UpdatedDate
	,YEAR(jira.created) AS `Created Year`	
	,MONTH(jira.created) AS `Created Month`	
	,QUARTER(jira.created) AS `Created Quarter`		
	,WEEKOFYEAR(jira.created) AS `Created Week`
	,'yyyy-mm-dd' `Work Day`
	,'xxxxxxxxxx' `Day Name`	
	,jira.Resolutiondate AS ResolvedDate
	,iss.pname AS `Status`
	,rsn.pname AS Resolution_Type
	,jira.assignee AS AssignedTo
	,jira.Reporter
/*	,IFNULL((SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11302 AND issue=jira.id),'NA') AS Product_platform
	,IFNULL((SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11303 AND issue=jira.id),'NA') AS Request_Origin
	*/
	,IFNULL((SELECT GROUP_CONCAT(pv.vname)
		FROM jiradb.nodeassociation na
		INNER JOIN jiradb.jiraissue j
			ON j.id = na.source_node_id
		INNER JOIN jiradb.projectversion pv
			ON pv.id = na.sink_node_id
		WHERE j.id = jira.id
		AND na.association_type = 'IssueFixVersion'
		GROUP BY j.id),'NA') AS `Fix Version`
	FROM jiradb.jiraissue jira
	LEFT JOIN jiradb.label l ON l.issue = jira.id
	LEFT OUTER JOIN jiradb.resolution rsn ON jira.resolution = rsn.id
	INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
	INNER JOIN jiradb.issuetype it ON it.id = jira.issuetype
	INNER JOIN jiradb.project p ON jira.project = p.id 
	WHERE 
		(jira.PROJECT IN (10735)	#10735: Product Technical Operations
		OR
		jira.assignee IN ('pmoore', 'gwilliams', 'mwills', 'rwhipple', 'mmusleh','spatton')
		)

	#and jira.issuenum = '419'
	ORDER BY jira.created DESC;

	UPDATE jiraanalysis.techops_tickets_tmp SET `Work Day` = DATE_FORMAT(`CreateDate`, '%Y-%m-%d');
	
	UPDATE jiraanalysis.techops_tickets_tmp SET `Day Name` = DATE_FORMAT(`CreateDate`, '%a');
	
	UPDATE jiraanalysis.techops_tickets_tmp SET `Status` = 'Resolved' WHERE `Status` = 'Closed';
		
	DROP TABLE IF EXISTS jiraanalysis.techops_tickets;
	
	RENAME TABLE jiraanalysis.techops_tickets_tmp TO jiraanalysis.techops_tickets;	
END$$

DELIMITER ;