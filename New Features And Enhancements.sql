DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_new_fea_enh`$$

CREATE PROCEDURE `sp_new_fea_enh`()
BEGIN
	DROP TABLE IF EXISTS jiraanalysis.new_features_enhancements;
	CREATE TABLE jiraanalysis.new_features_enhancements
	SELECT j.issuenum AS IssueKey
	,p.pkey
	,p.pname AS ProjectName
	,MIN(cg.created) AS FirstDateMovedToNew
	,COUNT(1) AS TimesInNew
	,ist.pname AS CurrentStatus
	FROM jiradb.changeitem ci
	INNER JOIN jiradb.changegroup cg ON ci.groupid = cg.ID
	INNER JOIN jiradb.jiraissue j ON j.id = cg.issueid
	INNER JOIN jiradb.project p 
		ON (j.project = p.id 
		AND p.id = 10701) # PCL
	INNER JOIN jiradb.issuetype it 
		ON (it.id = j.issuetype
		AND it.id IN (10109, 4)) # 4: ENH, 10109: FEA
	INNER JOIN jiradb.issuestatus ist ON ist.id = j.issuestatus
	WHERE (LOWER(ci.FIELD) = 'status') 
	AND LOWER(ci.NEWSTRING) = 'new'
	AND j.created >= '2017-01-01'
	#and j.issuenum = '10961'
	GROUP BY j.issuenum, p.pkey, p.pname, ist.pname
	#having count(1) > 1
	;

END$$

DELIMITER ;