DROP PROCEDURE IF EXISTS `sp_update_sql`;

DELIMITER ;;
CREATE PROCEDURE `sp_update_sql`()
BEGIN

DECLARE lastVersion INT DEFAULT 1;
DECLARE lastVersion1 INT DEFAULT 1;
DECLARE versionNotes VARCHAR(255) DEFAULT '';

SELECT MAX(tb_database_version.version) INTO lastVersion FROM tb_database_version;
SET lastVersion = IFNULL((lastVersion),1);
SET lastVersion1 = lastVersion;

###############################################################
# 表格修改开始

IF lastVersion > lastVersion1 THEN
	INSERT INTO tb_database_version(version, update_date, last_sql) values(lastVersion, now(), versionNotes);
END IF;

END;;
DELIMITER ;

call sp_update_sql();
DROP PROCEDURE IF EXISTS `sp_update_sql`;

###############################################################
# 过程修改开始

-- ----------------------------
-- Procedure structure for sp_account_insert_or_update
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_account_insert_or_update`;
DELIMITER ;;
CREATE PROCEDURE `sp_account_insert_or_update`(IN `in_username` varchar(64),
	IN `in_password` varchar(64), 
	IN `in_uid` bigint(20))
BEGIN
  INSERT INTO tb_account(username, password, uid)
	VALUES (in_username, in_password, in_uid)
	ON DUPLICATE KEY UPDATE password=in_password, uid=in_uid;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_nameid_insert_or_update
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_nameid_insert_or_update`;
DELIMITER ;;
CREATE PROCEDURE `sp_nameid_insert_or_update`(IN `in_nameid` varchar(255),
	IN `in_uid` bigint(20))
BEGIN
  INSERT INTO tb_nameid(nameid, uid)
	VALUES (nameid, in_uid)
	ON DUPLICATE KEY UPDATE uid=in_uid;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_nameid_select
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_nameid_select`;
DELIMITER ;;
CREATE PROCEDURE `sp_nameid_select`(IN `in_nameid` varchar(255))
BEGIN
	SELECT * FROM tb_nameid WHERE nameid=in_nameid;
END
;;
DELIMITER ;

# 过程修改结束
###############################################################
