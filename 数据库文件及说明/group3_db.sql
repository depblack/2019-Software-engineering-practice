-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1:3306
-- 生成日期： 2019-10-30 12:59:45
-- 服务器版本： 5.7.26
-- PHP 版本： 7.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `group3_db`
--

DELIMITER $$
--
-- 存储过程
--
DROP PROCEDURE IF EXISTS `get_all_assid`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_assid` (IN `name` VARCHAR(20), IN `cod` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select a_id FROM g3_assignment where user_name=? and course_code=?' ;   
	prepare stmt from @sqlcmd;  
	set @a=name;
    set @b=cod;
	execute stmt using @a,@b; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `get_course_info`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_course_info` (IN `name` VARCHAR(20), IN `cod` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select cm_content,cm_time,cm_describe FROM g3_coumess where user_name=? and course_code=? and cm_type=2' ;   
	prepare stmt from @sqlcmd;  
	set @a=name;
    set @b=cod;
	execute stmt using @a,@b; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `get_nograde_assid`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nograde_assid` (IN `name` VARCHAR(20), IN `cod` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select a_id from g3_assignment where user_name=? and course_code=? and a_grade is null';   
	prepare stmt from @sqlcmd;  
	set @a=name;
    set @b=cod;
	execute stmt using @a,@b; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `get_nosubmit_assid`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_nosubmit_assid` (IN `name` VARCHAR(20), IN `cod` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select a_id from g3_assignment where user_name=? and course_code=? and a_submit=0';   
	prepare stmt from @sqlcmd;  
	set @a=name;
    set @b=cod;
	execute stmt using @a,@b; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `get_score_info`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_score_info` (IN `name` VARCHAR(20), IN `cod` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select cm_content,cm_time,cm_describe FROM g3_coumess where user_name=? and course_code=? and cm_type=1' ;   
	prepare stmt from @sqlcmd;  
	set @a=name;
    set @b=cod;
	execute stmt using @a,@b; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `Insert_daily`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Insert_daily` (IN `user_name` VARCHAR(20), IN `d_date` DATETIME, IN `text` TEXT)  NO SQL
begin
	set @sqlcmd = 'insert into g3_daily values(null,?,?,?)';  
		prepare stmt from @sqlcmd;  
		set @a=user_name;
		set @b=d_date;
		set @c=text;
		execute stmt using @a,@b,@c; 
		deallocate prepare stmt; 
end$$

DROP PROCEDURE IF EXISTS `show_chosen_code`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_chosen_code` (IN `name` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select course_code from g3_chosen where user_name = ?';   
	prepare stmt from @sqlcmd;  
	set @a=name;
	execute stmt using @a; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `show_chosen_coursename`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_chosen_coursename` (IN `name` VARCHAR(20))  NO SQL
begin
	set @sqlcmd = 'select course_name from g3_course, g3_chosen where g3_chosen.user_name = ? and g3_course.course_code = g3_chosen.course_code ';   
	prepare stmt from @sqlcmd;  
	set @a=name;
	execute stmt using @a; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `show_home_course`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_home_course` (IN `coursecode` VARCHAR(30))  NO SQL
begin
	set @sqlcmd = 'select course_name,course_tea,course_weektime,course_place from g3_course where course_code = ?';   
	prepare stmt from @sqlcmd;  
	set @a=coursecode;
	execute stmt using @a; 
	deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `show_table`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `show_table` (IN `table_name` VARCHAR(20))  NO SQL
begin
set @sqlcmd = concat('select * from ', table_name);  
prepare stmt from @sqlcmd;  
execute stmt; 
deallocate prepare stmt;  
end$$

DROP PROCEDURE IF EXISTS `splitString`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `splitString` (IN `f_string` VARCHAR(1000), IN `f_delimiter` VARCHAR(5))  BEGIN
 -- Get the separated string.
 declare cnt int default 0;
 declare i int default 0;
 set cnt = func_get_splitStringTotal(f_string,f_delimiter);
 
 drop table if exists `tmp_split`;
 create temporary table `tmp_split`  (`val_` varchar(128) not null) DEFAULT CHARSET=utf8;
 while i < cnt
 do
  set i = i + 1;
  insert into `tmp_split`(`val_`) values (func_splitString(f_string,f_delimiter,i));
 end while;
 select * from `tmp_split`;
END$$

--
-- 函数
--
DROP FUNCTION IF EXISTS `func_get_splitStringTotal`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `func_get_splitStringTotal` (`f_string` VARCHAR(1000), `f_delimiter` VARCHAR(5)) RETURNS INT(11) NO SQL
BEGIN
 	return 1+(length(f_string)-length(replace(f_string,f_delimiter,'')));
 
END$$

DROP FUNCTION IF EXISTS `func_splitString`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `func_splitString` (`f_string` VARCHAR(1000), `f_delimiter` VARCHAR(5), `f_order` INT(5)) RETURNS VARCHAR(255) CHARSET utf8 NO SQL
BEGIN
 declare result varchar(255) default '';
 set result = reverse(substring_index(reverse(substring_index(f_string,f_delimiter,f_order)),f_delimiter,1));
 return result;
END$$

DROP FUNCTION IF EXISTS `get_pid`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_pid` (`name` VARCHAR(20)) RETURNS INT(11) NO SQL
BEGIN 
	DECLARE c varchar(20) DEFAULT '';
	select user_pid from g3_user where g3_user.user_name=name into c;
    
    IF c<5&&c>0 THEN
    	RETURN c;
    ELSE
    	RETURN -1;
    END IF;
END$$

DROP FUNCTION IF EXISTS `is_number`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_number` (`str` VARCHAR(25)) RETURNS INT(11) BEGIN 
    DECLARE res INT DEFAULT 0; 
    SELECT str REGEXP '^[0-9]+$' INTO res; 
    IF res = 1 THEN 
        RETURN 1;
    ELSE 
        RETURN 0; 
    END IF; 
END$$

DROP FUNCTION IF EXISTS `is_user`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `is_user` (`name` VARCHAR(20), `passw` VARCHAR(20)) RETURNS INT(11) NO SQL
BEGIN 
	DECLARE c varchar(20) DEFAULT '';
	select user_password from g3_user where g3_user.user_name=name into c;
    
    IF c=passw THEN
    	RETURN 1;
    ELSE
    	RETURN 0;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `g3_assignment`
--

DROP TABLE IF EXISTS `g3_assignment`;
CREATE TABLE IF NOT EXISTS `g3_assignment` (
  `a_id` int(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `unit_id` int(20) NOT NULL,
  `a_submit` tinyint(1) NOT NULL,
  `a_ed` datetime NOT NULL,
  `a_scontent` varchar(100) NOT NULL,
  `a_grade` int(5) DEFAULT NULL,
  `a_fullgrade` int(5) NOT NULL,
  PRIMARY KEY (`a_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_assignment`
--

INSERT INTO `g3_assignment` (`a_id`, `user_name`, `course_code`, `unit_id`, `a_submit`, `a_ed`, `a_scontent`, `a_grade`, `a_fullgrade`) VALUES
(1, 'wangsi', '12398', 1, 1, '2019-10-24 00:00:00', './pdf/example.pdf', 19, 29),
(2, 'zhangsan', '11234', 4, 0, '2019-10-24 00:00:00', './pdf/example.pdf', NULL, 30),
(13, 'liqi', '11', 6, 1, '2019-10-24 00:00:00', './pdf/example.pdf', 87, 100);

-- --------------------------------------------------------

--
-- 表的结构 `g3_chosen`
--

DROP TABLE IF EXISTS `g3_chosen`;
CREATE TABLE IF NOT EXISTS `g3_chosen` (
  `chose_code` int(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  PRIMARY KEY (`chose_code`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_chosen`
--

INSERT INTO `g3_chosen` (`chose_code`, `user_name`, `course_code`) VALUES
(1, 'zhangsan', '12398'),
(2, 'zhangsan', '11234'),
(3, 'zhangsan', '11'),
(4, 'wangsi', '11234'),
(5, 'wangsi', '11'),
(6, 'liqi', '12398'),
(7, 'liqi', '11234');

-- --------------------------------------------------------

--
-- 表的结构 `g3_coumess`
--

DROP TABLE IF EXISTS `g3_coumess`;
CREATE TABLE IF NOT EXISTS `g3_coumess` (
  `cm_id` int(20) NOT NULL AUTO_INCREMENT,
  `course_code` varchar(20) NOT NULL,
  `cm_content` varchar(100) NOT NULL,
  `cm_time` datetime NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `cm_describe` text NOT NULL,
  `cm_type` int(5) NOT NULL,
  PRIMARY KEY (`cm_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_coumess`
--

INSERT INTO `g3_coumess` (`cm_id`, `course_code`, `cm_content`, `cm_time`, `user_name`, `cm_describe`, `cm_type`) VALUES
(1, '11234', 'you have got 99 of 100 in CSE-U1', '2019-10-17 00:00:00', 'wangsi', 'Score message', 1),
(2, '11', 'you have got 89 of 100 in CSE-U2', '2019-10-09 00:00:00', 'zhangsan', 'Score message', 1),
(3, '12398', './pdf/example.pdf', '2019-10-02 00:00:00', 'liqi', 'Course message', 2);

-- --------------------------------------------------------

--
-- 表的结构 `g3_course`
--

DROP TABLE IF EXISTS `g3_course`;
CREATE TABLE IF NOT EXISTS `g3_course` (
  `course_id` int(20) NOT NULL AUTO_INCREMENT,
  `course_name` varchar(30) NOT NULL,
  `course_len` tinyint(4) NOT NULL,
  `course_tea` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_pic` varchar(100) NOT NULL,
  `course_file` varchar(100) NOT NULL,
  `course_syllabus` varchar(100) NOT NULL,
  `course_st` date DEFAULT NULL,
  `course_ed` date DEFAULT NULL,
  `course_weektime` text,
  `course_place` varchar(50) NOT NULL,
  PRIMARY KEY (`course_id`),
  UNIQUE KEY `course_code` (`course_code`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_course`
--

INSERT INTO `g3_course` (`course_id`, `course_name`, `course_len`, `course_tea`, `course_code`, `course_pic`, `course_file`, `course_syllabus`, `course_st`, `course_ed`, `course_weektime`, `course_place`) VALUES
(1, 'software_engineering', 64, 'Mr.W', '12398', './img/SE.jpg', './pdf/example.pdf', './pdf/example.md', '2019-10-01', '2019-10-30', 'Thursday, from 12 a.m to 2 p.m；Friday, from 12 a.m to 2 p.m; Sunday, from 12 a.m to 2 p.m', 'place1'),
(2, 'software_engineering_practice', 32, 'Mr.Z', '11234', './img/SEI.jpg', './pdf/example.pdf', './pdf/example.md', '2019-10-01', '2019-10-30', 'Tuesday, from 12 a.m to 2 p.m；Wendensday, from 12 a.m to 2 p.m; Saturday, from 12 a.m to 2 p.m', 'place2'),
(3, 'computer_science_english', 48, 'Mr.Q', '11', './img/CSE.jpg', './pdf/example.pdf', './pdf/example.md', '2019-10-01', '2019-10-30', 'Thursday, from 4 p.m to 7 p.m；Friday, from 4 p.m to 7 p.m; Sunday, from 4 a.m to 7 p.m', 'place3');

-- --------------------------------------------------------

--
-- 表的结构 `g3_daily`
--

DROP TABLE IF EXISTS `g3_daily`;
CREATE TABLE IF NOT EXISTS `g3_daily` (
  `d_id` int(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `d_date` datetime NOT NULL,
  `d_content` text NOT NULL,
  PRIMARY KEY (`d_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_daily`
--

INSERT INTO `g3_daily` (`d_id`, `user_name`, `d_date`, `d_content`) VALUES
(1, 'wangsi', '2019-10-08 00:00:00', 'Go to school in 15 minutes');

-- --------------------------------------------------------

--
-- 表的结构 `g3_disscussion`
--

DROP TABLE IF EXISTS `g3_disscussion`;
CREATE TABLE IF NOT EXISTS `g3_disscussion` (
  `dis_id` int(20) NOT NULL AUTO_INCREMENT,
  `course_code` varchar(20) NOT NULL,
  `unit_id` int(10) NOT NULL,
  `dis_time` date NOT NULL,
  `dis_locktime` date NOT NULL,
  `dis_throwtime` date NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `dis_content` text NOT NULL,
  PRIMARY KEY (`dis_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- 表的结构 `g3_help`
--

DROP TABLE IF EXISTS `g3_help`;
CREATE TABLE IF NOT EXISTS `g3_help` (
  `h_id` int(10) NOT NULL AUTO_INCREMENT,
  `h_title` varchar(20) NOT NULL,
  `h_content` text NOT NULL,
  PRIMARY KEY (`h_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_help`
--

INSERT INTO `g3_help` (`h_id`, `h_title`, `h_content`) VALUES
(1, 'Report a Problem', 'If Canvas misbehaves, tell us about it');

-- --------------------------------------------------------

--
-- 表的结构 `g3_plan`
--

DROP TABLE IF EXISTS `g3_plan`;
CREATE TABLE IF NOT EXISTS `g3_plan` (
  `pl_id` int(10) NOT NULL AUTO_INCREMENT,
  `course_name` varchar(30) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `course_tea` varchar(20) NOT NULL,
  `pl_st` date NOT NULL,
  `pl_ed` date NOT NULL,
  `pl_time` text NOT NULL,
  `course_pic` varchar(100) NOT NULL,
  `course_file` varchar(100) NOT NULL,
  `course_syllabus` varchar(100) NOT NULL,
  PRIMARY KEY (`pl_id`),
  UNIQUE KEY `course_code` (`course_code`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_plan`
--

INSERT INTO `g3_plan` (`pl_id`, `course_name`, `course_code`, `course_tea`, `pl_st`, `pl_ed`, `pl_time`, `course_pic`, `course_file`, `course_syllabus`) VALUES
(1, 'software_engineering', '12398', 'Mr.W', '2019-10-02', '2019-10-08', 'Thursday, from 12 a.m to 2 p.m；Friday, from 12 a.m to 2 p.m; Sunday, from 12 a.m to 2 p.m', './img/SE.jpg', './pdf/example.pdf', './pdf/example.md'),
(2, 'software_engineering_practice', '11234', 'Mr.Z', '2019-10-02', '2019-10-08', 'Thursday, from 12 a.m to 2 p.m；Friday, from 12 a.m to 2 p.m; Sunday, from 12 a.m to 2 p.m', './img/SEI.jpg', './pdf/example.pdf', './pdf/example.md'),
(3, 'computer_science_english', '11', 'Mr.Q', '2019-10-02', '2019-10-08', 'Thursday, from 12 a.m to 2 p.m；Friday, from 12 a.m to 2 p.m; Sunday, from 12 a.m to 2 p.m', './img/CSE.jpg', './pdf/example.pdf', './pdf/example.md');

-- --------------------------------------------------------

--
-- 表的结构 `g3_score`
--

DROP TABLE IF EXISTS `g3_score`;
CREATE TABLE IF NOT EXISTS `g3_score` (
  `sc_id` int(20) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(20) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  `unit_total_grade` tinyint(4) NOT NULL,
  `end_grade` tinyint(5) NOT NULL,
  `syn_grade` int(11) NOT NULL,
  PRIMARY KEY (`sc_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_score`
--

INSERT INTO `g3_score` (`sc_id`, `user_name`, `course_code`, `unit_total_grade`, `end_grade`, `syn_grade`) VALUES
(1, 'qwer', '12398', 99, 98, 98);

-- --------------------------------------------------------

--
-- 表的结构 `g3_term`
--

DROP TABLE IF EXISTS `g3_term`;
CREATE TABLE IF NOT EXISTS `g3_term` (
  `Term_id` int(10) NOT NULL,
  `Term_st` date NOT NULL,
  `Term_ed` date NOT NULL,
  `Term_state` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_term`
--

INSERT INTO `g3_term` (`Term_id`, `Term_st`, `Term_ed`, `Term_state`) VALUES
(1, '2019-10-02', '2019-10-25', 'add_period');

-- --------------------------------------------------------

--
-- 表的结构 `g3_unit`
--

DROP TABLE IF EXISTS `g3_unit`;
CREATE TABLE IF NOT EXISTS `g3_unit` (
  `unit_id` int(20) NOT NULL,
  `unit_name` varchar(20) NOT NULL,
  `unit_info` varchar(100) NOT NULL,
  `course_code` varchar(20) NOT NULL,
  PRIMARY KEY (`unit_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_unit`
--

INSERT INTO `g3_unit` (`unit_id`, `unit_name`, `unit_info`, `course_code`) VALUES
(1, 'U1_1', './pdf/example.pdf', '12398'),
(2, 'U1_2', './pdf/example.pdf', '12398'),
(3, 'U2', './pdf/example.pdf', '12398'),
(4, 'U1', './pdf/example.pdf', '11234'),
(5, 'U2', './pdf/example.pdf', '11234'),
(6, 'U1', './pdf/example.pdf', '11'),
(7, 'U3', './pdf/example.pdf', '11');

-- --------------------------------------------------------

--
-- 表的结构 `g3_user`
--

DROP TABLE IF EXISTS `g3_user`;
CREATE TABLE IF NOT EXISTS `g3_user` (
  `user_id` int(20) NOT NULL,
  `user_name` varchar(20) NOT NULL,
  `user_password` varchar(20) NOT NULL,
  `user_pid` int(5) NOT NULL,
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- 转存表中的数据 `g3_user`
--

INSERT INTO `g3_user` (`user_id`, `user_name`, `user_password`, `user_pid`) VALUES
(1, 'zhangsan', '1234567', 1),
(2, 'wangsi', '123654', 2),
(3, 'liqi', '122333', 1),
(4, 'fengji', '12345123', 3);

-- --------------------------------------------------------

--
-- 表的结构 `tmp_spilt`
--

DROP TABLE IF EXISTS `tmp_spilt`;
CREATE TABLE IF NOT EXISTS `tmp_spilt` (
  `p_id` int(10) NOT NULL,
  `_val` varchar(50) NOT NULL,
  PRIMARY KEY (`p_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
