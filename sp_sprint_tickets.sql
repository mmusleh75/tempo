DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_sprint_tickets`$$

CREATE PROCEDURE `sp_sprint_tickets`()
BEGIN

	DROP TABLE IF EXISTS jiraanalysis.sprint_tickets;

	CREATE TABLE jiraanalysis.sprint_tickets
	SELECT 
	p.pkey AS ProjectKey
	,j.issuenum AS TicketNo
	,ci.oldstring AS FromStatus
	,ci.newstring AS ToStatus
	,cg.created AS StatusChangeDate
	,cg.author AS StatusChangedBy
	,ist.pname AS CurrentStatus
	,j.created AS IssueCreateDate
	,(SELECT cf.numbervalue FROM jiradb.customfieldvalue cf WHERE cf.customfield = 10002 AND cf.issue = j.id) AS `StoryPoints`	
	,'xxxxxxxxxxxxxxxxxxxxx' AS `Sprint`
	FROM jiradb.changeitem ci
	INNER JOIN jiradb.changegroup cg
		ON ci.groupid = cg.ID
	INNER JOIN jiradb.jiraissue j 
		ON j.id = cg.issueid
	INNER JOIN jiradb.project p 
		ON p.id = j.project
	INNER JOIN jiradb.issuetype it
		ON it.id = j.issuetype
	INNER JOIN jiradb.issuestatus ist
		ON ist.id = j.issuestatus
	WHERE (ci.FIELD = 'status') 
	AND ci.newstring IN ('QA Line Pass')
	#AND j.issuetype=10110 # SWM 
	#AND j.PROJECT = 10101 # Pulse Systems Project
	#	or (ci.field = 'assignee' and cast(ci.newstring as varchar) = 'PS Triage'))
	#and j.created >= '2013-01-01'
	AND cg.created >= '2016-01-01';

	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-01' WHERE `StatusChangeDate` BETWEEN '2015-12-31 00:00:00' AND '2016-01-13 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-02' WHERE `StatusChangeDate` BETWEEN '2016-01-14 00:00:00' AND '2016-01-27 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-03' WHERE `StatusChangeDate` BETWEEN '2016-01-28 00:00:00' AND '2016-02-10 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-04' WHERE `StatusChangeDate` BETWEEN '2016-02-11 00:00:00' AND '2016-02-24 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-05' WHERE `StatusChangeDate` BETWEEN '2016-02-25 00:00:00' AND '2016-03-09 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-06' WHERE `StatusChangeDate` BETWEEN '2016-03-10 00:00:00' AND '2016-03-23 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-07' WHERE `StatusChangeDate` BETWEEN '2016-03-24 00:00:00' AND '2016-04-06 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-08' WHERE `StatusChangeDate` BETWEEN '2016-04-07 00:00:00' AND '2016-04-20 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-09' WHERE `StatusChangeDate` BETWEEN '2016-04-21 00:00:00' AND '2016-05-04 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-10' WHERE `StatusChangeDate` BETWEEN '2016-05-05 00:00:00' AND '2016-05-18 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-11' WHERE `StatusChangeDate` BETWEEN '2016-05-19 00:00:00' AND '2016-06-01 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-12' WHERE `StatusChangeDate` BETWEEN '2016-06-02 00:00:00' AND '2016-06-15 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-13' WHERE `StatusChangeDate` BETWEEN '2016-06-16 00:00:00' AND '2016-06-29 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-14' WHERE `StatusChangeDate` BETWEEN '2016-06-30 00:00:00' AND '2016-07-13 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-15' WHERE `StatusChangeDate` BETWEEN '2016-07-14 00:00:00' AND '2016-07-27 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-16' WHERE `StatusChangeDate` BETWEEN '2016-07-28 00:00:00' AND '2016-08-10 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-17' WHERE `StatusChangeDate` BETWEEN '2016-08-11 00:00:00' AND '2016-08-24 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-18' WHERE `StatusChangeDate` BETWEEN '2016-08-25 00:00:00' AND '2016-09-07 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-19' WHERE `StatusChangeDate` BETWEEN '2016-09-08 00:00:00' AND '2016-09-21 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-20' WHERE `StatusChangeDate` BETWEEN '2016-09-22 00:00:00' AND '2016-10-05 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-21' WHERE `StatusChangeDate` BETWEEN '2016-10-06 00:00:00' AND '2016-10-19 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-22' WHERE `StatusChangeDate` BETWEEN '2016-10-20 00:00:00' AND '2016-11-02 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-23' WHERE `StatusChangeDate` BETWEEN '2016-11-03 00:00:00' AND '2016-11-16 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-24' WHERE `StatusChangeDate` BETWEEN '2016-11-17 00:00:00' AND '2016-11-30 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-25' WHERE `StatusChangeDate` BETWEEN '2016-12-01 00:00:00' AND '2016-12-14 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-26' WHERE `StatusChangeDate` BETWEEN '2016-12-15 00:00:00' AND '2016-12-28 23:59:59';
	UPDATE jiraanalysis.sprint_tickets SET sprint = '16-27' WHERE `StatusChangeDate` BETWEEN '2016-12-29 00:00:00' AND '2017-01-11 23:59:59';

	
	SELECT * FROM jiraanalysis.sprint_tickets;
	
    END$$

DELIMITER ;
