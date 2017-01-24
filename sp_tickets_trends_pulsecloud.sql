
DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_tickets_trends_pulsecloud`$$

CREATE PROCEDURE `sp_tickets_trends_pulsecloud`()
BEGIN

	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY);
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_pulsecloud();

	TRUNCATE temp_monthly_trends_pc;
	
	INSERT INTO temp_monthly_trends_pc
	SELECT @prev_month, t.IssueType, SUM(t.cnt)
	FROM (
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_pc
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		GROUP BY `IssueType`
		UNION ALL
		SELECT `IssueType`, COUNT(1) AS cnt
		FROM jiraanalysis.temp_pc
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		GROUP BY `IssueType`
		
		) t
	GROUP BY IssueType;

	IF ((SELECT COUNT(1) FROM monthly_trends_pc WHERE EndDate = @prev_month) > 1) THEN
		UPDATE monthly_trends_pc mt
		INNER JOIN temp_monthly_trends_pc tmp
			ON tmp.IssueType = mt.IssueType
			AND tmp.EndDate = mt.EndDate
		SET mt.IssueCount = tmp.IssueCount;
	ELSE
		INSERT INTO monthly_trends_pc
		SELECT * FROM temp_monthly_trends_pc;
	END IF;

#	SELECT * FROM jiraanalysis.monthly_trends_pc;


END$$

DELIMITER ;
