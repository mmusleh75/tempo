CALL `jiraanalysis`.`sp_update_to_status`();

SELECT DISTINCT IFNULL(fix_version,'NA') fix_version, jira_number
FROM jiraanalysis.to_qa
WHERE jira_number IN (20180)
;

SELECT DISTINCT IFNULL(fix_version,'NA') fix_version, jira_number
FROM jiraanalysis.qa_fail
;

SELECT DISTINCT IFNULL(fix_version,'NA') fix_version, jira_number
FROM jiraanalysis.to_pm
;

SELECT DISTINCT IFNULL(fix_version,'NA') fix_version, jira_number
FROM jiraanalysis.pm_fail
;


-- 13930 , 13458 , 14491
SELECT DISTINCT issue_type, jira_number, fix_version
FROM jiraanalysis.pm_fail
WHERE fix_version IN ('5.0.09.00','5.0.09.01','5.0.10.00')
;

WHERE jira_number = 12608



SELECT DISTINCT issue_type, jira_number
FROM jiraanalysis.to_qa
WHERE fix_version LIKE '5.0.09.00'
AND jira_number IN (14117,20153,20154,20177,20179,20273,20409,20496,20907)
;

SELECT * FROM jiraanalysis.to_qa
WHERE fix_version = '5.0.04.01'
;

SELECT * FROM jiraanalysis.to_qa WHERE jira_number = 20687;

-- 215
SELECT *
FROM jiraanalysis.update_to_status
WHERE new_status IN ('QA In Progress')
AND jira_number = 20687
GROUP BY new_status, month_changed
ORDER BY 2
;