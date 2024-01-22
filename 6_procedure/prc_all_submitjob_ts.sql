SET DEFINE OFF;
CREATE OR REPLACE PROCEDURE prc_all_submitjob_TS is
 v_job integer;
 v_Count number(20);
 v_jobID integer;

begin
BEGIN
                  DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'TXPKS_AUTO#FO2ODSYNC',
                         force => true);
exception when others then
    null;
END;                  
DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'TXPKS_AUTO#FO2ODSYNC',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'txpks_auto.pr_fo2od',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=3',
                     enabled           => TRUE,
                     comments         => 'Process fo online order',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                 -------------
BEGIN
begin 
dbms_scheduler.create_job (job_name             => 'JBPKS_AUTO#GEN_DF_BUFFER',
                           job_type             => 'STORED_PROCEDURE',
                          job_action           => 'jbpks_auto.pr_gen_df_buffer',
                          start_date           => SYSDATE,
                          repeat_interval      => 'FREQ=SECONDLY;INTERVAL=3',
                          enabled              => TRUE,
                          comments             => 'Gen buf_df job'
                         );
end;
DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'TXPKS_AUTO#FOBANKSYNC',
                         force => true);

exception when others then
    null;
END;                  
                  DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'TXPKS_AUTO#FOBANKSYNC',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'txpks_auto.pr_fobanksyn',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=3',
                     enabled           => TRUE,
                     comments         => 'Process fo order gen hold request for bank account',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                 --------------
BEGIN
DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'TXPKS_AUTO#GTC2OD_HA',
                         force => true);
exception when others then
    null;
END;                  
                 DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'TXPKS_AUTO#GTC2OD_HA',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'begin    TXPKS_AUTO.pr_gtc2od(''GTC-HA''); end;  ',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY; INTERVAL=5',
                     enabled           => TRUE,
                     comments         => 'Process put GTC order from FOMAST to ODMAST',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                 --------------
BEGIN
                 DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'TXPKS_AUTO#GTC2OD_HO',
                         force => true);
exception when others then
    null;
END;                  
                 DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'TXPKS_AUTO#GTC2OD_HO',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'begin   TXPKS_AUTO.pr_gtc2od(''GTC-HO''); end;  ',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY; INTERVAL=5',
                     enabled           => TRUE,
                     comments         => 'Process put GTC order from FOMAST to ODMAST',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                 ----------------
BEGIN
DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'TXPKS_AUTO#ROR2BO',
                         force => true);
exception when others then
    null;
END;                  
                  DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'TXPKS_AUTO#ROR2BO',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'fopks_api.pr_RORSyn2BO',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=10',
                     enabled           => TRUE,
                     comments         => 'Process put Right off register after hold enough money',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                  -----------------
BEGIN                  DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'JBPKS_AUTO#GEN_CI_BUFFER',
                         force => true);
exception when others then
    null;
END;                  
                  DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'JBPKS_AUTO#GEN_CI_BUFFER',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'jbpks_auto.pr_gen_ci_buffer',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=3',
                     enabled           => TRUE,
                     comments         => 'Gen buf_ci_account job',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                   -----------------------------
BEGIN                   DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'JBPKS_AUTO#GEN_OD_BUFFER',
                         force => true);
exception when others then
    null;
END;                  
                   DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'JBPKS_AUTO#GEN_OD_BUFFER',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'jbpks_auto.pr_gen_od_buffer',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=3',
                     enabled           => TRUE,
                     comments         => 'Gen buf_od_account job',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                   -------------------------------
BEGIN                   DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'JBPKS_AUTO#GEN_SE_BUFFER',
                         force => true);
exception when others then
    null;
END;                  
                   DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'JBPKS_AUTO#GEN_SE_BUFFER',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'jbpks_auto.pr_gen_se_buffer',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=3',
                     enabled           => TRUE,
                     comments         => 'Gen buf_se_account job',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                   -------------------------------
BEGIN                   DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'JBPKS_AUTO#SE_GEN_DATA',
                         force => true);
exception when others then
    null;
END;                  
                   DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'JBPKS_AUTO#SE_GEN_DATA',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'jbpks_auto.pr_se_generate_data',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=10',
                     enabled           => TRUE,
                     comments         => 'Job that polls device n2 every 10 seconds',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -------------------------------
BEGIN                   DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'PRC_PROCESS_HA_8_SCHEDULER',
                         force => true);
exception when others then
    null;
END;                  
                   DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PRC_PROCESS_HA_8_SCHEDULER',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN PRC_PROCESS_HA_8(); END;',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'freq=SECONDLY;interval=20',
                     enabled           => TRUE,
                     comments         => 'Job PRC_PROCESS_HA_8.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -----------------------------------
BEGIN                    DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'PRC_PROCESS_HA_SCHEDULER',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PRC_PROCESS_HA_SCHEDULER',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN PRC_PROCESS_HA(); END;',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'freq=SECONDLY;interval=20',
                     enabled           => TRUE,
                     comments         => 'Job PRC_PROCESS_HA.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -------------------------------
BEGIN                    DBMS_SCHEDULER.DROP_JOB (
                           job_name         =>  'PRC_PROCESS_HO_CTCI_SCHEDULER',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PRC_PROCESS_HO_CTCI_SCHEDULER',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN PRC_PROCESS_HO_CTCI(); END;',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'freq=SECONDLY;interval=20',
                     enabled           => TRUE,
                     comments         => 'Job PRC_PROCESS_HO_CTCI.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -------------------------------
BEGIN                     DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'PRC_PROCESS_HO_PRS_SCHEDULER',
                         force => true);
exception when others then
    null;
END;                  
                     DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PRC_PROCESS_HO_PRS_SCHEDULER',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN PRC_PROCESS_HO_PRS(); END;',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'freq=SECONDLY;interval=20',
                     enabled           => TRUE,
                     comments         => 'Job PRC_PROCESS_HO_PRS.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -------------------------------
BEGIN                    DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'PCK_HAGW#PRC_PROCESSMSG_EX',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PCK_HAGW#PRC_PROCESSMSG_EX',
                     job_type           =>  'STORED_PROCEDURE',
                     job_action       =>  'PCK_HAGW.PRC_PROCESSMSG_EX',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'FREQ=SECONDLY;INTERVAL=30',
                     enabled           => TRUE,
                     comments         => 'PCK_HAGW#PRC_PROCESSMSG_EX',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                     
BEGIN                     DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'PRC_AUTO_MATCH_ORDER#',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'PRC_AUTO_MATCH_ORDER#',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN PRC_AUTO_MATCH_ORDER(); END;',
                     start_date       =>  sysdate,
                     repeat_interval  =>  'freq=SECONDLY;interval=60',
                     enabled           => TRUE,
                     comments         => 'Job PRC_AUTO_MATCH_ORDER.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
------------------------------------------------------------------------------------------------
BEGIN                     DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'CHECKEARLYDAY',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'CHECKEARLYDAY',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN NMPKS_EMS.CheckEarlyDay(); END;',
                     start_date       =>  sysdate,
					 --repeat_interval  =>  'freq=SECONDLY;interval=60',
                     repeat_interval  =>  'freq=HOURLY;interval=1',
                     enabled           => TRUE,
                     comments         => 'Job CHECKEARLYDAY.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');

BEGIN                     DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'CHECKSYSTEM',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'CHECKSYSTEM',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN NMPKS_EMS.CheckSystem(); END;',
                     start_date       =>  sysdate,
					 --repeat_interval  =>  'freq=SECONDLY;interval=60',
                     repeat_interval  =>  'freq=HOURLY;interval=1',
                     enabled           => TRUE,
                     comments         => 'Job CHECKSYSTEM.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');

BEGIN                     DBMS_SCHEDULER.DROP_JOB (
                         job_name         =>  'CHECKSODUGD',
                         force => true);
exception when others then
    null;
END;                  
                    DBMS_SCHEDULER.CREATE_JOB (
                     job_name         =>  'CHECKSODUGD',
                     job_type           =>  'PLSQL_BLOCK',
                     job_action       =>  'BEGIN NMPKS_EMS.CheckSoDuGD(); END;',
                     start_date       =>  sysdate,
                     --repeat_interval  =>  'freq=SECONDLY;interval=60',
					 repeat_interval  =>  'freq=HOURLY;interval=1',
                     enabled           => TRUE,
                     comments         => 'Job CHECKSODUGD.',
                     job_class =>'FSS_DEFAULT_JOB_CLASS');
                    -------------------------------
 /*
  ----HOSE-------------------------------------------------------------------------------------------------------------
  Select count(*) into v_Count from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HO_PRS%';

  If v_Count=0 then

          dbms_job.submit(v_job,
                          what => 'PRC_PROCESS_HO_PRS;',
                          next_date => sysdate,
                          interval => 'SYSDATE + 1/86400');
           commit;
  else

            Select job into v_jobID  from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HO_PRS%';

             dbms_job.remove(v_jobID);

            commit;

            dbms_job.submit(v_job,
                              what => 'PRC_PROCESS_HO_PRS;',
                              next_date => sysdate,
                              interval => 'SYSDATE + 1/86400');
            commit;

  End if;

    ----HOSE-------------------------------------------------------------------------------------------------------------
  Select count(*) into v_Count from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HO_CTCI%';

  If v_Count=0 then

          dbms_job.submit(v_job,
                          what => 'PRC_PROCESS_HO_CTCI;',
                          next_date => sysdate,
                          interval => 'SYSDATE + 1/86400');
           commit;
  else

            Select job into v_jobID  from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HO_CTCI%';

             dbms_job.remove(v_jobID);

            commit;

            dbms_job.submit(v_job,
                              what => 'PRC_PROCESS_HO_CTCI;',
                              next_date => sysdate,
                              interval => 'SYSDATE + 1/86400');
            commit;

  End if;

    ----HNX-------------------------------------------------------------------------------------------------------------

  Select count(*) into v_Count from user_jobs where Upper(WHAT) = 'PRC_PROCESS_HA;';

  If v_Count=0 then

          dbms_job.submit(v_job,
                          what => 'PRC_PROCESS_HA;',
                          next_date => sysdate,
                          interval => 'SYSDATE + 1/86400');
           commit;
  else

            Select job into v_jobID  from user_jobs where Upper(WHAT) = 'PRC_PROCESS_HA;';

             dbms_job.remove(v_jobID);

            commit;

            dbms_job.submit(v_job,
                              what => 'PRC_PROCESS_HA;',
                              next_date => sysdate,
                              interval => 'SYSDATE + 1/86400');
            commit;

  End if;

    ----HNX-------------------------------------------------------------------------------------------------------------

   Select count(*) into v_Count from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HA_8%';

  If v_Count=0 then

          dbms_job.submit(v_job,
                          what => 'PRC_PROCESS_HA_8;',
                          next_date => sysdate,
                          interval => 'SYSDATE + 1/86400');
           commit;
  else

            Select job into v_jobID  from user_jobs where Upper(WHAT) like '%PRC_PROCESS_HA_8%';

             dbms_job.remove(v_jobID);

            commit;

            dbms_job.submit(v_job,
                              what => 'PRC_PROCESS_HA_8;',
                              next_date => sysdate,
                              interval => 'SYSDATE + 1/86400');
            commit;

  End if;

    ----HNX-------------------------------------------------------------------------------------------------------------

   Select count(*) into v_Count from user_jobs where Upper(WHAT) like '%PCK_HAGW.PRC_PROCESSMSG_EX%';

  If v_Count=0 then

          dbms_job.submit(v_job,
                          what => 'PCK_HAGW.PRC_PROCESSMSG_EX;',
                          next_date => sysdate,
                          interval => 'SYSDATE + 1/86400');
           commit;
  else

            Select job into v_jobID  from user_jobs where Upper(WHAT) like '%PCK_HAGW.PRC_PROCESSMSG_EX%';

             dbms_job.remove(v_jobID);

            commit;

            dbms_job.submit(v_job,
                              what => 'PCK_HAGW.PRC_PROCESSMSG_EX;',
                              next_date => sysdate,
                              interval => 'SYSDATE + 10/86400');
            commit;

  End if;
  */
 -----------------------------------------------------------------------------------------------------------------
end;
 
 
/
