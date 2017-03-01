DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_tickets_trends_traditional`$$

CREATE PROCEDURE `sp_tickets_trends_traditional`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY);
	SET @old_month = DATE_FORMAT(DATE_SUB(@prev_month, INTERVAL 13 MONTH), '%Y-%m-%d');		
		
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_traditional();
	
	TRUNCATE temp_monthly_trends_trad;
	
	INSERT INTO temp_monthly_trends_trad
	SELECT @prev_month, t.IssueType, SUM(t.cnt)
	FROM (
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_traditional
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		GROUP BY `IssueType`
		UNION ALL
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_traditional
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		GROUP BY `IssueType`
		
		) t
	GROUP BY IssueType;
	IF ((SELECT COUNT(1) FROM monthly_trends_trad WHERE EndDate = @prev_month) > 1) THEN
		UPDATE monthly_trends_trad mt
		INNER JOIN temp_monthly_trends_trad tmp
			ON tmp.IssueType = mt.IssueType
			AND tmp.EndDate = mt.EndDate
		SET mt.IssueCount = tmp.IssueCount;
	ELSE
		INSERT INTO monthly_trends_trad
		SELECT * FROM temp_monthly_trends_trad;
	END IF;

	INSERT INTO monthly_trends_trad_archive
	SELECT m.* FROM monthly_trends_trad m
	WHERE NOT EXISTS (
		SELECT 1
		FROM monthly_trends_trad_archive a
		WHERE a.IssueType = m.IssueType
		AND a.EndDate = m.EndDate)
	AND DATE_FORMAT(m.EndDate,'%Y-%m') = DATE_FORMAT(@old_month,'%Y-%m');

	DELETE FROM monthly_trends_trad 
	WHERE DATE_FORMAT(EndDate,'%Y-%m') = DATE_FORMAT(@old_month,'%Y-%m');
		
#	SELECT * FROM jiraanalysis.monthly_trends_trad;
END$$

DELIMITER ;