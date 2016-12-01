DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_swm_tickets_trends_traditional`$$

CREATE PROCEDURE `sp_swm_tickets_trends_traditional`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_swm_tickets_traditional();

	TRUNCATE temp_swm_monthly_trends_trad;
	
	INSERT INTO temp_swm_monthly_trends_trad
	SELECT 'Incoming', DATE_FORMAT(tt.CreateDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_swm_tickets_traditional tt
	WHERE tt.Product NOT IN ('NHA','Secure Connect')
	AND tt.CreateDate >= '2016-01-01'
	GROUP BY DATE_FORMAT(tt.CreateDate, '%Y-%m');

	INSERT INTO temp_swm_monthly_trends_trad
	SELECT 'Closed', DATE_FORMAT(ResolvedDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_swm_tickets_traditional
	WHERE Product NOT IN ('NHA','Secure Connect')
	AND ResolvedDate >= '2016-01-01'		
	AND `Status` = 'Closed'
#	and ResolvedDate is not null
	GROUP BY DATE_FORMAT(ResolvedDate, '%Y-%m');

	
	INSERT INTO temp_swm_monthly_trends_trad
	SELECT Backlog,@prev_month, SUM(t.cnt)
	FROM (
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_swm_tickets_traditional
		WHERE STATUS != 'Closed'
		AND product NOT IN ('NHA','Secure Connect')
		AND CreateDate < @future_1st_of_month
		GROUP BY `Backlog`
		UNION ALL
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_swm_tickets_traditional
		WHERE ResolvedDate >= @future_1st_of_month
		AND product NOT IN ('NHA','Secure Connect')
		AND CreateDate < @future_1st_of_month
		GROUP BY `Backlog`
		
		) t
	GROUP BY Backlog;		
	
	INSERT INTO swm_monthly_trends_trad
	SELECT *
	FROM temp_swm_monthly_trends_trad tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_monthly_trends_trad tt
		WHERE tt.Group = tmp.Group
		AND tt.MY = tmp.MY);
	
	UPDATE swm_monthly_trends_trad tt
	INNER JOIN temp_swm_monthly_trends_trad tmp
		ON tmp.Group = tt.Group
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;
	
#	SELECT * FROM jiraanalysis.swm_monthly_trends_trad;	
	
END$$

DELIMITER ;