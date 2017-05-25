DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_automation`$$

CREATE PROCEDURE `sp_automation`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.automation;
	CREATE TABLE jiraanalysis.automation
	SELECT
	p.pname AS ProjectName
#	,jira.id
	,jira.issuenum AS IssueID
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id) AS Severity
	,(SELECT b.stringvalue 
		FROM jiradb.customfieldvalue b 
		WHERE b.customfield =10208 AND issue=jira.id) AS PivotalIDs
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=jira.id) AS Product
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

	,iss.pname AS `Status`
	,rsn.pname AS Resolution_Type
	,jira.assignee AS AssignedTo
	,jira.Reporter
	,(SELECT a.customvalue 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
		INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
		WHERE b.customfield =11616 AND issue=jira.id) AS AutomationCandidate
	,(SELECT a.customvalue 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
		INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
		WHERE b.customfield =11617 AND issue=jira.id) AS Automated
	,(SELECT b.numbervalue
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
		WHERE b.customfield =11620 AND issue=jira.id) AS ScenarioCount
	,(SELECT b.stringvalue
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.customfield ON b.customfield=customfield.ID 
		WHERE b.customfield =11618 AND issue=jira.id) AS TestEngineer
	,it.pname AS IssueType	
	FROM jiradb.jiraissue jira
	INNER JOIN jiradb.issuetype it ON it.id = jira.issuetype	
	LEFT OUTER JOIN jiradb.resolution rsn ON jira.resolution = rsn.id
	INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
	INNER JOIN jiradb.project p ON jira.project = p.id 
	WHERE jira.PROJECT IN (10101, 10701, 10724) # 10101: Pulse Systems Project (PLS), 10701: PulseCloud (VTEN), 10724: Mobile and Portal (MPM)
	AND it.id IN (1,4,10109,10110) # 1: BUG: Internal Defect, 10110: SWM: Software Maintenance, 10109: FEAT: New Feature, 4: ENH: Enhancement
#	and jira.issuenum = '8377'
#	and p.pkey = 'VTEN'
	AND jira.security IS NULL
;

END$$

DELIMITER ;