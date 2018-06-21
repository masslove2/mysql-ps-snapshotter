use wr;

--
-- Table structure for table `wraccounts`
--

DROP TABLE IF EXISTS `wraccounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wraccounts` (
  `snapId` int(11) DEFAULT NULL,
  `USER` char(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `HOST` char(60) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `CURRENT_CONNECTIONS` bigint(20) NOT NULL,
  `TOTAL_CONNECTIONS` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrevents_statements_summary_by_digest`
--

DROP TABLE IF EXISTS `wrevents_statements_summary_by_digest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrevents_statements_summary_by_digest` (
  `snapId` int(11) DEFAULT NULL,
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST` varchar(32) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `COUNT_STAR` bigint(20) unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint(20) unsigned NOT NULL,
  `SUM_ERRORS` bigint(20) unsigned NOT NULL,
  `SUM_WARNINGS` bigint(20) unsigned NOT NULL,
  `SUM_ROWS_AFFECTED` bigint(20) unsigned NOT NULL,
  `SUM_ROWS_SENT` bigint(20) unsigned NOT NULL,
  `SUM_ROWS_EXAMINED` bigint(20) unsigned NOT NULL,
  `SUM_CREATED_TMP_DISK_TABLES` bigint(20) unsigned NOT NULL,
  `SUM_CREATED_TMP_TABLES` bigint(20) unsigned NOT NULL,
  `SUM_SELECT_FULL_JOIN` bigint(20) unsigned NOT NULL,
  `SUM_SELECT_FULL_RANGE_JOIN` bigint(20) unsigned NOT NULL,
  `SUM_SELECT_RANGE` bigint(20) unsigned NOT NULL,
  `SUM_SELECT_RANGE_CHECK` bigint(20) unsigned NOT NULL,
  `SUM_SELECT_SCAN` bigint(20) unsigned NOT NULL,
  `SUM_SORT_MERGE_PASSES` bigint(20) unsigned NOT NULL,
  `SUM_SORT_RANGE` bigint(20) unsigned NOT NULL,
  `SUM_SORT_ROWS` bigint(20) unsigned NOT NULL,
  `SUM_SORT_SCAN` bigint(20) unsigned NOT NULL,
  `SUM_NO_INDEX_USED` bigint(20) unsigned NOT NULL,
  `SUM_NO_GOOD_INDEX_USED` bigint(20) unsigned NOT NULL,
  `FIRST_SEEN` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `LAST_SEEN` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  KEY `idx_stmt_snapId` (`snapId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrevents_waits_summary_global_by_event_name`
--

DROP TABLE IF EXISTS `wrevents_waits_summary_global_by_event_name`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrevents_waits_summary_global_by_event_name` (
  `snapId` int(11) DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint(20) unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `MIN_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `AVG_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `MAX_TIMER_WAIT` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrglobal_status`
--

DROP TABLE IF EXISTS `wrglobal_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrglobal_status` (
  `snapId` int(3) NOT NULL DEFAULT '0',
  `VARIABLE_NAME` varchar(64) NOT NULL DEFAULT '',
  `VARIABLE_VALUE` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrinnodb_metrics`
--

DROP TABLE IF EXISTS `wrinnodb_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrinnodb_metrics` (
  `snapId` int(4) NOT NULL DEFAULT '0',
  `NAME` varchar(193) NOT NULL DEFAULT '',
  `SUBSYSTEM` varchar(193) NOT NULL DEFAULT '',
  `COUNT` bigint(21) NOT NULL DEFAULT '0',
  `MAX_COUNT` bigint(21) DEFAULT NULL,
  `MIN_COUNT` bigint(21) DEFAULT NULL,
  `AVG_COUNT` double DEFAULT NULL,
  `COUNT_RESET` bigint(21) NOT NULL DEFAULT '0',
  `MAX_COUNT_RESET` bigint(21) DEFAULT NULL,
  `MIN_COUNT_RESET` bigint(21) DEFAULT NULL,
  `AVG_COUNT_RESET` double DEFAULT NULL,
  `TIME_ENABLED` datetime DEFAULT NULL,
  `TIME_DISABLED` datetime DEFAULT NULL,
  `TIME_ELAPSED` bigint(21) DEFAULT NULL,
  `TIME_RESET` datetime DEFAULT NULL,
  `STATUS` varchar(193) NOT NULL DEFAULT '',
  `TYPE` varchar(193) NOT NULL DEFAULT '',
  `COMMENT` varchar(193) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrslow_log`
--

DROP TABLE IF EXISTS `wrslow_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrslow_log` (
  `snapId` int(11) DEFAULT NULL,
  `start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_host` mediumtext NOT NULL,
  `query_time` time NOT NULL,
  `lock_time` time NOT NULL,
  `rows_sent` int(11) NOT NULL,
  `rows_examined` int(11) NOT NULL,
  `db` varchar(512) NOT NULL,
  `last_insert_id` int(11) NOT NULL,
  `insert_id` int(11) NOT NULL,
  `server_id` int(10) unsigned NOT NULL,
  `sql_text` mediumtext NOT NULL,
  `thread_id` bigint(21) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrslow_logsnapshot`
--

DROP TABLE IF EXISTS `wrslow_logsnapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrslow_logsnapshot` (
  `snapId` int(11) NOT NULL AUTO_INCREMENT,
  `hostName` varchar(50) DEFAULT NULL,
  `snapTime` datetime DEFAULT NULL,
  `dateBeg` datetime DEFAULT NULL,
  `dateEnd` datetime DEFAULT NULL,
  PRIMARY KEY (`snapId`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `wrsnapshot`
--

DROP TABLE IF EXISTS `wrsnapshot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wrsnapshot` (
  `snapId` int(11) NOT NULL AUTO_INCREMENT,
  `hostName` varchar(1024) DEFAULT NULL,
  `snapTime` datetime DEFAULT NULL,
  `comments` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`snapId`)
) ENGINE=InnoDB AUTO_INCREMENT=810 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

