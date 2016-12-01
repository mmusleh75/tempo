="insert into 2016_sprints values ('"&[@Sprint]&"',"&[@Commitment]&","&[@Completed]&",'"&[@[Project KEY]]&"');"

TRUNCATE TABLE 2016_sprints;

INSERT INTO 2016_sprints VALUES ('16-25',0,0,'MPM');
INSERT INTO 2016_sprints VALUES ('16-26',0,0,'MPM');

INSERT INTO 2016_sprints VALUES ('16-25',0,0,'PLS');
INSERT INTO 2016_sprints VALUES ('16-26',0,0,'PLS');

INSERT INTO 2016_sprints VALUES ('16-25',0,0,'VTEN');
INSERT INTO 2016_sprints VALUES ('16-26',0,0,'VTEN');


SELECT * FROM 2016_sprints;