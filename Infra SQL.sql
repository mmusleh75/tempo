# Old SQL
SELECT
p.pname project
,p.pkey
,jira.issuenum AS IssueID
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id) AS Severity
,(SELECT b.stringvalue 
	FROM jiradb.customfieldvalue b 
	WHERE b.customfield =10208 AND issue=jira.id) AS PivotalIDs
,(SELECT datevalue FROM customfieldvalue WHERE customfield = 10601 AND issue = jira.id) AS SICreated
,(SELECT datevalue FROM customfieldvalue WHERE customfield = 10602 AND issue = jira.id) AS SIClosed
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
WHERE jira.PROJECT IN 
(10200,	#IT Service Desk
10300,	#Network Operations
10301,	#Software Deployment 
10303,	#Infrastructure
10500	#Technical Operations
)
ORDER BY jira.created DESC;
