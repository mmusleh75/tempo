SELECT j.issuenum AS jira
,ci.oldstring AS FromStatus
,ci.newstring AS ToStatus
,cg.created AS StatusChangeDate
,cg.author AS StatusChangedBy
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
WHERE (ci.FIELD = 'status') 
AND ci.oldstring = 'Triage'
#and j.issuenum= 21755
#AND j.issuetype=10110 # SWM 
AND j.PROJECT = 10101 # Pulse Systems Project
#	or (ci.field = 'assignee' and cast(ci.newstring as varchar) = 'PS Triage'))
#and j.created >= '2013-01-01'
ORDER BY j.id, cg.created;


SELECT j.issuenum AS jira
,COUNT(1) AS triage_cnt
,MIN(cg.created) AS StatusChangeDate
FROM jiradb.changeitem ci
INNER JOIN jiradb.changegroup cg
	ON ci.groupid = cg.ID
INNER JOIN jiradb.jiraissue j 
	ON j.id = cg.issueid
INNER JOIN jiradb.issuetype it
	ON it.id = j.issuetype
INNER JOIN jiradb.issuestatus ist
	ON ist.id = j.issuestatus
WHERE (ci.FIELD = 'status') 
AND ci.oldstring = 'Triage'
AND j.issuetype=10110 # SWM 
AND j.PROJECT = 10101 # Pulse Systems Project
#	or (ci.field = 'assignee' and cast(ci.newstring as varchar) = 'PS Triage'))
#and j.created >= '2013-01-01'
GROUP BY j.issuenum
;