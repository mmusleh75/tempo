SELECT u.user_name, CONCAT(u.first_name,' ', u.last_name) AS full_name, u.email_address 
FROM `cwd_user` u
INNER JOIN cwd_membership g
	ON g.child_id = u.id
WHERE g.parent_name = 'jira-users'
;

SELECT * FROM `cwd_membership` WHERE child_id = 10045
;

SELECT * FROM `cwd_user_attributes` WHERE attribute_name = 'login.count';

SELECT g.parent_name AS jira_group, u.user_name, CONCAT(u.first_name,' ', u.last_name) AS full_name, u.active, u.lower_email_address, l.attribute_value AS ucount, FROM_UNIXTIME(ROUND(l2.attribute_value/1000)) AS ulast
FROM cwd_user u
INNER JOIN cwd_user_attributes l
	ON u.ID = l.user_id 
	AND l.directory_id = u.directory_id 
	AND l.attribute_name = "login.count"
INNER JOIN cwd_user_attributes l2
	ON u.ID = l2.user_id 
	AND l2.directory_id = u.directory_id 
	AND l2.attribute_name = "login.lastLoginMillis"
LEFT JOIN cwd_membership g
	ON g.child_id = u.id
WHERE g.parent_name = 'jira-users'
#u.directory_id=2
ORDER BY l.attribute_value*1;