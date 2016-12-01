-- empty tables
TRUNCATE TABLE jiraanalysis.team_lookup;


-- load departments from csv
LOAD DATA LOCAL INFILE 'C:/Users/mmusleh/Documents/Pulse Systems/Technical Operations/JIRA/data_load/team_lookup.csv' 
INTO TABLE jiraanalysis.team_lookup
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(fullname, username, job, department, team)
;

SELECT * FROM jiraanalysis.team_lookup;

/*
-- load sprint teams from csv
LOAD DATA LOCAL INFILE 'C:/Users/mmusleh/Documents/Pulse Systems/Technical Operations/JIRA/data_load/sprint_team.csv' 
INTO TABLE jiraanalysis.sprint_team
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(first_name, last_name, username, sprint_team)
;

SELECT * FROM jiraanalysis.sprint_team;
*/