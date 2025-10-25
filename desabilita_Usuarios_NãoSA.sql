USE master;
GO
-- Desabilita todos os logins, exceto o 'sa'
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER LOGIN [' + name + '] DISABLE;'
FROM sys.server_principals
WHERE type_desc = 'SQL_LOGIN'
  AND name <> 'sa'
  AND name NOT LIKE '##%' -- ignora logins internos do SQL Server
  AND is_disabled = 0;    -- ignora logins já desabilitados

EXEC sp_executesql @sql;