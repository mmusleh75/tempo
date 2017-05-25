
DROP TABLE IF EXISTS jiraanalysis.story_points_tmp;
CREATE TABLE jiraanalysis.story_points_tmp
SELECT p.id AS ProjectID
,j.id AS JiraID
,j.issuenum AS IssueKey
,p.pname AS ProjectName
,cf.numbervalue AS StoryPoints
FROM jiradb.jiraissue j
INNER JOIN jiradb.customfieldvalue cf
	ON cf.issue = j.id
	AND cf.customfield = 10002
INNER JOIN jiradb.project p 
	ON j.project = p.id 
;

-- select * from jiradb.customfield where id = 10002;

DROP TABLE IF EXISTS jiraanalysis.sprints_tmp;
CREATE TABLE jiraanalysis.sprints_tmp
SELECT p.id AS ProjectID
,j.id AS JiraID
,j.issuenum AS IssueKey
,p.pkey AS ProjectKey
,p.pname AS ProjectName
,s.name AS SprintName
FROM jiradb.jiraissue j
INNER JOIN jiradb.customfieldvalue cf
	ON cf.issue = j.id
INNER JOIN jiradb.AO_60DB71_SPRINT s
	ON (s.id = cf.stringvalue
	AND cf.customfield = 10005)	
INNER JOIN jiradb.project p 
	ON j.project = p.id ;


-- select * from jiradb.customfield where id = 10005;


SELECT s.ProjectKey
	,p.ProjectName
	,s.SprintName
	,SUM(p.StoryPoints) AS StoryPoints
FROM jiraanalysis.story_points_tmp p
INNER JOIN jiraanalysis.sprints_tmp s
	ON s.ProjectID = p.ProjectID
	AND s.JiraID = p.JiraID
WHERE s.SprintName LIKE 'PCld-17%'
GROUP BY s.ProjectKey, p.ProjectName, s.SprintName;

SELECT s.ProjectKey
	,p.IssueKey
	,p.StoryPoints
	,s.*
FROM jiraanalysis.story_points_tmp p
INNER JOIN jiraanalysis.sprints_tmp s
	ON s.ProjectID = p.ProjectID
	AND s.JiraID = p.JiraID
WHERE s.IssueKey = '10516'
s.SprintName LIKE 'PCld-17-02'
;
	
SELECT * FROM jiradb.AO_60DB71_SPRINT WHERE NAME = 'PCld-17-06';
-- start: 1488997582254
-- end: 1490203560000
-- comp: 1490203105904

SELECT ADDDATE(ADDDATE(ADDDATE('1899-12-31 00:00',1488997582254), INTERVAL -1 DAY), INTERVAL (MOD(1488997582254,1) * 86400) SECOND)

SELECT ADDDATE(ADDDATE('1899-12-31 00:00',1488997582254), INTERVAL -1 DAY)

SELECT *
FROM jiradb.changeitem ci
INNER JOIN changegroup cg
	ON ci.groupid=cg.id 
WHERE FIELD = 'Sprint'
AND ci.newstring LIKE 'PC%'
LIMIT 100

SELECT ci.field, COUNT(ci.field)
FROM jiradb.changeitem ci
GROUP BY ci.field;



SELECT * 
FROM jiraanalysis.story_points_tmp
WHERE issue_key = '2907';

SELECT * FROM 

SELECT * FROM jiradb.customfield WHERE id = 10002

SELECT * FROM jiradb.customfieldvalue WHERE customfield = 10005

