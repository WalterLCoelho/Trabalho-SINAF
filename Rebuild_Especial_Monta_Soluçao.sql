/* =========================================================
   Geração de comandos de REBUILD de índices fragmentados (?10%)
   - SQL Server 2022 Enterprise
   - Ajustado para: ONLINE, FILLFACTOR 90, compressão PAGE
   ========================================================= */
SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

DECLARE 
    @MinPageCount           int     = 0,      -- ignora índices pequenos se desejar
    @RebuildThreshold       float   = 50.0,   -- fragmentação mínima para REBUILD
    @Mode                   varchar(10) = 'LIMITED'; -- LIMITED | SAMPLED | DETAILED

IF OBJECT_ID('tempdb..#Commands') IS NOT NULL DROP TABLE #Commands;

CREATE TABLE #Commands (
    DatabaseName                sysname,
    SchemaName                  sysname,
    TableName                   sysname,
    IndexName                   sysname,
    AvgFragmentationInPercent   float,
    PageCount                   bigint,
    CommandSQL                  nvarchar(max)
);

DECLARE @db sysname, @SQL nvarchar(max);

DECLARE cur CURSOR FAST_FORWARD FOR
SELECT name
FROM sys.databases
WHERE database_id > 4
  AND state_desc = 'ONLINE'
  AND is_read_only = 0
  AND source_database_id IS NULL
ORDER BY name;

OPEN cur;
FETCH NEXT FROM cur INTO @db;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = N'
USE ' + QUOTENAME(@db) + N';
WITH ips AS (
    SELECT object_id, index_id, partition_number, page_count, avg_fragmentation_in_percent
    FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, ' + QUOTENAME(@Mode,'''') + N')
),
src AS (
    SELECT
        DB_NAME() AS DatabaseName,
        s.name    AS SchemaName,
        o.name    AS TableName,
        i.name    AS IndexName,
        ips.page_count,
        ips.avg_fragmentation_in_percent AS Frag
    FROM ips
    JOIN sys.indexes  AS i ON ips.object_id = i.object_id AND ips.index_id = i.index_id
    JOIN sys.objects  AS o ON i.object_id   = o.object_id
    JOIN sys.schemas  AS s ON o.schema_id   = s.schema_id
    WHERE 
        o.type = ''U''
        AND ips.index_id > 0
        AND i.is_hypothetical = 0
        AND i.type_desc IN (''CLUSTERED'', ''NONCLUSTERED'')
        AND ips.page_count >= @MinPageCount
        AND ips.avg_fragmentation_in_percent >= @RebuildThreshold
)
INSERT INTO #Commands (DatabaseName, SchemaName, TableName, IndexName, AvgFragmentationInPercent, PageCount, CommandSQL)
SELECT 
    src.DatabaseName,
    src.SchemaName,
    src.TableName,
    src.IndexName,
    src.Frag,
    src.page_count,
    ''USE ['' + DB_NAME() + '']; '' +
    ''ALTER INDEX '' + QUOTENAME(src.IndexName) + '' ON '' + QUOTENAME(src.SchemaName) + ''.'' + QUOTENAME(src.TableName) +
    '' REBUILD WITH (ONLINE = ON, FILLFACTOR = 90, DATA_COMPRESSION = PAGE);'' AS CommandSQL
FROM src;
';
    BEGIN TRY
        EXEC sys.sp_executesql
            @SQL,
            N'@MinPageCount int, @RebuildThreshold float',
            @MinPageCount=@MinPageCount, @RebuildThreshold=@RebuildThreshold;
    END TRY
    BEGIN CATCH
        PRINT 'Aviso: falha ao coletar na base ' + QUOTENAME(@db) + ' -> ' + ERROR_MESSAGE();
    END CATCH;

    FETCH NEXT FROM cur INTO @db;
END

CLOSE cur;
DEALLOCATE cur;

-- Resultado final: comandos REBUILD com compressão e FILLFACTOR
SELECT CommandSQL
FROM #Commands
ORDER BY AvgFragmentationInPercent DESC, DatabaseName, SchemaName, TableName, IndexName;
