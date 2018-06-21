use wr;

DROP TABLE IF EXISTS `tmprepglobal_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmprepglobal_status` (
  `snapIdBeg` int(3) NOT NULL DEFAULT '0',
  `snapIdEnd` int(3) NOT NULL DEFAULT '0',
  `variable_name` varchar(64) NOT NULL DEFAULT '',
  `deltaValue` varchar(1024) DEFAULT NULL,
  `minimumValue` varchar(1024) DEFAULT NULL,
  `maximumValue` varchar(1024) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmprepstatements`
--

DROP TABLE IF EXISTS `tmprepstatements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmprepstatements` (
  `snapIdBeg` int(11) DEFAULT NULL,
  `snapIdEnd` int(11) DEFAULT NULL,
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,
  `DIGEST_TEXT` longtext,
  `COUNT_STAR` bigint(20) unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint(20) unsigned NOT NULL,
  `opertype` varchar(100) DEFAULT NULL,
  `SUM_ROWS_SENT` bigint(20) unsigned DEFAULT NULL,
  `SUM_ROWS_EXAMINED` bigint(20) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `tmprepwaits`
--

DROP TABLE IF EXISTS `tmprepwaits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tmprepwaits` (
  `snapIdBeg` int(11) DEFAULT NULL,
  `snapIdEnd` int(11) DEFAULT NULL,
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint(25) DEFAULT NULL,
  `SUM_TIMEr_WAIT` bigint(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

