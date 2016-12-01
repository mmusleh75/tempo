SELECT j.issuenum AS jira
,CASE
	WHEN (ci.oldstring IS NULL OR ci.oldstring = '') THEN 'N/A'
	ELSE ci.oldstring
END AS FromValue
,CASE
	WHEN (ci.newstring IS NULL OR ci.newstring = '') THEN 'N/A'
	ELSE ci.newstring
END AS ToValue
,cg.created AS ValueChangeDate
,cg.author AS ValueChangedBy
,ist.pname AS CurrentStatus
,j.created AS IssueCreate_date
,j.updated AS IssueUpdated_date
,CASE 
WHEN j.Resolutiondate IS NULL THEN NOW() 
ELSE j.Resolutiondate
END AS ResolvedDate
FROM jiradb.changeitem ci
INNER JOIN jiradb.changegroup cg
	ON ci.groupid = cg.ID
INNER JOIN jiradb.jiraissue j 
	ON j.id = cg.issueid
INNER JOIN jiradb.issuetype it
	ON it.id = j.issuetype
INNER JOIN jiradb.issuestatus ist
	ON ist.id = j.issuestatus
WHERE (ci.FIELD = 'Task Type') 
ORDER BY j.id, cg.created;

