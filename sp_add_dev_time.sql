USE test;

DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_add_dev_time`$$

CREATE PROCEDURE `sp_add_dev_time`()
BEGIN

	DECLARE _id DECIMAL(18,0);
	DECLARE _new_fld_id DECIMAL(18,0);
	DECLARE _latest_sent DATETIME;
	DECLARE _sqlstmt VARCHAR(1000);
	
	DECLARE _records CURSOR FOR		
	SELECT DISTINCT ji.id
	,MAX(cg.created) AS latest_sent
	FROM jiradb.`jiraissue` ji
	INNER JOIN jiradb.`changegroup` cg
		ON cg.issueid = ji.id
	INNER JOIN jiradb.`changeitem` ci
		ON ci.groupid = cg.id
#	WHERE ci.newstring IN ('Pending Client Confirmation')
#	WHERE ci.newstring IN ('Functional Acceptance')
	WHERE ci.newstring IN ('QA Queue')
	AND cg.created >='2015-01-01'
	AND NOT EXISTS (
		SELECT 1
		FROM jiradb.customfieldvalue v
		WHERE v.issue = ji.id
		AND v.customfield = 10506)
	GROUP BY ji.id	
	ORDER BY 2;
	
	OPEN _records;
	
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH _records INTO _id, _latest_sent;
			
			SELECT MAX(id)+1 INTO _new_fld_id FROM jiradb.customfieldvalue;
						
			SET @sql_str = CONCAT('INSERT INTO jiradb.customfieldvalue (id, issue, customfield, datevalue) VALUES (',_new_fld_id,', ',_id,', 10506, \'',_latest_sent,'\');');
			
#			PREPARE sql_stmt FROM @sql_str;
#			EXECUTE sql_stmt;
#			DEALLOCATE PREPARE sql_stmt;

#			select @sql_str;
		END LOOP;
	END;
	CLOSE _records;
	
END$$

DELIMITER ;


