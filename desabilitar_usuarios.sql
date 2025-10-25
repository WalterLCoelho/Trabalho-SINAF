-- Desabilita todos os logins, exceto o 'sa'
DECLARE @sql NVARCHAR(MAX) = N'';

SELECT @sql += '
ALTER LOGIN [' + name + '] DISABLE;'
FROM sys.server_principals
WHERE type_desc = 'SQL_LOGIN'
  AND name <> 'sa'
  AND is_disabled = 0;

--EXEC sp_executesql @sql;

print @sql





