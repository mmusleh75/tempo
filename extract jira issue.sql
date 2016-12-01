DROP TABLE IF EXISTS restored.jiraissue;
DROP TABLE IF EXISTS restored.changegroup;
DROP TABLE IF EXISTS restored.changeitem;
DROP TABLE IF EXISTS restored.jiraaction;
DROP TABLE IF EXISTS restored.fileattachment;
DROP TABLE IF EXISTS restored.worklog;
DROP TABLE IF EXISTS restored.issuelink;


CREATE TABLE restored.jiraissue
SELECT ji.* 
FROM jiradb.jiraissue ji
INNER JOIN jiradb.project p
	ON p.id = ji.project
WHERE issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
AND p.id = 10729;

CREATE TABLE restored.changegroup
SELECT cg.*
FROM jiradb.changegroup cg
INNER JOIN jiradb.jiraissue ji
	ON ji.id = cg.issueid
WHERE ji.issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
;

CREATE TABLE restored.changeitem
SELECT ci.* 
FROM jiradb.changeitem ci
INNER JOIN jiradb.changegroup cg
	ON cg.id = ci.groupid
INNER JOIN jiradb.jiraissue ji
	ON ji.id = cg.issueid
WHERE ji.issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
;


CREATE TABLE restored.jiraaction
SELECT ja.*
FROM jiradb.jiraaction ja
INNER JOIN jiradb.jiraissue ji
	ON ji.id = ja.issueid
WHERE ji.issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
;


CREATE TABLE restored.fileattachment
SELECT fa.* 
FROM jiradb.fileattachment fa
INNER JOIN jiradb.jiraissue ji
	ON ji.id = fa.issueid
WHERE ji.issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
;

/*
CREATE TABLE restored.project
SELECT * 
FROM jiradb.project;
*/

CREATE TABLE restored.worklog
SELECT wl.* 
FROM jiradb.worklog wl
INNER JOIN jiradb.jiraissue ji
	ON ji.id = wl.issueid
WHERE ji.issuenum  IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
;


CREATE TABLE restored.issuelink
SELECT issuelink.* -- j1.id, j1.issuenum, issuelinktype.INWARD, j2.issuenum 
FROM jiradb.jiraissue j1, jiradb.issuelink, jiradb.issuelinktype, jiradb.jiraissue j2 
WHERE j1.id=issuelink.SOURCE 
AND j2.id=issuelink.DESTINATION 
AND issuelinktype.id=issuelink.linktype
AND j2.issuenum IN (1318,1324,1319,1321,1322,1323,1317,1320,1515,1516,1517,1518,1519,1520,1521,1633,1649,1677)
AND issuelink.SOURCE = 78718
AND issuelinktype.INWARD = 'jira_subtask_inward';


-- ---------------

SELECT CONCAT('author:',ja.author,'  /  created:',ja.created,'  / comment:',ja.actionbody)
FROM restored.jiraaction ja
INNER JOIN restored.jiraissue ji
	ON ji.id = ja.issueid
WHERE ji.issuenum = 1317
;

SELECT * FROM jiradb.jiraaction WHERE issueid = 78509;
