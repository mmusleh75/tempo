
DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_tickets_trends_traditional`$$

CREATE PROCEDURE `sp_tickets_trends_traditional`()
BEGIN

	SET @cur_month = CONCAT(YEAR(CURDATE()),'-', MONTH(CURDATE()),'-1');
	SET @prev_month = DATE_SUB(@cur_month, INTERVAL 1 DAY);
	#select @prev_month;

	#if ((select count(1) from monthly_trends_trad where EndDate = @prev_month) > 1) then
	IF (1=1)
	SELECT 1;
	ELSE
	SELECT 0;
	END IF;


	INSERT INTO monthly_trends_trad
	SELECT @prev_month, t.IssueType, SUM(t.cnt)
	FROM (
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_traditional
		WHERE STATUS != 'Closed'
		AND product NOT IN ('NHA','Secure Connect')
		AND CreateDate < @cur_month
		GROUP BY `IssueType`
		UNION ALL
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_traditional
		WHERE ResolvedDate >= @cur_month
		AND product NOT IN ('NHA','Secure Connect')
		AND CreateDate < @cur_month
		GROUP BY `IssueType`) t
	GROUP BY IssueType;

	SELECT * FROM monthly_trends_trad;

END$$

DELIMITER ;
