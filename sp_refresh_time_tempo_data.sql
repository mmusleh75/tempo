DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_refresh_time_tempo_data`$$

CREATE PROCEDURE `sp_refresh_time_tempo_data`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.tmp_tempo_data;
	
	CREATE TABLE jiraanalysis.tmp_tempo_data
	SELECT DISTINCT 
	ji.id AS JIRAID
	,ji.issuenum AS `Issue Number`
	,ji.summary AS `Issue summary`	
	,(wl.timeworked/60/60) AS `Hours`	
	,wl.created AS `Created Date`
	,wl.startdate AS `Work Date`
	,YEAR(wl.startdate) AS `Work Year`	
	,MONTH(wl.startdate) AS `Work Month`	
	,QUARTER(wl.startdate) AS `Work Quarter`		
	,WEEKOFYEAR(wl.startdate) AS `Work Week`
	,'yyyy-mm-dd' `Work Day`
	,'xxxxxxxxxx' `Day Name`
	,d.employee_id
	,u.user_name AS `Username`	
	,u.display_name AS `Full name`	
	,d.job AS `Job Title`
	,ac.key AS `Account Key`
	,ac.name AS `Account Name`
	,it.pname AS `Issue Type`	
	,ist.pname AS `Issue Status`	
	,p.pkey AS `Project Key`	
	,p.pname AS `Project Name`	
	,wl.worklogbody AS `Work Description`	
	,ji.reporter AS `Reporter`	
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =10223 AND issue=ji.id) AS Product
	,(SELECT GROUP_CONCAT(a.customvalue) FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11619 AND issue=ji.id
	GROUP BY issue) AS BUGCategory	
--	,pv.vname AS `Fix Version` # multiple fix version per ticket generated dups in logged hrs
--	,c.cname AS `Component` # multiple components per ticket generated dups in logged hrs
	,IFNULL(d.team,'No Team') AS `Sprint Team`
	,(SELECT cf.numbervalue FROM jiradb.customfieldvalue cf WHERE cf.customfield = 10002 AND cf.issue = ji.id) AS `Story Points`	
	,IFNULL(d.department,'No Department') AS `Department`
	,d.Contractor
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
	,' No' AS DataEngineer
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
	GROUP BY j.id) AS FixedVersion
	FROM jiradb.worklog wl
	INNER JOIN jiradb.jiraissue ji
		ON ji.id = wl.issueid
#	LEFT JOIN jiradb.label l ON l.issue = ji.id
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
	INNER JOIN jiradb.app_user au
		ON au.user_key = wl.author
	INNER JOIN jiradb.cwd_user u
		ON (u.lower_user_name = au.lower_user_name
		AND u.directory_id = 10100)			# added 6/3/2016
	LEFT JOIN jiraanalysis.team_lookup d
		ON LOWER(d.username) = LOWER(u.lower_user_name)
#	LEFT JOIN jiraanalysis.team_lookup stm
#		ON LOWER(stm.username) = LOWER(u.lower_user_name)
	INNER JOIN jiradb.AO_AEFED0_TEAM_MEMBER_V2 tm
		ON (tm.member_key = au.user_key
		AND tm.member_key = wl.author
		AND tm.team_id = 33) # PDEV			-- keep this
	--   INNER JOIN AO_AEFED0_TEAM_V2 t
	--   	ON t.id = tm.team_id
	INNER JOIN jiradb.`AO_AEFED0_MEMBERSHIP` m
		ON tm.id = m.team_member_id
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
	WHERE wl.startdate >= '2017-01-01'
	#and wl.startdate <= '2016-01-12'
	AND u.display_name != 'Singh, Jagmit' 	-- keep this
	#AND ji.issuenum = '26159'
#	and p.pkey = 'PLS'
	ORDER BY wl.startdate DESC
	;

	DELETE FROM jiraanalysis.tmp_tempo_data
	WHERE Username IN ('dplatt','jcummins','jisaac','jsellens','mhorton')
	AND `Work Date` > '2016-03-10';  -- DO NOT CHANGE THE YEAR
	
	DELETE FROM jiraanalysis.tmp_tempo_data
	WHERE Username IN ('fouma','mmorrison')
	AND `Work Date` >= '2016-11-01'; -- DO NOT CHANGE THE YEAR

	DELETE FROM jiraanalysis.tmp_tempo_data
	WHERE Username IN ('sfarha','kbartholomae')
	AND `Work Date` >= '2017-01-01' -- DO NOT CHANGE THE YEAR
	AND `Project Key` != 'TM';
	
	DELETE FROM jiraanalysis.tmp_tempo_data
	WHERE Username IN ('tmcdermott')
	AND `Work Date` >= '2017-02-20' -- DO NOT CHANGE THE YEAR
	;	

	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-01' WHERE `Work Date` BETWEEN '2016-12-29 12:00:01' AND '2017-01-11 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-02' WHERE `Work Date` BETWEEN '2017-01-11 12:00:01' AND '2017-01-25 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-03' WHERE `Work Date` BETWEEN '2017-01-25 12:00:01' AND '2017-02-08 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-04' WHERE `Work Date` BETWEEN '2017-02-08 12:00:01' AND '2017-02-22 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-05' WHERE `Work Date` BETWEEN '2017-02-22 12:00:01' AND '2017-03-08 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-06' WHERE `Work Date` BETWEEN '2017-03-08 12:00:01' AND '2017-03-22 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-07' WHERE `Work Date` BETWEEN '2017-03-22 12:00:01' AND '2017-04-05 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-08' WHERE `Work Date` BETWEEN '2017-04-05 12:00:01' AND '2017-04-19 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-09' WHERE `Work Date` BETWEEN '2017-04-19 12:00:01' AND '2017-05-03 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-10' WHERE `Work Date` BETWEEN '2017-05-03 12:00:01' AND '2017-05-17 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-11' WHERE `Work Date` BETWEEN '2017-05-17 12:00:01' AND '2017-05-31 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-12' WHERE `Work Date` BETWEEN '2017-05-31 12:00:01' AND '2017-06-14 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-13' WHERE `Work Date` BETWEEN '2017-06-14 12:00:01' AND '2017-06-28 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-14' WHERE `Work Date` BETWEEN '2017-06-28 12:00:01' AND '2017-07-12 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-15' WHERE `Work Date` BETWEEN '2017-07-12 12:00:01' AND '2017-07-26 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-16' WHERE `Work Date` BETWEEN '2017-07-26 12:00:01' AND '2017-08-09 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-17' WHERE `Work Date` BETWEEN '2017-08-09 12:00:01' AND '2017-08-23 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-18' WHERE `Work Date` BETWEEN '2017-08-23 12:00:01' AND '2017-09-06 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-19' WHERE `Work Date` BETWEEN '2017-09-06 12:00:01' AND '2017-09-20 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-20' WHERE `Work Date` BETWEEN '2017-09-20 12:00:01' AND '2017-10-04 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-21' WHERE `Work Date` BETWEEN '2017-10-04 12:00:01' AND '2017-10-18 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-22' WHERE `Work Date` BETWEEN '2017-10-18 12:00:01' AND '2017-11-01 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-23' WHERE `Work Date` BETWEEN '2017-11-01 12:00:01' AND '2017-11-15 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-24' WHERE `Work Date` BETWEEN '2017-11-15 12:00:01' AND '2017-11-29 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-25' WHERE `Work Date` BETWEEN '2017-11-29 12:00:01' AND '2017-12-13 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-26' WHERE `Work Date` BETWEEN '2017-12-13 12:00:01' AND '2017-12-27 12:00:00';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-01' WHERE `Work Date` BETWEEN '2017-12-27 12:00:01' AND '2018-01-10 12:00:00';

/*
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-01' WHERE `Work Date` BETWEEN '2017-12-27 12:00:01' AND '2018-01-10 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-02' WHERE `Work Date` BETWEEN '2018-01-10 12:00:01' AND '2018-01-24 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-03' WHERE `Work Date` BETWEEN '2018-01-24 12:00:01' AND '2018-02-07 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-04' WHERE `Work Date` BETWEEN '2018-02-07 12:00:01' AND '2018-02-21 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-05' WHERE `Work Date` BETWEEN '2018-02-21 12:00:01' AND '2018-03-07 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-06' WHERE `Work Date` BETWEEN '2018-03-07 12:00:01' AND '2018-03-21 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-07' WHERE `Work Date` BETWEEN '2018-03-21 12:00:01' AND '2018-04-04 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-08' WHERE `Work Date` BETWEEN '2018-04-04 12:00:01' AND '2018-04-18 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-09' WHERE `Work Date` BETWEEN '2018-04-18 12:00:01' AND '2018-05-02 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-10' WHERE `Work Date` BETWEEN '2018-05-02 12:00:01' AND '2018-05-16 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-11' WHERE `Work Date` BETWEEN '2018-05-16 12:00:01' AND '2018-05-30 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-12' WHERE `Work Date` BETWEEN '2018-05-30 12:00:01' AND '2018-06-13 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-13' WHERE `Work Date` BETWEEN '2018-06-13 12:00:01' AND '2018-06-27 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-14' WHERE `Work Date` BETWEEN '2018-06-27 12:00:01' AND '2018-07-11 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-15' WHERE `Work Date` BETWEEN '2018-07-11 12:00:01' AND '2018-07-25 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-16' WHERE `Work Date` BETWEEN '2018-07-25 12:00:01' AND '2018-08-08 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-17' WHERE `Work Date` BETWEEN '2018-08-08 12:00:01' AND '2018-08-22 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-18' WHERE `Work Date` BETWEEN '2018-08-22 12:00:01' AND '2018-09-05 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-19' WHERE `Work Date` BETWEEN '2018-09-05 12:00:01' AND '2018-09-19 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-20' WHERE `Work Date` BETWEEN '2018-09-19 12:00:01' AND '2018-10-03 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-21' WHERE `Work Date` BETWEEN '2018-10-03 12:00:01' AND '2018-10-17 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-22' WHERE `Work Date` BETWEEN '2018-10-17 12:00:01' AND '2018-10-31 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-23' WHERE `Work Date` BETWEEN '2018-10-31 12:00:01' AND '2018-11-14 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-24' WHERE `Work Date` BETWEEN '2018-11-14 12:00:01' AND '2018-11-28 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-25' WHERE `Work Date` BETWEEN '2018-11-28 12:00:01' AND '2018-12-12 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-26' WHERE `Work Date` BETWEEN '2018-12-12 12:00:01' AND '2018-12-26 12:00:00';
UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-27' WHERE `Work Date` BETWEEN '2018-12-26 12:00:01' AND '2019-01-09 12:00:00';

*/
	
	UPDATE jiraanalysis.tmp_tempo_data SET `Days Lag` = DATEDIFF(`Created Date`, `Work Date`);

	UPDATE jiraanalysis.tmp_tempo_data SET `EPIC Key` = CONCAT(`Epic Project Key`,'-',`Epic Ticket`);
	UPDATE jiraanalysis.tmp_tempo_data SET `Issue Key` = CONCAT(`Project Key`,'-',`Issue Number`);	
	
	UPDATE jiraanalysis.tmp_tempo_data SET `Work Day` = DATE_FORMAT(`Work Date`, '%Y-%m-%d');
	
	UPDATE jiraanalysis.tmp_tempo_data SET `Day Name` = DATE_FORMAT(`Work Date`, '%a');

	CREATE INDEX Username_index ON jiraanalysis.tmp_tempo_data (`Username`);
	CREATE INDEX WordDay_index ON jiraanalysis.tmp_tempo_data (`Work Day`);
	
	DROP TABLE IF EXISTS jiraanalysis.LT8Hrs;
	CREATE TABLE jiraanalysis.LT8Hrs
	SELECT `Username`, `Work Day`
	FROM jiraanalysis.tmp_tempo_data
	GROUP BY `Username`, `Work Day`
	HAVING SUM(`Hours`) < 8;

	CREATE INDEX Username_index ON jiraanalysis.LT8Hrs (`Username`);
	CREATE INDEX WordDay_index ON jiraanalysis.LT8Hrs (`Work Day`);

	UPDATE jiraanalysis.tmp_tempo_data d
	INNER JOIN jiraanalysis.LT8Hrs h
		ON h.`Username` = d.`Username`
		AND h.`Work Day` = d.`Work Day`
	SET `LT8Hrs` = 1;
	
	UPDATE jiraanalysis.tmp_tempo_data
	SET bugcategory = 'Not Assigned'
	WHERE bugcategory IS NULL;

	UPDATE jiraanalysis.tmp_tempo_data
	SET bugcategory = 'Not Assigned'
	WHERE TRIM(bugcategory) = '';

	UPDATE jiraanalysis.tmp_tempo_data
	SET `Issue Number` = 31
		,`Issue summary` = 'PTO 2017'
	WHERE `Created Date` <= '2016-12-31'
	AND `Work Date` >= '2017-01-01'
	AND `Project Key` = 'IN'
	AND `Issue Number` = 5;
	/*
	-- Set Data Engineer Flag
	UPDATE jiraanalysis.tmp_tempo_data
	SET DataEngineer = 'Yes'
	WHERE `Username` IN ('dpeterson','mwills','aahmed','ppatil');
	
	UPDATE jiraanalysis.tmp_tempo_data
	SET DataEngineer = TRIM(DataEngineer);
	*/
	-- Start ONC2015 Tempo collection
	CALL jiraanalysis.sp_refresh_time_tempo_data_ONC2015();
		
	INSERT INTO jiraanalysis.tmp_tempo_data
	SELECT * FROM jiraanalysis.tmp_tempo_dataONC2015;
	-- End ONC2015 Tempo collection

	DROP TABLE IF EXISTS jiraanalysis.tempo_data_no_sprint;
	
	RENAME TABLE jiraanalysis.tmp_tempo_data TO jiraanalysis.tempo_data_no_sprint;
/*
	drop table if exists jiraanalysis.tempo_planned_time;
	create table jiraanalysis.tempo_planned_time
	SELECT pl.plan_item_id AS JIRAID, (pl.commitment*8) AS PlannedHours, pl.created_by AS PlannedBy, pl.start_time AS PlannedDate
	FROM jiradb.AO_2D3BEA_PLAN_ALLOCATION pl
	WHERE pl.plan_item_type = 'ISSUE';
	*/

    END$$

DELIMITER ;
