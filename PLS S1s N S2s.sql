DROP TABLE IF EXISTS jiraanalysis.mhm_all_pls;
CREATE TABLE jiraanalysis.mhm_all_pls
SELECT DISTINCT 
j.id
,j.issuenum AS jira
,j.created
,j.Resolutiondate AS ResolvedDate
,j.issuestatus
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=j.id) AS Severity
FROM jiradb.jiraissue j
INNER JOIN jiradb.project p 
	ON p.id = j.project
WHERE p.pkey = 'PLS'
AND j.created <= '2016-10-31';


SELECT Severity, COUNT(1) FROM jiraanalysis.mhm_all_pls GROUP BY Severity;

DELETE FROM jiraanalysis.mhm_all_pls WHERE Severity IS NULL;
DELETE FROM jiraanalysis.mhm_all_pls WHERE Severity LIKE 'S3%';
DELETE FROM jiraanalysis.mhm_all_pls WHERE Severity LIKE 'S4%';
DELETE FROM jiraanalysis.mhm_all_pls WHERE Severity LIKE 'N/A';

SELECT Severity, COUNT(1) FROM jiraanalysis.mhm_all_pls GROUP BY Severity;

-- should've been counted as of 10/31
SELECT *
FROM jiraanalysis.mhm_all_pls
WHERE ResolvedDate > '2016-10-31'
;

SELECT ji.*, ist.pname
FROM jiraanalysis.mhm_all_pls ji
INNER JOIN jiradb.issuestatus ist
	ON ist.id = ji.issuestatus
WHERE ist.pname != 'Closed'
#ResolvedDate > '2016-10-31'
;

SELECT * FROM jiradb.issuestatus

SELECT DISTINCT j.jira
,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10217 AND issue=j.id) AS Severity
FROM jiraanalysis.mhm_all_pls j
INNER JOIN jiradb.changegroup cg
	ON j.id = cg.issueid
INNER JOIN  jiradb.changeitem ci
	ON ci.groupid = cg.ID
/*
	
INNER JOIN jiradb.issuetype it
	ON it.id = j.issuetype
INNER JOIN jiradb.issuestatus ist
	ON ist.id = j.issuestatus
	*/

WHERE ci.Field = 'status'
#and ci.newstring = 'Closed'
AND j.ResolvedDate > '2016-10-31'
#AND j.jira IN ('12683', '12958','27116','25929','28549')
;

SELECT DISTINCT FIELD FROM jiradb.changeitem WHERE FIELD LIKE '%Status%';
