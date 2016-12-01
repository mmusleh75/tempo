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

/*Table structure for table `issuelink` */

DROP TABLE IF EXISTS `issuelink`;

CREATE TABLE `issuelink` (
  `ID` decimal(18,0) NOT NULL,
  `LINKTYPE` decimal(18,0) DEFAULT NULL,
  `SOURCE` decimal(18,0) DEFAULT NULL,
  `DESTINATION` decimal(18,0) DEFAULT NULL,
  `SEQUENCE` decimal(18,0) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

/*Data for the table `issuelink` */

insert  into `issuelink`(`ID`,`LINKTYPE`,`SOURCE`,`DESTINATION`,`SEQUENCE`) values ('30699','10100','78718','78509','1');

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
