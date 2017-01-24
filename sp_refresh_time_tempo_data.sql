DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_refresh_time_tempo_data`$$

CREATE PROCEDURE `sp_refresh_time_tempo_data`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.tmp_tempo_data;
	
	CREATE TABLE jiraanalysis.tmp_tempo_data
	SELECT DISTINCT 
	ji.issuenum AS `Issue Number`
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
	,(SELECT a.customvalue FROM jiradb.customfieldvalue b INNER JOIN jiradb.customfieldoption a ON b.stringvalue = a.id 
	INNER JOIN jiradb.customfield ON b.customfield=customfield.ID WHERE b.customfield =11406 AND issue=ji.id) AS BUGCategory	
--	,pv.vname AS `Fix Version` # multiple fix version per ticket generated dups in logged hrs
--	,c.cname AS `Component` # multiple components per ticket generated dups in logged hrs
	,stm.team AS `Sprint Team`
	,(SELECT cf.numbervalue FROM jiradb.customfieldvalue cf WHERE cf.customfield = 10002 AND cf.issue = ji.id) AS `Story Points`	
	,d.department AS `Department`
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
#	,l.label
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
	LEFT JOIN jiraanalysis.team_lookup stm
		ON LOWER(stm.username) = LOWER(u.lower_user_name)
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
	AND `Work Date` > '2016-03-10';
	
	DELETE FROM jiraanalysis.tmp_tempo_data
	WHERE Username IN ('fouma','mmorrison')
	AND `Work Date` >= '2017-11-01';
/*
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-01' WHERE `Work Date` BETWEEN '2015-12-31 00:00:00' AND '2016-01-13 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-02' WHERE `Work Date` BETWEEN '2016-01-14 00:00:00' AND '2016-01-27 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-03' WHERE `Work Date` BETWEEN '2016-01-28 00:00:00' AND '2016-02-10 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-04' WHERE `Work Date` BETWEEN '2016-02-11 00:00:00' AND '2016-02-24 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-05' WHERE `Work Date` BETWEEN '2016-02-25 00:00:00' AND '2016-03-09 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-06' WHERE `Work Date` BETWEEN '2016-03-10 00:00:00' AND '2016-03-23 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-07' WHERE `Work Date` BETWEEN '2016-03-24 00:00:00' AND '2016-04-06 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-08' WHERE `Work Date` BETWEEN '2016-04-07 00:00:00' AND '2016-04-20 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-09' WHERE `Work Date` BETWEEN '2016-04-21 00:00:00' AND '2016-05-04 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-10' WHERE `Work Date` BETWEEN '2016-05-05 00:00:00' AND '2016-05-18 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-11' WHERE `Work Date` BETWEEN '2016-05-19 00:00:00' AND '2016-06-01 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-12' WHERE `Work Date` BETWEEN '2016-06-02 00:00:00' AND '2016-06-15 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-13' WHERE `Work Date` BETWEEN '2016-06-16 00:00:00' AND '2016-06-29 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-14' WHERE `Work Date` BETWEEN '2016-06-30 00:00:00' AND '2016-07-13 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-15' WHERE `Work Date` BETWEEN '2016-07-14 00:00:00' AND '2016-07-27 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-16' WHERE `Work Date` BETWEEN '2016-07-28 00:00:00' AND '2016-08-10 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-17' WHERE `Work Date` BETWEEN '2016-08-11 00:00:00' AND '2016-08-24 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-18' WHERE `Work Date` BETWEEN '2016-08-25 00:00:00' AND '2016-09-07 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-19' WHERE `Work Date` BETWEEN '2016-09-08 00:00:00' AND '2016-09-21 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-20' WHERE `Work Date` BETWEEN '2016-09-22 00:00:00' AND '2016-10-05 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-21' WHERE `Work Date` BETWEEN '2016-10-06 00:00:00' AND '2016-10-19 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-22' WHERE `Work Date` BETWEEN '2016-10-20 00:00:00' AND '2016-11-02 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-23' WHERE `Work Date` BETWEEN '2016-11-03 00:00:00' AND '2016-11-16 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-24' WHERE `Work Date` BETWEEN '2016-11-17 00:00:00' AND '2016-11-30 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-25' WHERE `Work Date` BETWEEN '2016-12-01 00:00:00' AND '2016-12-14 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '16-26' WHERE `Work Date` BETWEEN '2016-12-15 00:00:00' AND '2016-12-28 23:59:59';
*/

	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-01' WHERE `Work Date` BETWEEN '2016-12-29 00:00:00' AND '2017-01-11 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-02' WHERE `Work Date` BETWEEN '2017-01-12 00:00:00' AND '2017-01-25 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-03' WHERE `Work Date` BETWEEN '2017-01-26 00:00:00' AND '2017-02-08 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-04' WHERE `Work Date` BETWEEN '2017-02-09 00:00:00' AND '2017-02-22 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-05' WHERE `Work Date` BETWEEN '2017-02-23 00:00:00' AND '2017-03-08 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-06' WHERE `Work Date` BETWEEN '2017-03-09 00:00:00' AND '2017-03-22 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-07' WHERE `Work Date` BETWEEN '2017-03-23 00:00:00' AND '2017-04-05 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-08' WHERE `Work Date` BETWEEN '2017-04-06 00:00:00' AND '2017-04-19 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-09' WHERE `Work Date` BETWEEN '2017-04-20 00:00:00' AND '2017-05-03 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-10' WHERE `Work Date` BETWEEN '2017-05-04 00:00:00' AND '2017-05-17 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-11' WHERE `Work Date` BETWEEN '2017-05-18 00:00:00' AND '2017-05-31 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-12' WHERE `Work Date` BETWEEN '2017-06-01 00:00:00' AND '2017-06-14 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-13' WHERE `Work Date` BETWEEN '2017-06-15 00:00:00' AND '2017-06-28 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-14' WHERE `Work Date` BETWEEN '2017-06-29 00:00:00' AND '2017-07-12 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-15' WHERE `Work Date` BETWEEN '2017-07-13 00:00:00' AND '2017-07-26 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-16' WHERE `Work Date` BETWEEN '2017-07-27 00:00:00' AND '2017-08-09 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-17' WHERE `Work Date` BETWEEN '2017-08-10 00:00:00' AND '2017-08-23 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-18' WHERE `Work Date` BETWEEN '2017-08-24 00:00:00' AND '2017-09-06 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-19' WHERE `Work Date` BETWEEN '2017-09-07 00:00:00' AND '2017-09-20 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-20' WHERE `Work Date` BETWEEN '2017-09-21 00:00:00' AND '2017-10-04 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-21' WHERE `Work Date` BETWEEN '2017-10-05 00:00:00' AND '2017-10-18 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-22' WHERE `Work Date` BETWEEN '2017-10-19 00:00:00' AND '2017-11-01 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-23' WHERE `Work Date` BETWEEN '2017-11-02 00:00:00' AND '2017-11-15 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-24' WHERE `Work Date` BETWEEN '2017-11-16 00:00:00' AND '2017-11-29 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-25' WHERE `Work Date` BETWEEN '2017-11-30 00:00:00' AND '2017-12-13 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '17-26' WHERE `Work Date` BETWEEN '2017-12-14 00:00:00' AND '2017-12-27 23:59:59';
	UPDATE jiraanalysis.tmp_tempo_data SET sprint = '18-01' WHERE `Work Date` BETWEEN '2017-12-28 00:00:00' AND '2018-01-10 23:59:59';

	
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

	DROP TABLE IF EXISTS jiraanalysis.tempo_data_no_sprint;
	
	RENAME TABLE jiraanalysis.tmp_tempo_data TO jiraanalysis.tempo_data_no_sprint;
	
    END$$

DELIMITER ;
