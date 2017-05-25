DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_data_migrations`$$

CREATE PROCEDURE `sp_data_migrations`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.tmp_data_migrations;
	
	CREATE TABLE jiraanalysis.tmp_data_migrations
	SELECT DISTINCT 
	ji.issuenum AS `Issue Number`
	,ji.summary AS `Issue summary`	
	,it.pname AS `Issue Type`	
	,ist.pname AS `Issue Status`	
	,p.pkey AS `Project Key`	
	,p.pname AS `Project Name`	
	,ji.reporter AS `Reporter`	
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=ji.id) AS Product
	,(SELECT GROUP_CONCAT(a.customvalue) FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11619 AND issue=ji.id
	GROUP BY issue) AS BUGCategory	
#	,pv.vname AS `Fix Version` # multiple fix version per ticket generated dups in logged hrs
--	,c.cname AS `Component` # multiple components per ticket generated dups in logged hrs
	,(SELECT GROUP_CONCAT(pv.vname)
	FROM jiradb.nodeassociation na
	INNER JOIN jiradb.jiraissue j
		ON j.id = na.source_node_id
	INNER JOIN jiradb.projectversion pv
		ON pv.id = na.sink_node_id
	WHERE j.id = ji.id
	AND na.association_type = 'IssueVersion'
	GROUP BY j.id) AS AffectsVersion
	,(SELECT GROUP_CONCAT(pv.vname)
	FROM jiradb.nodeassociation na
	INNER JOIN jiradb.jiraissue j
		ON j.id = na.source_node_id
	INNER JOIN jiradb.projectversion pv
		ON pv.id = na.sink_node_id
	WHERE j.id = ji.id
	AND na.association_type = 'IssueFixVersion'
	GROUP BY j.id) AS `Fix Version`	
	,(SELECT cf.numbervalue FROM jiradb.customfieldvalue cf WHERE cf.customfield = 10002 AND cf.issue = ji.id) AS `Story Points`	
	,pp.pkey AS `Epic Project Key`
	,jp.issuenum AS `Epic Ticket`	
	,jp.summary AS `Epic Name`	
	,jp.summary AS `Epic Summary`
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=jp.id) AS EPIC_Product	
	,(SELECT l.label FROM jiradb.label l INNER JOIN jiradb.customfield cf ON cf.id = l.fieldid WHERE cf.id = 10001 AND l.issue = jp.id LIMIT 1) AS `Epic Theme`
	,(SELECT t.description FROM jiradb.label l 
	INNER JOIN jiradb.customfield cf ON cf.id = l.fieldid 
	INNER JOIN `jiraanalysis`.themes t
		ON t.name = l.label
	WHERE cf.id = 10001 AND l.issue = jp.id LIMIT 1) AS `Theme Description`
	,'xxxxxxxxxxxxxxxxxxxxx' AS `Sprint`
	,'xxxxxxxxxxxxxxxxxxxxx' AS `Issue Key`
	,'xxxxxxxxxxxxxxxxxxxxx' AS `EPIC Key`
	,0 AS `LT8Hrs`
	,0000.00 AS `Days Lag`
#	,l.label
	FROM jiradb.jiraissue ji
	LEFT JOIN jiradb.issuelink il
		ON (il.destination = ji.id
		AND il.linktype = 10200)
	LEFT JOIN jiradb.jiraissue jp -- parent
		ON jp.id = il.source
	LEFT JOIN jiradb.project pp 
		ON pp.id = jp.project
	INNER JOIN jiradb.issuetype it
		ON it.id = ji.issuetype
	INNER JOIN jiradb.issuestatus ist
		ON ist.id = ji.issuestatus
	INNER JOIN jiradb.project p 
		ON p.id = ji.project
	WHERE jp.issuenum IN (2451, 10318) -- EPIC Tickets
	;

	
    END$$

DELIMITER ;
