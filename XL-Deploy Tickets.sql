SELECT
CONCAT('PLS-',jira.issuenum) AS `IssueID`
,(SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = jira.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id) AS `IssueFixVersion`

,jira.created AS `CreateDate`
,iss.pname AS `Status`
,jira.assignee AS `AssignedTo`
,jira.Reporter
,(SELECT textvalue FROM jiradb.customfieldvalue WHERE issue = jira.id AND customfield = 10204) AS `DBChangeScripts`
,(SELECT textvalue FROM jiradb.customfieldvalue WHERE issue = jira.id AND customfield = 10206) AS `FileInfo`
,(SELECT textvalue FROM jiradb.customfieldvalue WHERE issue = jira.id AND customfield = 10216) AS `FileNames`
FROM jiradb.jiraissue jira
LEFT OUTER JOIN jiradb.resolution rsn ON jira.resolution = rsn.id
INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
INNER JOIN jiradb.project p ON jira.project = p.id 
WHERE jira.PROJECT = 10101 # Pulse Systems Project
AND iss.pname IN ('QA Queue')
AND (SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = jira.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id) IS NOT NULL
;