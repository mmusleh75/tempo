SELECT
jira.issuenum AS IssueID
,it.pname AS `Issue Type`	
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=jira.id) AS Severity
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=jira.id) AS Product
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10403 AND issue=jira.id) AS DSA
,(SELECT b.datevalue FROM jiradb.customfieldvalue b WHERE b.customfield =10506 AND issue=jira.id) AS DevCompletion

,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10222 AND issue=jira.id) AS EscalationState
,(SELECT datevalue FROM customfieldvalue WHERE customfield = 10601 AND issue = jira.id) AS SICreated
,(SELECT datevalue FROM customfieldvalue WHERE customfield = 10602 AND issue = jira.id) AS SIClosed

-- 10222

,(SELECT GROUP_CONCAT(pv.vname)
FROM nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = jira.id
AND na.association_type = 'IssueVersion'
GROUP BY j.id) AS AffectsVersion
,(SELECT GROUP_CONCAT(pv.vname)
FROM nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = jira.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id) AS FixVersion
/*,
(select a.customvalue 
from jiradb.customfieldvalue b 
inner join jiradb.customfieldoption a on b.stringvalue = a.id 
inner join jiradb.customfield on b.customfield=customfield.ID 
where b.customfield = 12605 #'Reason for Escalation (to Mgmt)'
and issue=jira.id) EscalationReason,*/

,jira.Summary AS Summary
/*
(select datevalue from jiradb.customfieldvalue inner join jiradb.customfield on customfieldvalue.customfield=customfield.ID 
where customfield =10437 and issue=jira.id) as CaseCreateDate,*/
,jira.created AS CreateDate
,jira.updated AS UpdatedDate
,jira.Resolutiondate AS ResolvedDate

,iss.pname AS STATUS
,jira.assignee AS AssignedTo
,jira.Reporter

FROM jiradb.jiraissue jira
INNER JOIN jiradb.issuetype it ON it.id = jira.issuetype
INNER JOIN jiradb.issuestatus iss ON iss.id = jira.issuestatus
INNER JOIN jiradb.project p ON jira.project = p.id 
#--left  join jiradb.nodeassociation nass3 on nass3.SOURCE_NODE_ID = jira.id and nass3.ASSOCIATION_TYPE='IssueComponent' 
#--left  join jiradb.component cp on cp.id =nass3.sink_node_id 

WHERE jira.PROJECT = 10101 # Pulse Systems Project
#and jira.created > CAST('2010-12-31' as datetime)
 # AND jira.issuenum =26544	
ORDER BY jira.created DESC;