/** 学生表随机生成1000w数据**/
/** 创建表tolove **/
CREATE TABLE test.`tolove` (
  `ID` INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `GIRE_NAME` VARCHAR(64) COLLATE utf8_bin DEFAULT NULL,
  `GIRL_AGE` VARCHAR(64) COLLATE utf8_bin DEFAULT NULL,
  `CUP_SIZE` VARCHAR(10) COLLATE utf8_bin DEFAULT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8 COLLATE=utf8_bin

/** 创建函数 生成学号 **/
DELIMITER $
CREATE FUNCTION rand_number() RETURNS INT
BEGIN
	DECLARE i INT DEFAULT 0;
	SET i= FLOOR(1+RAND()*100);
	RETURN i;
END $
DELIMITER $

/** 创建函数 生成姓名随机字符串 **/
DELIMITER $
CREATE FUNCTION rand_name(n INT) RETURNS VARCHAR(255)
BEGIN
	DECLARE chars_str VARCHAR(100) DEFAULT 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
	DECLARE return_str VARCHAR(255) DEFAULT '';
	DECLARE i INT DEFAULT 0;
	WHILE i < n DO
	SET return_str = CONCAT(return_str,SUBSTRING(chars_str,FLOOR(1+RAND()*52),1));
	SET i = i+1;
	END WHILE;
	RETURN return_str;	
END $
DELIMITER $

/** 创建存储过程 **/
DELIMITER $
CREATE PROCEDURE insert_tolove(IN max_num INT(10))
BEGIN
	DECLARE i INT DEFAULT 0;
	DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
	START TRANSACTION;
	WHILE i< max_num DO
	INSERT INTO test.`tolove`(ID,GIRL_NAME,GIRL_AGE,CUP_SIZE) VALUES(NULL,rand_name(5),rand_number(),NULL);
	SET i = i + 1;
	END WHILE;
COMMIT;
END $
DELIMITER $

SET GLOBAL event_scheduler=1;
COMMIT;

SELECT * FROM mysql.`event`;


/** 调用 **/
CALL insert_tolove(1000*10000);
SELECT COUNT(*) FROM test.`tolove` t WHERE t.girl_age='16';

SHOW FUNCTION STATUS;
UPDATE mysql.`proc` SET  Security_type='INVOKER';

/** 验证是否输错 **/
INSERT INTO test.`tolove`(ID,GIRL_NAME,GIRL_AGE,CUP_SIZE) VALUES(NULL,'1','1','A');



/** 通过DM数据库迁移工具迁移的数据 **/
/** student 100w**/
SELECT COUNT(*) FROM test.`student`;
UPDATE test.`student` s SET s.`stu_age`='18' WHERE s.`stu_name` LIKE 'A%';
UPDATE test.`student` s SET s.`stu_sex`='女';

SELECT COUNT(*) FROM test.student t WHERE t.`stu_name` LIKE 'A%'

/** test 1000w **/
SELECT COUNT(*) FROM test.`test`;