
SELECT
    DB_NAME() AS database_name,
    s.name AS schema_name,
    t.name AS table_name,
    i.name AS index_name,
    i.type_desc AS index_type,
    i.fill_factor,
    i.is_disabled,
    i.is_padded
FROM sys.indexes AS i
INNER JOIN sys.tables AS t
    ON i.[object_id] = t.[object_id]
INNER JOIN sys.schemas AS s
    ON t.[schema_id] = s.[schema_id]
WHERE i.type > 0                  -- ignora heaps
  AND i.fill_factor <> 90         -- diferente de 90
  AND s.name NOT IN ('sys', 'INFORMATION_SCHEMA')  -- ignora schemas de sistema
ORDER BY s.name, t.name, i.name;
