/*
Navicat MySQL Data Transfer

Source Server         : mysql
Source Server Version : 50711
Source Host           : localhost:3306
Source Database       : dezhou

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2018-07-05 11:39:08
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for tb_database_version
-- ----------------------------
DROP TABLE IF EXISTS `tb_database_version`;
CREATE TABLE `tb_database_version` (
  `version` INT(11) NOT NULL,
  `update_date` datetime NOT NULL,
  `last_sql` VARCHAR(255) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_account
-- ----------------------------
DROP TABLE IF EXISTS `tb_account`;
CREATE TABLE `tb_account` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `uid` bigint(20) DEFAULT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`username`),
  UNIQUE KEY `uid` (`uid`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_nameid
-- ----------------------------
DROP TABLE IF EXISTS `tb_nameid`;
CREATE TABLE `tb_nameid` (
  `nameid` varchar(255) NOT NULL,
  `uid` bigint(20) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`nameid`),
  UNIQUE KEY `uid_UNIQUE` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_openid
-- ----------------------------
DROP TABLE IF EXISTS `tb_openid`;
CREATE TABLE `tb_openid` (
  `openid` varchar(255) NOT NULL,
  `uid` bigint(20) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`openid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Table structure for tb_user
-- ----------------------------
DROP TABLE IF EXISTS `tb_user`;
CREATE TABLE `tb_user` (
  `uid` bigint(20) NOT NULL,
  `sex` int(11) NOT NULL,
  `nickname` varchar(255) NOT NULL,
  `province` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `country` varchar(255) NOT NULL,
  `headimg` longtext NOT NULL,
  `openid` varchar(255) NOT NULL,
  `nameid` varchar(255) NOT NULL,
  `login_at` int(11) NOT NULL,
  `new_user` int(11) NOT NULL,
  `level` int(11) NOT NULL,
  `create_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `update_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Procedure structure for sp_account_select
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_account_select`;
DELIMITER ;;
CREATE PROCEDURE `sp_account_select`(IN `in_username` varchar(64),IN `in_password` varchar(64))
BEGIN
	SELECT * FROM tb_account WHERE username=in_username AND `password`=in_password;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_account_insert_or_update
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_account_insert_or_update`;
DELIMITER ;;
CREATE PROCEDURE `sp_account_insert_or_update`(IN `in_username` varchar(64),IN `in_password` varchar(64), IN `in_uid` bigint(20))
BEGIN
  INSERT INTO tb_account(username, password, uid)
	VALUES (in_username, in_password, in_uid)
	ON DUPLICATE KEY UPDATE password=in_password, uid=in_uid;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_offuser_room_update_created
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_offuser_room_update_created`;
DELIMITER ;;
CREATE PROCEDURE `sp_offuser_room_update_created`(IN `in_uid` bigint,IN `in_created` int,IN `in_joined` int,IN `in_update_at` int,IN `in_mode` int)
BEGIN
	UPDATE tb_user_room 
	SET created=in_created,
			joined=in_joined,
			update_at=in_update_at,
			`mode`=in_mode
	WHERE uid=in_uid;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_user_select
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_user_select`;
DELIMITER ;;
CREATE PROCEDURE `sp_user_select`(IN `in_uid` bigint)
BEGIN
	SELECT * FROM tb_user WHERE uid=in_uid;
END
;;
DELIMITER ;
