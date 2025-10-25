DECLARE @KILLSPIDPREZA NVARCHAR(30);

DECLARE KILL_PROC_PREZA CURSOR FOR
SELECT 'KILL ' + CAST(session_id AS NVARCHAR)
FROM sys.dm_exec_sessions
WHERE is_user_process = 1
  AND status = 'sleeping'
  AND open_transaction_count = 0
  --AND login_name = 'user_report                                                                                                                     ';

OPEN KILL_PROC_PREZA;
FETCH NEXT FROM KILL_PROC_PREZA INTO @KILLSPIDPREZA;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC(@KILLSPIDPREZA);
    FETCH NEXT FROM KILL_PROC_PREZA INTO @KILLSPIDPREZA;
END

CLOSE KILL_PROC_PREZA;
DEALLOCATE KILL_PROC_PREZA;