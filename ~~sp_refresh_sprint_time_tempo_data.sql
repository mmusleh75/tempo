DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_refresh_sprint_time_tempo_data`$$

CREATE  PROCEDURE `sp_refresh_sprint_time_tempo_data`()
BEGIN
	DROP TABLE IF EXISTS jiraanalysis.tempo_sprint_data_tmp;
	CREATE TABLE jiraanalysis.tempo_sprint_data_tmp
	SELECT DISTINCT 
	ji.issuenum AS `Issue Number`
	,ji.summary AS `Issue summary`	
	,(wl.timeworked/60/60) AS `Hours`	
	,wl.created AS `Created Date`
	,wl.startdate AS `Work date`	
	,YEAR(wl.startdate) AS `Work Year`	
	,MONTH(wl.startdate) AS `Work Month`	
	,QUARTER(wl.startdate) AS `Work Quarter`		
	,WEEKOFYEAR(wl.startdate) AS `Work Week`		
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
	,s.name AS `Sprint`	-- ticket exists in multiple sprints 	
	,(SELECT cf.numbervalue FROM jiradb.customfieldvalue cf WHERE cf.customfield = 10002 AND cf.issue = ji.id) AS `Story Points`
--	,pv.vname AS `Fix Version` # multiple fix version per ticket generated dups in logged hrs
--	,c.cname AS `Component` # multiple components per ticket generated dups in logged hrs
	,stm.team AS `Sprint Team`
	,d.department AS `Department`
	,pp.pkey AS `Epic Project Key`
	,jp.issuenum AS `Epic Ticket`	
	,jp.summary AS `Epic Name`	
	,jp.summary AS `Epic Summary`
	,(SELECT l.label FROM jiradb.label l INNER JOIN jiradb.customfield cf ON cf.id = l.fieldid WHERE cf.id = 10001 AND l.issue = jp.id LIMIT 1) AS `Epic Theme`
	,(SELECT t.description FROM jiradb.label l 
	INNER JOIN jiradb.customfield cf ON cf.id = l.fieldid 
	INNER JOIN `jiraanalysis`.themes t
		ON t.name = l.label
	WHERE cf.id = 10001 AND l.issue = jp.id LIMIT 1) AS `Theme Description`
	FROM jiradb.jiraissue ji	
	INNER JOIN jiradb.worklog wl
		ON ji.id = wl.issueid
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
		ON u.lower_user_name = au.lower_user_name
	LEFT JOIN jiraanalysis.team_lookup d
		ON d.username = u.lower_user_name
	LEFT JOIN jiraanalysis.team_lookup stm
		ON stm.username = u.lower_user_name
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
	JOIN jiradb.customfieldvalue scf
		ON scf.issue = ji.id
	JOIN jiradb.AO_60DB71_SPRINT s
		ON (s.id = scf.stringvalue
		AND scf.customfield = 10005)	
/*
	left join jiradb.nodeassociation na
		ON ji.id = na.SOURCE_NODE_ID
		and na.ASSOCIATION_TYPE = 'IssueFixVersion'
	left join jiradb.projectversion pv
		ON na.SINK_NODE_ID = pv.id
	LEFT JOIN jiradb.nodeassociation cna
		ON ji.id = cna.SOURCE_NODE_ID
		AND cna.ASSOCIATION_TYPE = 'IssueComponent'
	LEFT JOIN jiradb.component c
		ON cna.SINK_NODE_ID = c.id
*/			
	WHERE wl.startdate >= '2016-01-01'
	#and wl.startdate <= '2016-01-12'
	AND u.display_name != 'Singh, Jagmit' 	-- keep this
#	and u.user_name = 'sfarha'
	#AND ji.id = 80544
#	and ji.issuenum = '25564'
	ORDER BY wl.startdate DESC
	;
	
	DELETE FROM jiraanalysis.tempo_sprint_data_tmp
	WHERE Username IN ('dplatt','jcummins','jisaac','jsellens','mhorton')
	AND `Work date` > '2016-03-10';
		
	DROP TABLE IF EXISTS jiraanalysis.tempo_sprint_data;
	
	RENAME TABLE jiraanalysis.tempo_sprint_data_tmp TO jiraanalysis.tempo_sprint_data;
#	SELECT * FROM jiraanalysis.tempo_sprint_data;
	
    END$$

DELIMITER ;