CREATE TABLE `wrglobal_status` (
  `snapId` int(3) NOT NULL DEFAULT '0',
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;