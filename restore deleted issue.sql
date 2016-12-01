# --- restore
-- DONE
INSERT INTO jiradb.jiraissue
SELECT ji.* 
FROM restored.jiraissue ji
WHERE id != 78509;

-- DONE
INSERT INTO jiradb.issuelink
SELECT il.* 
FROM restored.issuelink il
WHERE destination != 78509;

/*

select ji.*
from jiradb.jiraissue ji
inner join jiradb.issuelink il
	on il.destination = ji.id
where il.source = 78718

*/

ALTER TABLE restored.changegroup ADD COLUMN new_id DECIMAL(18,0);

UPDATE restored.changegroup
SET new_id = (SELECT MAX(id)+1 FROM jiradb.changegroup)
WHERE id = 57799;

UPDATE restored.changegroup
SET new_id = id
WHERE id != 57799;


UPDATE restored.changeitem ci
INNER JOIN restored.changegroup cg
	ON cg.id = ci.groupid
SET ci.groupid = cg.new_id
WHERE cg.id = 57799
;

INSERT INTO jiradb.changegroup
SELECT new_id, issueid, author, created
FROM restored.changegroup
;

INSERT INTO jiradb.changeitem
SELECT ci.* 
FROM restored.changeitem ci
INNER JOIN restored.changegroup cg
	ON cg.id = ci.groupid
;

# -----
ALTER TABLE restored.jiraaction ADD COLUMN new_id DECIMAL(18,0);

UPDATE restored.jiraaction
SET new_id = NULL;

SELECT MAX(id) + 1 FROM jiradb.jiraaction;

UPDATE restored.jiraaction SET new_id = 197531 WHERE id = 170425;

UPDATE restored.jiraaction
SET new_id = id WHERE new_id IS NULL;

SELECT * FROM jiradb.jiraaction WHERE id = 197531;

CALL sp_jiraaction();

-- 197530
INSERT INTO jiradb.jiraaction
SELECT ja.id, new_ID,issueid,AUTHOR,actiontype,actionlevel,rolelevel,actionbody,CREATED,UPDATEAUTHOR,UPDATED,actionnum
SELECT CONCAT('CO-',ji.issuenum), CONCAT('author:',ja.author,'  /  created:',ja.created,'  / comment:',ja.actionbody)
FROM restored.jiraaction ja
INNER JOIN restored.jiraissue ji
	ON ji.id = ja.issueid
-- where ja.issueid = 78509
;

# ---
INSERT INTO jiradb.fileattachment
SELECT * 
FROM restored.fileattachment
;

INSERT INTO jiradb.worklog
SELECT * 
FROM restored.worklog
;
