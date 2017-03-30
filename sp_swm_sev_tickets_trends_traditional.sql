
DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_swm_sev_tickets_trends_traditional`$$

CREATE PROCEDURE `sp_swm_sev_tickets_trends_traditional`()
BEGIN

	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	SET @current_month = DATE_FORMAT(CURDATE(), '%Y-%m');
	SET @old_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m');		
	
#	select @future_month, @future_1st_of_month, @prev_month, @current_month;

	CALL sp_tickets_all_products_processor();

	TRUNCATE temp_swm_sev_monthly_trends_trad;
/*	
	INSERT INTO temp_swm_sev_monthly_trends_trad
	SELECT tt.Severity, DATE_FORMAT(tt.CreateDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor tt
	WHERE tt.Product NOT IN ('NHA','Secure Connect')
	AND tt.CreateDate >= '2017-01-01'
	AND tt.status != 'Closed'
	GROUP BY tt.Severity, DATE_FORMAT(tt.CreateDate, '%Y-%m');
*/
/*
	INSERT INTO temp_swm_sev_monthly_trends_trad
	SELECT 'Closed', DATE_FORMAT(ResolvedDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_products_processor
	WHERE Product NOT IN ('NHA','Secure Connect')
	AND ResolvedDate >= '2016-01-01'		
	AND `Status` = 'Closed'
#	and ResolvedDate is not null
	GROUP BY DATE_FORMAT(ResolvedDate, '%Y-%m');
*/
	
	INSERT INTO temp_swm_sev_monthly_trends_trad
	SELECT Severity,@prev_month, SUM(t.cnt)
	FROM (
		SELECT Severity, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		AND pkey = 'PLS'
		AND IssueType = 'SWM: Software Maintenance'
		GROUP BY Severity
		UNION ALL
		SELECT Severity, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_products_processor
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		AND pkey = 'PLS'
		AND IssueType = 'SWM: Software Maintenance'		
		GROUP BY Severity
		
		) t
	GROUP BY Severity;		

	IF (SELECT COUNT(1) FROM temp_swm_sev_monthly_trends_trad WHERE `Severity` = 'S1: Showstopper' AND MY = @current_month) = 0 THEN
		INSERT INTO temp_swm_sev_monthly_trends_trad
		SELECT 'S1: Showstopper',@current_month,0;
	END IF;

	IF (SELECT COUNT(1) FROM temp_swm_sev_monthly_trends_trad WHERE `Severity` = 'S2: Critical' AND MY = @current_month) = 0 THEN
		INSERT INTO temp_swm_sev_monthly_trends_trad
		SELECT 'S2: Critical',@current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM temp_swm_sev_monthly_trends_trad WHERE `Severity` = 'S3: Important' AND MY = @current_month) = 0 THEN
		INSERT INTO temp_swm_sev_monthly_trends_trad
		SELECT 'S3: Important',@current_month,0;
	END IF;	
	
	IF (SELECT COUNT(1) FROM temp_swm_sev_monthly_trends_trad WHERE `Severity` = 'S4: Minor' AND MY = @current_month) = 0 THEN
		INSERT INTO temp_swm_sev_monthly_trends_trad
		SELECT 'S4: Minor',@current_month,0;
	END IF;	
		
	INSERT INTO swm_sev_monthly_trends_trad
	SELECT *
	FROM temp_swm_sev_monthly_trends_trad tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_sev_monthly_trends_trad tt
		WHERE tt.Severity = tmp.Severity
		AND tt.MY = tmp.MY);

	IF (SELECT COUNT(1) FROM swm_sev_monthly_trends_trad WHERE `Severity` = 'S1: Showstopper' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_sev_monthly_trends_trad
		SELECT 'S1: Showstopper',@current_month,0;
	END IF;

	IF (SELECT COUNT(1) FROM swm_sev_monthly_trends_trad WHERE `Severity` = 'S2: Critical' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_sev_monthly_trends_trad
		SELECT 'S2: Critical',@current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_sev_monthly_trends_trad WHERE `Severity` = 'S3: Important' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_sev_monthly_trends_trad
		SELECT 'S3: Important',@current_month,0;
	END IF;	
	
	IF (SELECT COUNT(1) FROM swm_sev_monthly_trends_trad WHERE `Severity` = 'S4: Minor' AND MY = @current_month) = 0 THEN
		INSERT INTO swm_sev_monthly_trends_trad
		SELECT 'S4: Minor',@current_month,0;
	END IF;	
		
	UPDATE swm_sev_monthly_trends_trad tt
	INNER JOIN temp_swm_sev_monthly_trends_trad tmp
		ON tmp.Severity = tt.Severity
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;

	INSERT INTO swm_sev_monthly_trends_trad_archive
	SELECT m.* FROM swm_sev_monthly_trends_trad m
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_sev_monthly_trends_trad_archive a
		WHERE a.Severity = m.Severity
		AND a.MY = m.MY)
	AND m.MY = @old_month;	

	DELETE FROM swm_sev_monthly_trends_trad 
	WHERE MY = @old_month;	
		
#	SELECT * FROM jiraanalysis.swm_sev_monthly_trends_trad;	
#	select * from swm_sev_monthly_trends_trad_archive


END$$

DELIMITER ;
