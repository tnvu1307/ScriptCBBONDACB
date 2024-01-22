SET DEFINE OFF;
CREATE OR REPLACE PACKAGE cspks_esb AS
    PROCEDURE sp_set_message_queue (f_content IN VARCHAR, f_queue IN VARCHAR);                  --Th? t?c dua message v?o queue
    FUNCTION fn_get_message_queue (f_queue IN VARCHAR) RETURN varchar;                          --??c message trong queue
END CSPKS_ESB;
/


CREATE OR REPLACE PACKAGE BODY cspks_esb AS
      -- Private variable declarations
      pkgctx plog.log_ctx;
      logrow tlogdebug%rowtype;
    PROCEDURE sp_set_message_queue(f_content IN VARCHAR, f_queue IN VARCHAR) AS
        r_enqueue_options    DBMS_AQ.ENQUEUE_OPTIONS_T;
        r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
        v_message_handle     RAW(16);
        o_payload            SYS.AQ$_JMS_TEXT_MESSAGE;
    BEGIN
        o_payload := SYS.AQ$_JMS_TEXT_MESSAGE.CONSTRUCT;
        o_payload.SET_TEXT(f_content);

        DBMS_AQ.ENQUEUE(
                queue_name         => f_queue,
                enqueue_options    => r_enqueue_options,
                message_properties => r_message_properties,
                payload            => o_payload,
                msgid              => v_message_handle
            );
        COMMIT;
    END sp_set_message_queue;

    FUNCTION fn_get_message_queue(f_queue IN VARCHAR) RETURN varchar AS
        r_dequeue_options    DBMS_AQ.DEQUEUE_OPTIONS_T;
        r_message_properties DBMS_AQ.MESSAGE_PROPERTIES_T;
        v_message_handle     RAW(16);
        o_payload            SYS.AQ$_JMS_TEXT_MESSAGE;
        v_alert_msg          clob;
    BEGIN
        r_dequeue_options.dequeue_mode := DBMS_AQ.BROWSE;
        DBMS_AQ.DEQUEUE(
            queue_name         => f_queue,
            dequeue_options    => r_dequeue_options,
            message_properties => r_message_properties,
            payload            => o_payload,
            msgid              => v_message_handle
         );
        o_payload.GET_TEXT(v_alert_msg);

        return v_alert_msg;
    EXCEPTION
        WHEN OTHERS THEN
            return '';
    end fn_get_message_queue;

begin
  -- Initialization
  for i in (select * from tlogdebug)
  loop
    logrow.loglevel  := i.loglevel;
    logrow.log4table := i.log4table;
    logrow.log4alert := i.log4alert;
    logrow.log4trace := i.log4trace;
  end loop;

  pkgctx := plog.init('CSPKS_ESB',
                      plevel     => nvl(logrow.loglevel, 30),
                      plogtable  => (nvl(logrow.log4table, 'N') = 'Y'),
                      palert     => (nvl(logrow.log4alert, 'N') = 'Y'),
                      ptrace     => (nvl(logrow.log4trace, 'N') = 'Y'));
END CSPKS_ESB;
/
