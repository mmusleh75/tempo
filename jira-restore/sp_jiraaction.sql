DROP PROCEDURE IF EXISTS sp_jiraaction;

DELIMITER $$
 
CREATE PROCEDURE sp_jiraaction ()
BEGIN

DECLARE _id DECIMAL(18,0);
DECLARE _max_id DECIMAL(18,0);
DECLARE v_finished INTEGER DEFAULT 0;

UPDATE restored.jiraaction
SET new_id = NULL;
 
-- declare cursor for employee email
DECLARE jiraaction_cursor CURSOR FOR 
SELECT id FROM restored.jiraaction WHERE issueid = 78509;
 
-- declare NOT FOUND handler
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_finished = 1;

OPEN jiraaction_cursor;

get_id: LOOP
 FETCH jiraaction_cursor INTO _id;
 IF v_finished = 1 THEN 
	LEAVE get_id;
 END IF;
 
 IF (SELECT COUNT(1) FROM jiradb.jiraaction WHERE id = _id) != 0 THEN
	
	SELECT MAX(id)+1 INTO _max_id FROM jiradb.jiraaction;
	
	IF (SELECT COUNT(1) FROM restored.jiraaction WHERE new_id = _max_id) != 0 THEN
		SET _max_id = _max_id + 1;
	END IF;

	 UPDATE restored.jiraaction
	 SET new_id = _max_id
	 WHERE id = _id;
	 
	 SELECT CONCAT('dup: new max : ', _max_id);
 	
 END IF;
 


END LOOP get_id;

END$$
 
DELIMITER ;