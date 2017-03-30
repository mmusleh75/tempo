
DROP TABLE IF EXISTS jiraanalysis.story_points_tmp;
CREATE TABLE jiraanalysis.story_points_tmp
SELECT p.id AS project_id, j.id AS jira_id, j.issuenum AS issue_key, p.pname, cf.numbervalue
FROM jiradb.jiraissue j
INNER JOIN jiradb.customfieldvalue cf
	ON cf.issue = j.id
	AND cf.customfield = 10002
INNER JOIN jiradb.project p 
	ON j.project = p.id 
;

DROP TABLE IF EXISTS jiraanalysis.sprints_tmp;
CREATE TABLE jiraanalysis.sprints_tmp
SELECT p.id AS project_id, j.id AS jira_id, j.issuenum, j.issuenum AS issue_key, p.pkey, p.pname, s.name
FROM jiradb.jiraissue j
INNER JOIN jiradb.customfieldvalue cf
	ON cf.issue = j.id
INNER JOIN jiradb.AO_60DB71_SPRINT s
	ON (s.id = cf.stringvalue
	AND cf.customfield = 10005)	
INNER JOIN jiradb.project p 
	ON j.project = p.id ;


SELECT s.pkey AS `Project Key`
	,p.pname AS `Project`
	,s.name AS `Sprint`
	,SUM(p.numbervalue) AS `Story Point`
FROM jiraanalysis.story_points_tmp p
INNER JOIN jiraanalysis.sprints_tmp s
	ON s.project_id = p.project_id
	AND s.jira_id = p.jira_id
WHERE s.name LIKE 'PC%'
GROUP BY s.pkey, p.pname, s.name;
	
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

