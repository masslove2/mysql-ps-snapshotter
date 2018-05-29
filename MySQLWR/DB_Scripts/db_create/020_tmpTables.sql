CREATE TABLE `tmpRepStatements` (
   snapIdBeg int , 
   snapIdEnd int , 
  `SCHEMA_NAME` varchar(64) DEFAULT NULL,  
  `DIGEST_TEXT` longtext,
  `COUNT_STAR` bigint(20) unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint(20) unsigned NOT NULL,
  `SUM_LOCK_TIME` bigint(20) unsigned NOT NULL
);

CREATE TABLE `tmpRepWaits` (
   snapIdBeg int , 
   snapIdEnd int , 
  `EVENT_NAME` varchar(128) NOT NULL,
  `COUNT_STAR` bigint(20) unsigned NOT NULL,
  `SUM_TIMER_WAIT` bigint(20) unsigned NOT NULL
);