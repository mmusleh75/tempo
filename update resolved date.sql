#SELECT ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, cg.author, ci.newstring, cg.created 

SELECT ji.issuenum,ji.project, COUNT(1)
FROM jiraissue ji
JOIN issuestatus st ON ji.issuestatus = st.id 
JOIN changegroup cg ON ji.id=cg.issueid 
JOIN changeitem ci ON ci.groupid=cg.id 
WHERE ji.resolutiondate >= '2015-12-14' 
	AND ji.resolutiondate < '2015-12-15' 
	AND ji.project IN (10101, 10500, 10701, 10724, 10729)
	AND ci.field='status' 
	AND ci.newstring = st.pname
GROUP BY ji.issuenum,ji.project
HAVING COUNT(1) > 5
;

SELECT ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, cg.author, ci.newstring, cg.created 
FROM jiraissue ji
JOIN issuestatus st ON ji.issuestatus = st.id 
JOIN changegroup cg ON ji.id=cg.issueid 
JOIN changeitem ci ON ci.groupid=cg.id 
WHERE ji.resolutiondate >= '2015-12-14' 
	AND ji.resolutiondate < '2015-12-15' 
	AND ji.project IN (10101, 10500, 10701, 10724, 10729)
	AND ci.field='status' 
	AND ci.newstring = st.pname
AND ji.issuenum = '3630'
AND ji.project = 10500
;

CREATE TABLE test.resolution_date
SELECT ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, cg.author, ci.newstring, MAX(cg.created) resolved_date_new
FROM jiraissue ji
JOIN issuestatus st ON ji.issuestatus = st.id 
JOIN changegroup cg ON ji.id=cg.issueid 
JOIN changeitem ci ON ci.groupid=cg.id 
WHERE ji.resolutiondate >= '2015-12-14' 
	AND ji.resolutiondate < '2015-12-15' 
	AND ji.project IN (10101, 10500, 10701, 10724, 10729)
	AND ci.field='status' 
	AND ci.newstring = st.pname
#AND ji.issuenum = '3630'
#AND ji.project = 10500
GROUP BY ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, cg.author, ci.newstring
;


SELECT * FROM project WHERE id IN (10101, 10500, 10701, 10724, 10729);



-- 6617 rows
SELECT rd.*
FROM test.resolution_date rd
INNER JOIN jiradb.jiraissue ji
	ON ji.id = rd.id
WHERE rd.issuenum = '2814'
AND rd.project = 10101
;


UPDATE test.resolution_date rd
INNER JOIN jiradb.jiraissue ji
	ON ji.id = rd.id
SET ji.resolutiondate = rd.resolved_date_new
;



CREATE TABLE test.resolution_date_null
SELECT ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, ci.newstring, MAX(cg.created) resolved_date_new
FROM jiraissue ji
JOIN issuestatus st ON ji.issuestatus = st.id 
JOIN changegroup cg ON ji.id=cg.issueid 
JOIN changeitem ci ON ci.groupid=cg.id 
WHERE ji.project IN (10101, 10500, 10701, 10724, 10729)
AND ci.field='status' 
AND ci.newstring = st.pname
AND ji.resolutiondate IS NULL
AND st.pname IN ('Resolved','Closed')
GROUP BY ji.id, ji.issuenum,ji.project, ji.summary, ji.resolutiondate,  st.pname,cg.issueid, ci.newstring
;

-- 181 rows
SELECT rd.*
FROM test.resolution_date_null rd
INNER JOIN jiradb.jiraissue ji
	ON ji.id = rd.id
WHERE rd.issuenum = '23081'
AND rd.project = 10101
;


UPDATE test.resolution_date_null rd
INNER JOIN jiradb.jiraissue ji
	ON ji.id = rd.id
SET ji.resolutiondate = rd.resolved_date_new
#WHERE rd.issuenum = '23081'
#AND rd.project = 10101
;

-- 1221
SELECT rd.*, ji.resolutiondate
FROM test.serena_tickets rd
INNER JOIN jiradb.jiraissue ji
	ON ji.issuenum = rd.issuenum
WHERE ji.project = 10101
#and rd.issuenum = '6654'

;



UPDATE test.serena_tickets rd
INNER JOIN jiradb.jiraissue ji
	ON ji.issuenum = rd.issuenum
SET ji.resolutiondate = rd.date_resolved
WHERE ji.project = 10101
#AND rd.issuenum = '7042'
;


