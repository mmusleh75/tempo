DELIMITER $$

USE `jiraanalysis`$$

DROP PROCEDURE IF EXISTS `sp_swm_int_tickets_trends_nonPLSPC`$$

CREATE PROCEDURE `sp_swm_int_tickets_trends_nonPLSPC`()
BEGIN
	SET @future_month = DATE_ADD(CURDATE(), INTERVAL 1 MONTH);
	SET @future_1st_of_month = CONCAT(YEAR(@future_month),'-', MONTH(@future_month),'-1');	
	SET @prev_month = DATE_FORMAT(DATE_SUB(@future_1st_of_month, INTERVAL 1 DAY), '%Y-%m');
	SET @current_month = DATE_FORMAT(CURDATE(), '%Y-%m');	
	SET @old_month = DATE_FORMAT(DATE_SUB(CURDATE(), INTERVAL 13 MONTH), '%Y-%m');	
	
#	select @prev_month,@future_1st_of_month, @future_month;

	CALL sp_tickets_all_products_processor();
	
	TRUNCATE temp_swm_int_monthly_trends_nonPLSPC;
	
	DELETE FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
	WHERE Product IN ('Pulse Pro EHR','PulseCloud');
	
	INSERT INTO temp_swm_int_monthly_trends_nonPLSPC
	SELECT 'Incoming', Product, IssueType, DATE_FORMAT(tt.CreateDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_nonPLSPC_products tt
	WHERE tt.CreateDate >= '2016-01-01'
	AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
	GROUP BY Product, IssueType, DATE_FORMAT(tt.CreateDate, '%Y-%m');

	INSERT INTO temp_swm_int_monthly_trends_nonPLSPC
	SELECT 'Closed', Product, IssueType, DATE_FORMAT(ResolvedDate, '%Y-%m') AS MY, COUNT(1) AS cnt
	FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
	WHERE ResolvedDate >= '2016-01-01'		
	AND `Status` = 'Closed'
	AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
#	and ResolvedDate is not null
	GROUP BY Product, IssueType, DATE_FORMAT(ResolvedDate, '%Y-%m');

	
	INSERT INTO temp_swm_int_monthly_trends_nonPLSPC
	SELECT Backlog, Product, IssueType, @prev_month, SUM(t.cnt)
	FROM (
		SELECT 'Backlog' AS Backlog, Product, IssueType, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
		WHERE STATUS != 'Closed'
		AND CreateDate < @future_1st_of_month
		AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
		GROUP BY `Backlog`, Product, IssueType
		UNION ALL
		SELECT 'Backlog' AS Backlog, Product, IssueType, COUNT(1) AS cnt
		FROM jiraanalysis.temp_tickets_all_nonPLSPC_products
		WHERE ResolvedDate >= @future_1st_of_month
		AND CreateDate < @future_1st_of_month
		AND IssueType IN ('SWM: Software Maintenance', 'BUG: Internal Defect')
		GROUP BY `Backlog`, Product, IssueType
		) t
	GROUP BY Backlog, Product, IssueType;		
	
	INSERT INTO swm_int_monthly_trends_nonPLSPC
	SELECT *
	FROM temp_swm_int_monthly_trends_nonPLSPC tmp
	WHERE NOT EXISTS (
		SELECT 1
		FROM swm_int_monthly_trends_nonPLSPC tt
		WHERE tt.Group = tmp.Group
		AND tt.Product = tmp.Product
		AND tt.IssueType = tmp.IssueType
		AND tt.MY = tmp.MY);

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Medrium'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Medrium','BUG: Internal Defect', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'NHA'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','NHA','BUG: Internal Defect', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Pulse Mobile','BUG: Internal Defect', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Pulse Patient Portal','BUG: Internal Defect', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Incoming' 
		AND Product = 'Secure Connect'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Incoming','Secure Connect','BUG: Internal Defect', @current_month,0;
	END IF;	


	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Medrium'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Medrium','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'NHA'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','NHA','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Pulse Mobile','SWM: Software Maintenance', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Pulse Patient Portal','SWM: Software Maintenance', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Secure Connect'
		AND IssueType = 'SWM: Software Maintenance'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Secure Connect','SWM: Software Maintenance', @current_month,0;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Medrium'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Medrium','BUG: Internal Defect', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'NHA'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','NHA','BUG: Internal Defect', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Pulse Mobile'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Pulse Mobile','BUG: Internal Defect', @current_month,0 ;
	END IF;	

	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Pulse Patient Portal'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Pulse Patient Portal','BUG: Internal Defect', @current_month,0 ;
	END IF;		
	IF (SELECT COUNT(1) FROM swm_int_monthly_trends_nonPLSPC 
		WHERE `Group` = 'Closed' 
		AND Product = 'Secure Connect'
		AND IssueType = 'BUG: Internal Defect'
		AND MY = @current_month) = 0 THEN
		INSERT INTO swm_int_monthly_trends_nonPLSPC
		SELECT 'Closed','Secure Connect','BUG: Internal Defect', @current_month,0;
	END IF;	

		
	UPDATE swm_int_monthly_trends_nonPLSPC tt
	INNER JOIN temp_swm_int_monthly_trends_nonPLSPC tmp
		ON tmp.Group = tt.Group
		AND tmp.Product = tt.Product
		AND tmp.IssueType = tt.IssueType		
		AND tmp.MY = tt.MY
	SET tt.IssueCount = tmp.IssueCount;

/*	
	DELETE FROM swm_int_monthly_trends_nonPLSPC
	WHERE MY = @old_month;
*/
		
#	SELECT * FROM jiraanalysis.swm_int_monthly_trends_nonPLSPC;	
	
END$$

DELIMITER ;