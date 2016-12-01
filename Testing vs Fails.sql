-- To PMs
SELECT DISTINCT 
CASE 
	WHEN ji.issuetype = 4 THEN 'ENH'
	WHEN ji.issuetype = 10109 THEN 'FEAT'
	WHEN ji.issuetype = 10110 THEN 'SWM'
	ELSE 'BUG'
END issue_type
,ji.issuenum jira_number
,YEAR(cg.created) AS year_changed
,MONTH(cg.created) AS month_changed
,IFNULL((SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = ji.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id),IFNULL((SELECT GROUP_CONCAT(a.vname) 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.projectversion a 
			ON b.numbervalue = a.id 
		 WHERE b.customfield =10404 
		  AND b.issue=ji.id
		 GROUP BY b.issue),'NA')) AS prod_version
FROM jiradb.`jiraissue` ji
INNER JOIN jiradb.issuetype it
	ON it.id = ji.issuetype
INNER JOIN jiradb.`changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN jiradb.`changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('Functional Acceptance') -- ('QA Fail','Rejected')
AND ji.PROJECT = 10101 # Pulse Systems Project
AND ji.created >= '2015-01-01'
AND ji.issuetype IN (1, 4, 10109, 10110)
ORDER BY 3, 4, 1
;

-- To QA
SELECT DISTINCT 
CASE 
	WHEN ji.issuetype = 4 THEN 'ENH'
	WHEN ji.issuetype = 10109 THEN 'FEAT'
	WHEN ji.issuetype = 10110 THEN 'SWM'
	ELSE 'BUG'
END issue_type
,ji.issuenum jira_number
,YEAR(cg.created) AS year_changed
,MONTH(cg.created) AS month_changed
,IFNULL((SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = ji.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id),IFNULL((SELECT GROUP_CONCAT(a.vname) 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.projectversion a 
			ON b.numbervalue = a.id 
		 WHERE b.customfield =10404 
		  AND b.issue=ji.id
		 GROUP BY b.issue),'NA')) AS prod_version
FROM jiradb.`jiraissue` ji
INNER JOIN jiradb.issuetype it
	ON it.id = ji.issuetype
INNER JOIN jiradb.`changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN jiradb.`changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('QA In Progress', 'QA Queue')
AND ji.PROJECT = 10101 # Pulse Systems Project
AND ji.created >= '2015-01-01'
AND ji.issuetype IN (1, 4, 10109, 10110)
ORDER BY 3, 4, 1
;



-- QA Fail
SELECT DISTINCT 
CASE 
	WHEN ji.issuetype = 4 THEN 'ENH'
	WHEN ji.issuetype = 10109 THEN 'FEAT'
	WHEN ji.issuetype = 10110 THEN 'SWM'
	ELSE 'BUG'
END issue_type
,ji.issuenum jira_number
,YEAR(cg.created) AS year_changed
,MONTH(cg.created) AS month_changed
,IFNULL((SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = ji.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id),IFNULL((SELECT GROUP_CONCAT(a.vname) 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.projectversion a 
			ON b.numbervalue = a.id 
		 WHERE b.customfield =10404 
		  AND b.issue=ji.id
		 GROUP BY b.issue),'NA')) AS prod_version
FROM jiradb.`jiraissue` ji
INNER JOIN jiradb.issuetype it
	ON it.id = ji.issuetype
INNER JOIN jiradb.`changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN jiradb.`changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('QA Fail') -- ('QA Fail','Rejected')
AND ji.PROJECT = 10101 # Pulse Systems Project
AND ji.created >= '2015-01-01'
AND ji.issuetype IN (1, 4, 10109, 10110)
ORDER BY 3, 4, 1
;

-- PM Fail
SELECT DISTINCT 
CASE 
	WHEN ji.issuetype = 4 THEN 'ENH'
	WHEN ji.issuetype = 10109 THEN 'FEAT'
	WHEN ji.issuetype = 10110 THEN 'SWM'
	ELSE 'BUG'
END issue_type
,ji.issuenum jira_number
,YEAR(cg.created) AS year_changed
,MONTH(cg.created) AS month_changed
,IFNULL((SELECT GROUP_CONCAT(pv.vname)
FROM jiradb.nodeassociation na
INNER JOIN jiradb.jiraissue j
	ON j.id = na.source_node_id
INNER JOIN jiradb.projectversion pv
	ON pv.id = na.sink_node_id
WHERE j.id = ji.id
AND na.association_type = 'IssueFixVersion'
GROUP BY j.id),IFNULL((SELECT GROUP_CONCAT(a.vname) 
		FROM jiradb.customfieldvalue b 
		INNER JOIN jiradb.projectversion a 
			ON b.numbervalue = a.id 
		 WHERE b.customfield =10404 
		  AND b.issue=ji.id
		 GROUP BY b.issue),'NA')) AS prod_version
FROM jiradb.`jiraissue` ji
INNER JOIN jiradb.issuetype it
	ON it.id = ji.issuetype
INNER JOIN jiradb.`changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN jiradb.`changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('Rejected') -- ('QA Fail','Rejected')
AND ji.PROJECT = 10101 # Pulse Systems Project
AND ji.created >= '2015-01-01'
AND ji.issuetype IN (1, 4, 10109, 10110)
ORDER BY 3, 4, 1
;

-- below is still in progress
SELECT DISTINCT 
it.pname issue_type
,ji.issuenum jira_number
,ci.newstring AS new_status
,YEAR(ji.created) AS year_changed
,MONTH(ji.created) AS month_changed
-- ,count(distinct ji.issuenum) as issue_count
,(SELECT COUNT(DISTINCT ji2.issuenum)
	FROM jiradb.`jiraissue` ji2
	INNER JOIN jiradb.issuetype it2
		ON it2.id = ji2.issuetype
	INNER JOIN jiradb.`changegroup` cg2
		ON cg2.issueid = ji2.id
	INNER JOIN jiradb.`changeitem` ci2
		ON ci2.groupid = cg2.id
	WHERE ci2.newstring IN ('QA In Progress', 'Functional Acceptance', 'QA Queue')
	AND ji2.id = ji.id
#	and YEAR(cg2.created) = year(ji.created)
#	and MONTH(cg2.created) = month(ji.created)
) cnt
FROM jiradb.`jiraissue` ji
INNER JOIN jiradb.issuetype it
	ON it.id = ji.issuetype
INNER JOIN jiradb.`changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN jiradb.`changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('QA In Progress', 'Functional Acceptance', 'QA Queue') -- ('QA Fail','Rejected')
AND ji.PROJECT = 10101 # Pulse Systems Project
AND ji.issuenum = 14485
-- group by it.pname, ci.newstring, YEAR(ji.created), MONTH(ji.created)
ORDER BY 1, 3, 4
;


