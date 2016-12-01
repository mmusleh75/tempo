SELECT DISTINCT ji.issuenum
,ci.newstring AS `status`
,YEAR(cg.created) AS year_changed
,MONTH(cg.created) AS month_changed
,DAY(cg.created) AS month_changed
FROM `jiraissue` ji
INNER JOIN `changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN `changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring LIKE '%QA Fail%'
ORDER BY 3
;




SELECT DISTINCT ji.id, ji.issuenum
,ci.newstring AS `status`
,MAX(cg.created) AS created
#,cg.created AS created
FROM `jiraissue` ji
INNER JOIN `changegroup` cg
	ON cg.issueid = ji.id
INNER JOIN `changeitem` ci
	ON ci.groupid = cg.id
WHERE ci.newstring IN ('Pending Client Confirmation')
AND cg.created >='2014-12-15'
AND NOT EXISTS (
	SELECT 1
	FROM customfieldvalue v
	WHERE v.issue = ji.id
	AND v.customfield = 10506)
#and ji.id = 40342
GROUP BY ji.id, ji.issuenum,ci.newstring 
;