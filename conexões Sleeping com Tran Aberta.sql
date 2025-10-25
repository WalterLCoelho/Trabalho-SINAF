SELECT
    s.session_id,
    s.login_name,
    s.status,
    s.host_name,
    s.program_name,
    s.cpu_time,
    s.memory_usage,
    s.reads,
    s.writes,
    s.open_transaction_count,
    t.transaction_id,
    t.transaction_state,
    t.transaction_type,
    t.transaction_begin_time,
    r.status AS request_status,
    r.command,
    r.start_time AS request_start_time,
    r.blocking_session_id,
    r.wait_type,
    r.wait_time,
    r.last_wait_type,
    qt.text AS sql_text
FROM sys.dm_exec_sessions s
LEFT JOIN sys.dm_tran_session_transactions st ON s.session_id = st.session_id
LEFT JOIN sys.dm_tran_active_transactions t ON st.transaction_id = t.transaction_id
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS qt
WHERE s.is_user_process = 1
  AND s.status = 'sleeping'
  AND s.open_transaction_count = 0
  --AND s.login_name = 'msiga';


  SELECT
    s.session_id,
    s.login_name,
    s.status,
    s.host_name,
    s.program_name,
    s.open_transaction_count,
    t.transaction_id,
    t.transaction_state,
    t.transaction_type,
    t.transaction_begin_time,
    r.command,
    r.start_time AS request_start_time,
    qt.text AS sql_text
FROM sys.dm_exec_sessions s
JOIN sys.dm_tran_session_transactions st ON s.session_id = st.session_id
JOIN sys.dm_tran_active_transactions t ON st.transaction_id = t.transaction_id
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS qt
WHERE s.is_user_process = 1
  AND s.status = 'sleeping'
  AND s.open_transaction_count > 0;