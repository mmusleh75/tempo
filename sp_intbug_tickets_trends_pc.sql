DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_intbug_tickets_trends_pc`$$

CREATE PROCEDURE `sp_intbug_tickets_trends_pc`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	SET @current_month = DATE_FORMAT(CURDATE(), '%Y-%m');	
	
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_all_products_processor();

	TRUNCATE temp_intbug_monthly_trends_pc;

#	select pkey, IssueType, count(1) from temp_tickets_all_products_processor group by pkey, IssueType;
	
	INSERT INTO temp_intbug_monthly_trends_pc
	SELECT 'Incoming', DATE_FORMAT(tt.CreateDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor tt
	WHERE tt.CreateDate >= '2017-01-01'
	AND pkey = 'VTEN'
	AND Product = 'PulseCloud'
	AND IssueType = 'BUG: Internal Defect'
	GROUP BY DATE_FORMAT(tt.CreateDate, '%Y-%m');

	INSERT INTO temp_intbug_monthly_trends_pc
	SELECT 'Closed', DATE_FORMAT(ResolvedDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor
	WHERE ResolvedDate >= '2017-01-01'		
	AND `Status` = 'Closed'
	AND pkey = 'VTEN'
	AND Product = 'PulseCloud'
	AND IssueType = 'BUG: Internal Defect'
#	and ResolvedDate is not null
	GROUP BY DATE_FORMAT(ResolvedDate, '%Y-%m');

	
	INSERT INTO temp_intbug_monthly_trends_pc
	SELECT Backlog,@prev_month, SUM(t.cnt)
	FROM (
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		AND pkey = 'VTEN'
		AND Product = 'PulseCloud'
		AND IssueType = 'BUG: Internal Defect'	
		GROUP BY `Backlog`
		UNION ALL
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		AND pkey = 'VTEN'
		AND Product = 'PulseCloud'
		AND IssueType = 'BUG: Internal Defect'			
		GROUP BY `Backlog`
		
		) t
	GROUP BY Backlog;		
	
	INSERT INTO intbug_monthly_trends_pc
	SELECT *
	FROM temp_intbug_monthly_trends_pc tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM intbug_monthly_trends_pc tt
		WHERE tt.Group = tmp.Group
		AND tt.MY = tmp.MY);

	IF (SELECT COUNT(1) FROM intbug_monthly_trends_pc WHERE `Group` = 'Incoming' AND MY = @current_month) = 0 THEN
		INSERT INTO intbug_monthly_trends_pc
		SELECT 'Incoming',@current_month,0;
	END IF;

	IF (SELECT COUNT(1) FROM intbug_monthly_trends_pc WHERE `Group` = 'Closed' AND MY = @current_month) = 0 THEN
		INSERT INTO intbug_monthly_trends_pc
		SELECT 'Closed',@current_month,0;
	END IF;	
		
	UPDATE intbug_monthly_trends_pc tt
	INNER JOIN temp_intbug_monthly_trends_pc tmp
		ON tmp.Group = tt.Group
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;
	
#	SELECT * FROM jiraanalysis.intbug_monthly_trends_pc;	
	
END$$

DELIMITER ;