DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_refresh_pc_release_data`$$

CREATE PROCEDURE `sp_refresh_pc_release_data`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.tmp_pc_release_data;
	
	CREATE TABLE jiraanalysis.tmp_pc_release_data
	SELECT DISTINCT 
	ji.issuenum AS `Issue Number`
	,ji.summary AS `Issue summary`	
	,ac.key AS `Account Key`
	,ac.name AS `Account Name`
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
	,NULL AS `ClosedDate`
	,'xxxxxxxxxxxxxxxxxxxxx' AS `Issue Key`
	,'xxxxxxxxxxxxxxxxxxxxx' AS `EPIC Key`
	,0 AS `LT8Hrs`
	,0000.00 AS `Days Lag`
#	,l.label
	FROM jiradb.jiraissue ji
	INNER JOIN jiradb.customfieldvalue cfv
		ON cfv.issue = ji.id
	INNER JOIN jiradb.AO_C3C6E8_ACCOUNT_V1 ac 
		ON (cfv.numbervalue = ac.id
		AND ac.key IN ('OP','CAP','BILL'))
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
/*
	LEFT JOIN jiradb.nodeassociation na
		ON ji.id = na.SOURCE_NODE_ID
		AND na.ASSOCIATION_TYPE = 'IssueFixVersion'
	LEFT JOIN jiradb.projectversion pv
		ON na.SINK_NODE_ID = pv.id

	LEFT JOIN jiradb.nodeassociation cna
		ON ji.id = cna.SOURCE_NODE_ID
		AND cna.ASSOCIATION_TYPE = 'IssueComponent'
	LEFT JOIN jiradb.component c
		ON cna.SINK_NODE_ID = c.id
*/
	WHERE p.pkey = 'VTEN'
	;

	DROP TABLE IF EXISTS jiraanalysis.tmp_vten_closed;
	
	CREATE TABLE jiraanalysis.tmp_vten_closed
	SELECT j.issuenum AS JiraID
	,MAX(cg.CREATED) ClosedDate
	FROM jiradb.changeitem ci
	INNER JOIN jiradb.changegroup cg
		ON ci.groupid = cg.ID
	INNER JOIN jiradb.jiraissue j 
		ON j.id = cg.issueid
	WHERE j.project = 10701
	AND ci.field = 'status'
	AND ci.NEWSTRING = 'Closed'
	GROUP BY j.issuenum
	;
	
	CREATE INDEX JiraID_index ON jiraanalysis.tmp_vten_closed (`JiraID`);	

	UPDATE jiraanalysis.tmp_vten_closed c
	INNER JOIN jiraanalysis.tmp_pc_release_data pc
		ON pc.`Issue Number` = c.JiraID
	SET pc.ClosedDate = c.ClosedDate;
	
	UPDATE jiraanalysis.tmp_pc_release_data
	SET bugcategory = 'Not Assigned'
	WHERE bugcategory IS NULL;

	UPDATE jiraanalysis.tmp_pc_release_data
	SET bugcategory = 'Not Assigned'
	WHERE TRIM(bugcategory) = '';

	DROP TABLE IF EXISTS jiraanalysis.pc_release_data_2017;
	
	RENAME TABLE jiraanalysis.tmp_pc_release_data TO jiraanalysis.pc_release_data_2017;
	
    END$$

DELIMITER ;
