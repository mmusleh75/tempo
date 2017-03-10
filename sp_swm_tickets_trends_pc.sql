DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_swm_tickets_trends_pc`$$

CREATE PROCEDURE `sp_swm_tickets_trends_pc`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	SET @current_month = DATE_FORMAT(CURDATE(), '%Y-%m');
	SET @old_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m');	
		
#	select @current_month;
	
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_all_products_processor();

	TRUNCATE temp_swm_monthly_trends_pc;
	
	INSERT INTO temp_swm_monthly_trends_pc
	SELECT 'Incoming', DATE_FORMAT(tt.CreateDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor tt
	#WHERE tt.CreateDate >= '2016-01-01'
	WHERE tt.CreateDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 13 MONTH) AND CURDATE()	
	AND pkey = 'VTEN'
	AND Product = 'PulseCloud'	
	AND IssueType = 'SWM: Software Maintenance'	
	GROUP BY DATE_FORMAT(tt.CreateDate, '%Y-%m');

	INSERT INTO temp_swm_monthly_trends_pc
	SELECT 'Closed', DATE_FORMAT(ResolvedDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor
	#WHERE ResolvedDate >= '2016-01-01'	
	WHERE ResolvedDate BETWEEN DATE_SUB(CURDATE(), INTERVAL 13 MONTH) AND CURDATE()
	AND `Status` = 'Closed'
	AND pkey = 'VTEN'
	AND Product = 'PulseCloud'
	AND IssueType = 'SWM: Software Maintenance'		
#	and ResolvedDate is not null
	GROUP BY DATE_FORMAT(ResolvedDate, '%Y-%m');

	
	INSERT INTO temp_swm_monthly_trends_pc
	SELECT Backlog,@prev_month, SUM(t.cnt)
	FROM (
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		AND pkey = 'VTEN'
		AND Product = 'PulseCloud'
		AND IssueType = 'SWM: Software Maintenance'			
		GROUP BY `Backlog`
		UNION ALL
		SELECT 'Backlog' AS Backlog, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		AND pkey = 'VTEN'
		AND Product = 'PulseCloud'		
		AND IssueType = 'SWM: Software Maintenance'					
		GROUP BY `Backlog`
		
		) t
	GROUP BY Backlog;		
	
	INSERT INTO swm_monthly_trends_pc
	SELECT *
	FROM temp_swm_monthly_trends_pc tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_monthly_trends_pc tt
		WHERE tt.Group = tmp.Group
		AND tt.MY = tmp.MY);
	
	IF (SELECT COUNT(1) FROM swm_monthly_trends_pc WHERE `Group` = 'Incoming' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_monthly_trends_pc
		SELECT 'Incoming',@current_month,0;
	END IF;

	IF (SELECT COUNT(1) FROM swm_monthly_trends_pc WHERE `Group` = 'Closed' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_monthly_trends_pc
		SELECT 'Closed',@current_month,0;
	END IF;	
	
	
	UPDATE swm_monthly_trends_pc tt
	INNER JOIN temp_swm_monthly_trends_pc tmp
		ON tmp.Group = tt.Group
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;

	INSERT INTO swm_monthly_trends_pc_archive
	SELECT m.* FROM swm_monthly_trends_pc m
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_monthly_trends_pc_archive a
		WHERE a.Group = m.Group
		AND a.MY = m.MY)
	AND m.MY = @old_month;	

	DELETE FROM swm_monthly_trends_pc 
	WHERE MY = @old_month;	
		
#	SELECT * FROM jiraanalysis.swm_monthly_trends_pc order by `Group`, MY;	
#	select * from swm_monthly_trends_pc_archive  order by `Group`, MY;	
	
END$$

DELIMITER ;