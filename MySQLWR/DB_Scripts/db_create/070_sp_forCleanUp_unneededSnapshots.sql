DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `spDeleteSnapshotData`(asnapId int)
begin
    DELETE FROM wrglobal_status WHERE snapId = asnapId;
    DELETE FROM wraccounts WHERE snapId = asnapId;
    DELETE FROM wrevents_statements_summary_by_digest WHERE snapId = asnapId;
    DELETE FROM wrevents_waits_summary_global_by_event_name WHERE snapId = asnapId;
    DELETE FROM wrsnapshot WHERE snapId = asnapId;
    COMMIT;        
end$$
DELIMITER ;
-- call spDeleteSnapshotData(498)


-- wipe all
select CONCAT("call spDeleteSnapshotData(",a.snapId,");")
  from wrsnapshot a
 where (comments = 'AMWAY' or comments is null or comments='' or hostName ='MYAWS')   
 order by a.snapId Desc;

commit;