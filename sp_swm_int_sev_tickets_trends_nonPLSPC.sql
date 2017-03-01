DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_swm_int_sev_tickets_trends_nonPLSPC`$$

CREATE PROCEDURE `sp_swm_int_sev_tickets_trends_nonPLSPC`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	SET @current_month = DATE_FORMAT(CURDATE(), '%Y-%m');	
	SET @old_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m');	
	
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_all_products_processor();
	
	TRUNCATE temp_swm_int_sev_monthly_trends_nonPLSPC;
	
	DELETE FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
	WHERE Product IN ('Pulse Pro EHR','PulseCloud');

	INSERT INTO temp_swm_int_sev_monthly_trends_nonPLSPC
	SELECT Severity, Product, IssueType, @prev_month, SUM(t.cnt)
	FROM (
		SELECT Severity, Product, IssueType, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
		GROUP BY Severity, Product, IssueType
		UNION ALL
		SELECT Severity, Product, IssueType, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
		GROUP BY Severity, Product, IssueType
		) t
	GROUP BY Severity, Product, IssueType;		
	
	INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
	SELECT *
	FROM temp_swm_int_sev_monthly_trends_nonPLSPC tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_int_sev_monthly_trends_nonPLSPC tt
		WHERE tt.Severity = tmp.Severity
		AND tt.Product = tmp.Product
		AND tt.IssueType = tmp.IssueType
		AND tt.MY = tmp.MY);

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S1: Showstopper' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S1: Showstopper','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S1: Showstopper' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S1: Showstopper','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S1: Showstopper' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S1: Showstopper','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S1: Showstopper' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S1: Showstopper','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S1: Showstopper' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S1: Showstopper','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S2: Critical' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S2: Critical','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S2: Critical' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S2: Critical','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S2: Critical' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S2: Critical','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S2: Critical' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S2: Critical','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S2: Critical' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S2: Critical','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S3: Important' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S3: Important','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S3: Important' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S3: Important','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S3: Important' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S3: Important','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S3: Important' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S3: Important','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S3: Important' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S3: Important','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S4: Minor' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S4: Minor','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S4: Minor' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S4: Minor','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S4: Minor' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S4: Minor','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S4: Minor' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S4: Minor','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_sev_monthly_trends_nonPLSPC 
		WHERE `Severity` = 'S4: Minor' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_sev_monthly_trends_nonPLSPC
		SELECT 'S4: Minor','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	
	UPDATE swm_int_sev_monthly_trends_nonPLSPC tt
	INNER JOIN temp_swm_int_sev_monthly_trends_nonPLSPC tmp
		ON tmp.Severity = tt.Severity
		AND tmp.Product = tt.Product
		AND tmp.IssueType = tt.IssueType		
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;

	INSERT INTO swm_int_sev_monthly_trends_nonPLSPC_archive
	SELECT m.* FROM swm_int_sev_monthly_trends_nonPLSPC m
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_int_sev_monthly_trends_nonPLSPC_archive a
		WHERE a.Severity = m.Severity
		AND a.Product = m.Product
		AND a.IssueType = m.IssueType
		AND a.MY = m.MY)
	AND m.MY = @old_month;

	DELETE FROM swm_int_sev_monthly_trends_nonPLSPC
	WHERE MY = @old_month;

#	SELECT * FROM jiraanalysis.swm_int_sev_monthly_trends_nonPLSPC;	
	
END$$

DELIMITER ;