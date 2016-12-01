/*
SQLyog Community v12.09 (64 bit)
MySQL - 5.1.73 : Database - restored
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`restored` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_bin */;

USE `restored`;

/*Table structure for table `changegroup` */

DROP TABLE IF EXISTS `changegroup`;

CREATE TABLE `changegroup` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `changegroup` */

insert  into `changegroup`(`ID`,`issueid`,`AUTHOR`,`CREATED`) values ('57799','45373','tfeiock','2015-04-13 09:37:09'),('102594','45373','mmusleh','2015-08-06 11:51:01'),('307292','66042','ID11000','2015-10-14 22:39:42'),('317293','66042','abrowne','2015-08-10 11:11:25'),('317363','66042','rkim','2015-08-10 17:48:08'),('317364','66042','rkim','2015-08-10 17:48:54'),('317413','66042','jenkinsjirabot','2015-08-11 16:27:50'),('317425','66042','jenkinsjirabot','2015-08-12 09:29:40'),('317472','66042','abrowne','2015-08-12 15:14:51'),('317487','66042','abrowne','2015-08-12 17:16:04'),('317488','66042','abrowne','2015-08-12 17:16:17'),('317630','66042','rkim','2015-08-18 10:45:51'),('317676','66042','rkim','2015-08-18 16:54:19'),('317726','66042','jenkinsjirabot','2015-08-19 19:13:59'),('317739','66042','jenkinsjirabot','2015-08-19 23:45:54'),('317761','66042','abrowne','2015-08-20 10:21:03'),('317809','66042','abrowne','2015-08-20 14:35:47'),('483549','66042','lliu','2015-11-10 14:58:06'),('528622','66042','lliu','2015-12-24 14:24:16'),('325801','72070','ID11000','2015-10-14 22:53:49'),('388319','72070','dglandfield','2014-11-03 16:23:09'),('395424','72070','dglandfield','2014-11-14 15:33:02'),('398197','72070','jarsenault','2014-12-08 11:54:25'),('493147','72070','lliu','2015-11-10 23:48:01'),('429956','76507','ID11000','2015-10-14 23:29:11'),('443324','76507','ooliinyk','2015-09-11 05:26:03'),('443327','76507','ooliinyk','2015-09-11 05:26:20'),('443330','76507','ooliinyk','2015-09-11 05:26:45'),('443331','76507','ooliinyk','2015-09-11 05:26:51'),('443332','76507','ooliinyk','2015-09-11 05:27:01'),('454640','76507','vchivikova','2015-09-28 09:00:19'),('489780','76507','lliu','2015-11-10 21:04:23'),('478625','78509','rthieszen','2015-11-06 08:51:21'),('478811','78509','rthieszen','2015-11-06 10:08:43'),('478815','78509','rthieszen','2015-11-06 10:11:01'),('478820','78509','rthieszen','2015-11-06 10:13:07'),('479110','78509','rthieszen','2015-11-06 14:23:56'),('479843','78509','rthieszen','2015-11-10 07:23:56'),('494934','78509','jisaac','2015-11-12 16:56:27'),('507026','78509','mmusleh','2015-12-08 09:41:03'),('516119','78509','jisaac','2015-12-17 10:12:31');

/*Table structure for table `changeitem` */

DROP TABLE IF EXISTS `changeitem`;

CREATE TABLE `changeitem` (
  `ID` decimal(18,0) NOT NULL,
  `groupid` decimal(18,0) DEFAULT NULL,
  `FIELDTYPE` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `FIELD` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `OLDVALUE` longtext COLLATE utf8_bin,
  `OLDSTRING` longtext COLLATE utf8_bin,
  `NEWVALUE` longtext COLLATE utf8_bin,
  `NEWSTRING` longtext COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `changeitem` */

insert  into `changeitem`(`ID`,`groupid`,`FIELDTYPE`,`FIELD`,`OLDVALUE`,`OLDSTRING`,`NEWVALUE`,`NEWSTRING`) values ('70191','57799','jira','status','10102','Waiting for support','10101','Resolved'),('70192','57799','jira','resolution',NULL,NULL,'1','Fixed'),('70193','57799','custom','Resolution Notes',NULL,NULL,NULL,'Rolled driver back to previous version and the wireless adapter is now working. '),('135043','102594','jira','Project','10200','IT Service Desk','10500','Technical Operations'),('135044','102594','jira','Key',NULL,'DESK-435',NULL,'TECHOPS-1318'),('135045','102594','jira','Workflow','63988','JIRA Service Desk IT Support Workflow generated for Project DESK','76227','TechOps: Workflow for Incidents'),('135046','102594','jira','issuetype','10200','IT Help','10401','Incident'),('135047','102594','jira','assignee','tfeiock','Feiock, Travis [X]',NULL,NULL),('201692','307292','jira','ProjectImport','','','1444880370536','Wed Oct 14 22:39:30 CDT 2015'),('217398','317293','jira','Link',NULL,NULL,'VTEN-1241','This issue relates to VTEN-1241'),('217511','317363','jira','status','1','New','10017','In Progress'),('217512','317364','jira','status','10017','In Progress','10603','In Review'),('217513','317364','custom','Root Cause',NULL,NULL,NULL,'- also fixed an issue that user hint popup is showing over patient search result panel when patient search'),('217514','317364','custom','GitHub Pull Request URL',NULL,NULL,NULL,'https://github.com/Medrium/Nexia/pull/12869'),('217515','317364','jira','resolution',NULL,NULL,'10103','Fixed'),('217582','317413','jira','status','10603','In Review','10601','Awaiting Deployment'),('217597','317425','jira','status','10601','Awaiting Deployment','10606','Test'),('217664','317472','jira','assignee','rkim','Ryan Kim','abrowne','Andrew Browne'),('217685','317487','jira','resolution','10103','Fixed','10300','Not Fixed'),('217686','317487','jira','status','10606','Test','4','Reopened'),('217687','317487','jira','assignee','abrowne','Andrew Browne','rkim','Ryan Kim'),('217688','317488','jira','Fix Version',NULL,NULL,'13800','10.0.7'),('217689','317488','jira','Fix Version','13700','10.0.6',NULL,NULL),('217885','317630','jira','status','4','Reopened','10017','In Progress'),('217966','317676','jira','status','10017','In Progress','10603','In Review'),('217967','317676','custom','Root Cause',NULL,'- also fixed an issue that user hint popup is showing over patient search result panel when patient search',NULL,'- fix this issue where it occurs in claim view'),('217968','317676','custom','GitHub Pull Request URL',NULL,'https://github.com/Medrium/Nexia/pull/12869',NULL,'https://github.com/Medrium/Nexia/pull/12906'),('217969','317676','jira','resolution','10300','Not Fixed','10103','Fixed'),('218053','317726','jira','status','10603','In Review','10601','Awaiting Deployment'),('218066','317739','jira','status','10601','Awaiting Deployment','10606','Test'),('218095','317761','jira','assignee','rkim','Ryan Kim','abrowne','Andrew Browne'),('218176','317809','jira','status','10606','Test','6','Closed'),('218177','317809','jira','assignee','abrowne','Andrew Browne',NULL,NULL),('484388','483549','jira','priority','10002','High','3','P2-Major'),('540393','528622','jira','Workflow','99554','Nexia Workflow   Defects V2','128341','Pulse Cloud Defects Workflow'),('227269','325801','jira','ProjectImport','','','1444881166926','Wed Oct 14 22:52:46 CDT 2015'),('338391','388319','jira','Project','11000','Bon Echo','11001','V11'),('338392','388319','jira','Key',NULL,'BE-2112',NULL,'VEL-1318'),('338393','388319','jira','Version',NULL,NULL,'11617','Nexia 2.0'),('338394','388319','jira','Version','11403','Nexia 2.0',NULL,NULL),('360094','395424','jira','Fix Version',NULL,NULL,'11631','Bon Echo'),('363930','398197','jira','description',NULL,'Issue 1 :\nSteps to reproduce:\n1. Login in to application.\n2. Go to Clinial settings.\n3. Create two Managed Care Templates (Ex: Mct1 and Mct2)\n4. Search a patient.\n5. Click More tab -> Managed Care.\n6. Add one Mct1 to patient chart.\n7. Click Problem list link.\n\nExpected : If \'Track this condition\' is selected, the system displays “Managed care template” and “Baseline date” fields\n\nActual : The “Managed care template” and “Baseline date” fields are displayed even if \'Track this condition\' is not checked.\n\nRefer Screen shots: Spec1.jpg, UnCheck.jpg\n\nIssue 2 :\nSteps to reproduce:\n8. Follow steps 1 to 7 in previous case.\n9. Check the \'Track this condition\' check box.\n10.Search for the Managed cared template (Ex: Mct)\n\nExpected :The Search result must include only templates not used in the current patient chart as <Template name> (<Created by user first and last names>).\n\nActual : The Search result includes the templates used in the current patient chart also. And only the <Template name> is displayed and not the (<Created by user first and last names>). \n\nRefer Screen shots: Spec1.jpg, NoName.jpg, joint.jpg\n\nIssue 3 :\nSteps to reproduce:\n11. Follow steps 1 to 10 in previous case.\n12. Save the Problem List.\n13. Again click the Problem list link.\n14. Click Edit option for the created Problem list.\n\nExpected :The user must not able to un-select “Track this condition” check box. The system automatically un-selects it if the user deletes the Managed care flowsheet.\n\nActual : But the “Track this condition” check box is editable.\n\nRefer Screen shots: Spec1.jpg',NULL,'Steps to reproduce:\n1. Login in to application.\n2. Go to Clinial settings.\n3. Create two Managed Care Templates (Ex: Mct1 and Mct2)\n4. Search a patient.\n5. Click More tab -> Managed Care.\n6. Add one Mct1 to patient chart.\n7. Click Problem list link.\n8. Follow steps 1 to 7 in previous case.\n9. Check the \'Track this condition\' check box.\n10.Search for the Managed cared template (Ex: Mct)\n\nExpected :The Search result must include only templates not used in the current patient chart as <Template name> (<Created by user first and last names>).\n\nActual : The Search result includes the templates used in the current patient chart also. And only the <Template name> is displayed and not the (<Created by user first and last names>). \n\nRefer Screen shots: Spec1.jpg, NoName.jpg, joint.jpg\n\nSteps to reproduce:\n11. Follow steps 1 to 10 in previous case.\n12. Save the Problem List.\n13. Again click the Problem list link.\n14. Click Edit option for the created Problem list.\n\nExpected :The user must not able to un-select “Track this condition” check box. The system automatically un-selects it if the user deletes the Managed care flowsheet.\n\nActual : But the “Track this condition” check box is editable.\n\nRefer Screen shots: Spec1.jpg'),('363931','398197','jira','Fix Version',NULL,NULL,'11632','Chutes'),('363932','398197','jira','Fix Version','11631','Bon Echo',NULL,NULL),('363933','398197','jira','priority','3','High','4','Medium'),('363934','398197','jira','assignee','jwang','Jason Wang',NULL,NULL),('494070','493147','jira','priority','10004','Medium','4','P3-Minor'),('411829','429956','jira','ProjectImport','','','1444883339212','Wed Oct 14 23:28:59 CDT 2015'),('432214','443324','jira','Link',NULL,NULL,'VEL-3231','This issue clones VEL-3231'),('432217','443327','jira','project','11001','V11','11800','Miratech'),('432218','443327','jira','Key',NULL,'VEL-9747',NULL,'MIR-1318'),('432219','443327','jira','Workflow','31482','Nexia Workflow - Defects v2','31483','Miratech Defects v4'),('432220','443327','jira','Version',NULL,NULL,'13902','10.2 Beta (2015-08-27)'),('432221','443327','jira','Version','11617','Nexia 2.0',NULL,NULL),('432222','443327','jira','Fix Version','11632','Chutes',NULL,NULL),('432223','443327','custom','Target Release Version','10301','2.0 (ONMD)',NULL,''),('432226','443330','jira','status','1','New','10605','Need Clarification'),('432227','443330','jira','assignee','kbartholomae','Kim Bartholomae','ooliinyk','Olena Oliinyk'),('432228','443331','jira','assignee','ooliinyk','Olena Oliinyk',NULL,NULL),('432229','443332','jira','labels',NULL,'',NULL,'cloneFromVEL outOfScopeAOHC'),('447175','454640','jira','status','10605','Need Clarification','10608','OUT OF SCOPE'),('490680','489780','jira','priority','10002','High','3','P2-Major'),('478791','478625','jira','Workflow','112130','TechOps: Workflow for Triage','114526','TechOps: Workflow for Triage 2'),('479016','478811','jira','status','1','New','10102','Waiting for support'),('479021','478815','jira','Workflow','114526','TechOps: Workflow for Triage 2','114548','JIRA Service Desk IT Support Workflow generated for Project TECHOPS'),('479022','478815','jira','Parent',NULL,NULL,'78718','TECHOPS-3458'),('479023','478815','jira','issuetype','10200','IT Help','5','Dev Task'),('479031','478820','jira','assignee',NULL,NULL,'rthieszen','Thieszen, Rob'),('479433','479110','jira','issuetype','5','Dev Task','10704','TechOps Task'),('480534','479843','jira','assignee','rthieszen','Thieszen, Rob','jisaac','Isaac, James'),('496214','494934','jira','status','10102','Waiting for support','10103','Waiting for customer'),('514467','507026','jira','project','10500','Technical Operations','10729','Cloud Operations'),('514468','507026','jira','Key',NULL,'TECHOPS-3366',NULL,'CO-1318'),('514469','507026','jira','issuetype','10704','TechOps Sub-Task','10702','Sub-task'),('526690','516119','jira','status','10103','Waiting for customer','10101','Resolved'),('526691','516119','jira','resolution',NULL,NULL,'1','Completed');

/*Table structure for table `fileattachment` */

DROP TABLE IF EXISTS `fileattachment`;

CREATE TABLE `fileattachment` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `MIMETYPE` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `FILENAME` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `FILESIZE` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `zip` decimal(9,0) DEFAULT NULL,
  `thumbnailable` decimal(9,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `fileattachment` */

insert  into `fileattachment`(`ID`,`issueid`,`MIMETYPE`,`FILENAME`,`CREATED`,`FILESIZE`,`AUTHOR`,`zip`,`thumbnailable`) values ('30478','66042','image/jpeg','dont_show_again.jpg','2015-08-10 11:10:33','228344','abrowne',NULL,'1'),('36702','72070','image/jpeg','UnCheck.jpg','2014-10-31 07:51:47','139979','nbala',NULL,NULL),('36704','72070','image/jpeg','Spec1.jpg','2014-10-31 07:51:47','359896','nbala',NULL,NULL),('36705','72070','image/jpeg','Joint.jpg','2014-10-31 07:51:47','247288','nbala',NULL,NULL),('36706','72070','image/jpeg','NoName.jpg','2014-10-31 07:51:47','71483','nbala',NULL,NULL);

/*Table structure for table `jiraaction` */

DROP TABLE IF EXISTS `jiraaction`;

CREATE TABLE `jiraaction` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `actiontype` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `actionlevel` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `rolelevel` decimal(18,0) DEFAULT NULL,
  `actionbody` longtext COLLATE utf8_bin,
  `CREATED` datetime DEFAULT NULL,
  `UPDATEAUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `actionnum` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `jiraaction` */

insert  into `jiraaction`(`ID`,`issueid`,`AUTHOR`,`actiontype`,`actionlevel`,`rolelevel`,`actionbody`,`CREATED`,`UPDATEAUTHOR`,`UPDATED`,`actionnum`) values ('170425','66042','jenkinsjirabot','comment',NULL,NULL,'This ticket has been reviewed by vitorbertazoli and is waiting for the next build.\n\nTo view the pull request, see https://github.com/Medrium/Nexia/pull/12872','2015-08-11 16:27:49','jenkinsjirabot','2015-08-11 16:27:49',NULL),('170433','66042','jenkinsjirabot','comment',NULL,NULL,'This build was deployed to an environment via DEPLOY Nexia QA1 (10.0.6)','2015-08-12 09:29:39','jenkinsjirabot','2015-08-12 09:29:39',NULL),('170449','66042','abrowne','comment',NULL,NULL,'As per Ryan\'s comments- still not working.\nMoving to 10.0.7 - since we are about to enter STG.','2015-08-12 17:16:04','abrowne','2015-08-12 17:16:04',NULL),('170487','66042','rkim','comment',NULL,NULL,'reopend it after finding this issue in viewing claim in billing history page even though it works fine in new charge entry page','2015-08-18 10:47:26','rkim','2015-08-18 10:47:26',NULL),('170505','66042','jenkinsjirabot','comment',NULL,NULL,'This ticket has been reviewed by vitorbertazoli and is waiting for the next build.\n\nTo view the pull request, see https://github.com/Medrium/Nexia/pull/12906','2015-08-19 19:13:57','jenkinsjirabot','2015-08-19 19:13:57',NULL),('170515','66042','jenkinsjirabot','comment',NULL,NULL,'This build was deployed to an environment via DEPLOY Nexia QA1 (10.0.7)','2015-08-19 23:45:53','jenkinsjirabot','2015-08-19 23:45:53',NULL),('170528','66042','abrowne','comment',NULL,NULL,'Tested and passed in QA 1.\nPop-up is no moving and remaining in static position.','2015-08-20 14:35:47','abrowne','2015-08-20 14:35:47',NULL),('192374','78509','jisaac','comment',NULL,NULL,'Server build in progress. Glenn will install Pulse software 11/13.','2015-11-12 16:56:27','jisaac','2015-11-12 16:56:27',NULL),('192482','78509','jisaac','comment',NULL,NULL,'Server OS build complete. Need AD user list, VPN, web services setup.','2015-11-16 09:24:07','jisaac','2015-11-16 09:24:07',NULL),('192598','78509','jisaac','comment',NULL,NULL,'Per John Hall:\n\nList of Users for 1rst Health Application Server and SQL Server Management Studio\n\nLinda Moore\nDoug Rocheleau\nNicole Johnson\nJay Bhakta\nAvis Bishop\nDevin June\nJohn Hall\nJeri Yanez\n\nCandace Streeter\n\nPam Swyden\nLinian Liu\nDon Hamilton\n\nMillie Vega\nJennifer Barnhill\nDebbie Thome\n\nBob Atkins\nGlenn Williams\n','2015-11-17 09:51:09','jisaac','2015-11-17 09:51:09',NULL);

/*Table structure for table `jiraissue` */

DROP TABLE IF EXISTS `jiraissue`;

CREATE TABLE `jiraissue` (
  `ID` decimal(18,0) NOT NULL,
  `pkey` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuenum` decimal(18,0) DEFAULT NULL,
  `PROJECT` decimal(18,0) DEFAULT NULL,
  `REPORTER` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `ASSIGNEE` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuetype` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `SUMMARY` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION` longtext COLLATE utf8_bin,
  `ENVIRONMENT` longtext COLLATE utf8_bin,
  `PRIORITY` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `RESOLUTION` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `issuestatus` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `CREATED` datetime DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `DUEDATE` datetime DEFAULT NULL,
  `RESOLUTIONDATE` datetime DEFAULT NULL,
  `VOTES` decimal(18,0) DEFAULT NULL,
  `WATCHES` decimal(18,0) DEFAULT NULL,
  `TIMEORIGINALESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMEESTIMATE` decimal(18,0) DEFAULT NULL,
  `TIMESPENT` decimal(18,0) DEFAULT NULL,
  `WORKFLOW_ID` decimal(18,0) DEFAULT NULL,
  `SECURITY` decimal(18,0) DEFAULT NULL,
  `FIXFOR` decimal(18,0) DEFAULT NULL,
  `COMPONENT` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `jiraissue` */

insert  into `jiraissue`(`ID`,`pkey`,`issuenum`,`PROJECT`,`REPORTER`,`ASSIGNEE`,`CREATOR`,`issuetype`,`SUMMARY`,`DESCRIPTION`,`ENVIRONMENT`,`PRIORITY`,`RESOLUTION`,`issuestatus`,`CREATED`,`UPDATED`,`DUEDATE`,`RESOLUTIONDATE`,`VOTES`,`WATCHES`,`TIMEORIGINALESTIMATE`,`TIMEESTIMATE`,`TIMESPENT`,`WORKFLOW_ID`,`SECURITY`,`FIXFOR`,`COMPONENT`) values ('78509',NULL,'1318','10729','jyanez','jisaac','jyanez','10702','ASP Migration - 1rst Health - Server Build','1rst Health is ready to begin their migration to our hosting environment. Please prepare the server environment. ',NULL,'5','1','10101','2015-11-02 15:42:25','2015-12-17 10:12:31',NULL,'2015-12-17 10:12:31','0','1',NULL,NULL,NULL,'114548',NULL,NULL,NULL);

/*Table structure for table `project` */

DROP TABLE IF EXISTS `project`;

CREATE TABLE `project` (
  `ID` decimal(18,0) NOT NULL,
  `pname` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `URL` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `LEAD` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `DESCRIPTION` text COLLATE utf8_bin,
  `pkey` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `pcounter` decimal(18,0) DEFAULT NULL,
  `ASSIGNEETYPE` decimal(18,0) DEFAULT NULL,
  `AVATAR` decimal(18,0) DEFAULT NULL,
  `ORIGINALKEY` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `PROJECTTYPE` varchar(255) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `project` */

insert  into `project`(`ID`,`pname`,`URL`,`LEAD`,`DESCRIPTION`,`pkey`,`pcounter`,`ASSIGNEETYPE`,`AVATAR`,`ORIGINALKEY`,`PROJECTTYPE`) values ('10000','Test Project','','admin','','TP','35170','3','11111','TP','software'),('10101','Pulse Systems Project','','mmorrison','It is the Pulse primary project. ','PLS','26196','3','10511','PRO','software'),('10400','Test','','mmorrison','','TEST','6','2','11103','TEST','software'),('10500','Technical Operations',NULL,'rthieszen','Generated by JIRA Service Desk','TECHOPS','4332','3','10011','TECHOPS','service_desk'),('10501','DataFlow','','tpremo','','DFL','20','3','10207','DFL','software'),('10602','Neo','','sjakubowski','','NEO','60','3','11103','NEO','software'),('10701','PulseCloud','','jsnook','PulseCloud','VTEN','2528','3','11277','VTEN','software'),('10702','V11','','kbartholomae','','VEL','9876','3','11103','VEL','software'),('10703','Epic Backlog','','jarsenault','Placeholder for Epics that are created to be worked on based on backlog of work','BAC','2106','3','11103','BAC','software'),('10704','Miratech','','sshakov','Miratech project for AOHC client scope','MIR','2322','3','11103','MIR','software'),('10705','Agile Training','','rpayette','','AGILETRG','1','3','11103','AGILETRG','software'),('10706','Change Management','','dbiasutti','','CM','0','3','11103','CM','software'),('10707','VTEN - 10.0.10',NULL,'tpremo',NULL,'V10010','2','3','11103','V10010','software'),('10708','Data Services | Migration Toolset','','alee','Data Services toolkit development, specifically to migrate:\n\n- patient chart records\n- bulk load for configurations such as schedules, providers, users, etc\n- reconciliation reports','DSMT','45','3','11103','DSMT','software'),('10709','HC1','','amourtada','','TC','121','3','11103','TC','software'),('10710','HC2','','amourtada','MU Features','HC','21','3','11103','HC','software'),('10711','HC3','','amourtada','','CHET','0','3','11103','CHET','software'),('10713','NIC10Admin','','rpayette','','NIC10','0','3','11103','NIC10','software'),('10714','NOD V9','','dglandfield','','NODROFC','67','3','11103','NODROFC','software'),('10715','Nova Scotia DIS | V10','','alee','','NSDIS','164','3','11103','NSDIS','software'),('10717','Production Support','','sewen','NetSuite to JIRA','PRODSUPP','35','3','11103','PRODSUPP','software'),('10719','SecureConnect','','lfetterhoff','','SC','2','3','11103','SC','software'),('10720','Test Project (For debugging/operations)','','sjakubowski','','TST','12','3','11103','TST','software'),('10722','Release IT','','rakeshmoddi','','IT','191','3','11103','IT','software'),('10723','Internal','','dwooldridge','','IN','12','3','11104','IN','business'),('10724','Mobile, Portal, Medrium','','tpremo','This is the source for all associated Pulse Mobile and Patient Portal:  tickets, epics, and backlog.','MPM','815','3','11228','PM','software'),('10725','Training',NULL,'jwarkentine',NULL,'TRAIN','0','3','11103','TRAIN','software'),('10729','Cloud Operations','','mmusleh','','CO','1677','3','10200','CLDOPS','service_desk'),('10730','Information System','','dwooldridge','','IS','5','3','11109','IS','business'),('10731','Product Management Office','','tpremo','','PMO','7','3','11103','PMO','business');

/*Table structure for table `worklog` */

DROP TABLE IF EXISTS `worklog`;

CREATE TABLE `worklog` (
  `ID` decimal(18,0) NOT NULL,
  `issueid` decimal(18,0) DEFAULT NULL,
  `AUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `grouplevel` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `rolelevel` decimal(18,0) DEFAULT NULL,
  `worklogbody` longtext COLLATE utf8_bin,
  `CREATED` datetime DEFAULT NULL,
  `UPDATEAUTHOR` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `UPDATED` datetime DEFAULT NULL,
  `STARTDATE` datetime DEFAULT NULL,
  `timeworked` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `worklog` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
