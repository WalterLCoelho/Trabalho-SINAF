DECLARE @DataInicio DATETIME = '2025-10-25 07:00:00';
DECLARE @DataFim DATETIME = '2025-10-25 23:30:00';
--DECLARE @Session INT = 86
declare @User varchar(50) = 'ptunning';

-- Consulta 1: Quantidade de bloqueios por data
SELECT 
    CONVERT(DATE, start_time, 103) AS Data,
    COUNT(*) AS QuantidadeLocks
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
    --AND DATEPART(HOUR, CONVERT(DATETIME, start_time, 100)) BETWEEN 6 AND 24
    AND blocking_session_id IS NOT NULL and login_name != 'NT SERVICE\SQLAgent$PRD01'
GROUP BY CONVERT(DATE, start_time, 103)
ORDER BY Data;



-- Consulta 2: Usu�rios ativos no intervalo Descrito

SELECT --DISTINCT 
    login_name AS Usuario,
    --database_name AS DatabaseName,
    --host_name AS HostName,
	program_name AS Aplica��o,
    --wait_info AS Tipo_de_Espera,
    --database_name AS Base,
    CONVERT(DATETIME, start_time, 100) AS Time
FROM [admin].[dbo].[Resultado]

WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
   --AND DATEPART(HOUR, CONVERT(DATETIME, start_time, 100)) BETWEEN 6 AND 24
	and login_name != 'SINAF\veeambackup' and login_name != 'NT SERVICE\SQLAgent$PRD01' and login_name != 'NT SERVICE\SQLTELEMETRY$PRD01' and login_name != 'NT AUTHORITY\SYSTEM'
	order by start_time DESC

-- Consulta 3: Sess�es sem bloqueio
SELECT  
    CONVERT(DATETIME, start_time, 100) AS Time,
    [dd hh:mm:ss.mss] AS Tempo_Lock,
    session_id AS Sess�o_ativa,
    status as status,
    host_name AS Host,
    program_name AS Aplica��o,
    wait_info AS Tipo_de_Espera,
    database_name AS Base,
    sql_text AS C�digo,
    login_name AS Usuario,
    blocking_session_id AS Sess�o_Bloqueadora
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim 
	-- AND DATEPART(HOUR, CONVERT(DATETIME, start_time, 100)) BETWEEN 6 AND 24 
    --and program_name = 'RISCOSPESSOAISWEB-Sies'
ORDER BY Time desc;

-- Consulta 3: Sess�es com bloqueio 
SELECT  
    CONVERT(DATETIME, start_time, 100) AS Time,
    [dd hh:mm:ss.mss] AS Tempo_Lock,
    session_id AS Sess�o_ativa,
    host_name AS Host,
    wait_info AS Tipo_de_Espera,
    program_name AS Aplica��o,
    database_name AS Base,
    sql_text AS C�digo,
    login_name AS Usuario,
    blocking_session_id AS Sess�o_Bloqueadora
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
    --AND DATEPART(HOUR, CONVERT(DATETIME, start_time, 100)) BETWEEN 6 AND 24
   -- and program_name = 'RISCOSPESSOAISWEB-Sies'
	AND CAST(sql_text AS NVARCHAR(MAX))COLLATE SQL_LATIN1_General_CP1_CI_AI NOT LIKE '%numeradorDoc%'
    AND blocking_session_id IS NOT NULL 
ORDER BY Time;

---- Consulta 4: Sess�o espec�fica (por session_id) 
SELECT  
    CONVERT(DATETIME, start_time, 100) AS Time,
    [dd hh:mm:ss.mss] AS Tempo_Lock,
    session_id AS Sess�o_ativa,
    host_name AS Host,
    wait_info AS Tipo_de_Espera,
    program_name AS Aplica��o,
    database_name AS Base,
    sql_text AS C�digo,
    login_name AS Usuario,
    blocking_session_id AS Sess�o_Bloqueadora
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
    --AND DATEPART(HOUR, CONVERT(DATETIME, start_time, 100)) BETWEEN 6 AND 24
    --AND session_id = @Session 
	AND login_name = @User
ORDER BY Time;

-- Consulta 5: Sess�es Bloquedas tabela numeradorDoc

SELECT  
    CONVERT(DATETIME, start_time, 100) AS Time,
    [dd hh:mm:ss.mss] AS Tempo_Lock,
    session_id AS Sess�o_ativa,
    host_name AS Host,
    wait_info AS Tipo_de_Espera,
    program_name AS Aplica��o,
    database_name AS Base,
    sql_text AS C�digo,
    login_name AS Usuario,
    blocking_session_id AS Sess�o_Bloqueadora,
    ISNULL((
        LEN(CAST(sql_text AS NVARCHAR(MAX))) - 
        LEN(REPLACE(CAST(sql_text AS NVARCHAR(MAX)), 'numeradorDoc', ''))
    ) / LEN('numeradorDoc'), 0) AS Qtde_numeradorDoc
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
    AND blocking_session_id IS NOT NULL 
    AND CAST(sql_text AS NVARCHAR(MAX))COLLATE SQL_LATIN1_General_CP1_CI_AI NOT LIKE '%numeradorDoc%' 
ORDER BY Time;

-- Consulta 6: Sess�es Bloquedas tabela TransicaoCRM

SELECT  
    CONVERT(DATETIME, start_time, 100) AS Time,
    [dd hh:mm:ss.mss] AS Tempo_Lock,
    session_id AS Sess�o_ativa,
    host_name AS Host,
    wait_info AS Tipo_de_Espera,
    program_name AS Aplica��o,
    database_name AS Base,
    sql_text AS C�digo,
    login_name AS Usuario,
    blocking_session_id AS Sess�o_Bloqueadora,
    ISNULL((
        LEN(CAST(sql_text AS NVARCHAR(MAX))) - 
        LEN(REPLACE(CAST(sql_text AS NVARCHAR(MAX)), 'TransicaoCRM', ''))
    ) / LEN('TransicaoCRM'), 0) AS Qtde_TransicaoCRM
FROM [admin].[dbo].[Resultado]
WHERE 
    CONVERT(DATETIME, start_time, 100) BETWEEN @DataInicio AND @DataFim
    AND blocking_session_id IS NOT NULL 
    AND CAST(sql_text AS NVARCHAR(MAX))COLLATE SQL_LATIN1_General_CP1_CI_AI LIKE '%TransicaoCRM%' 
ORDER BY Time;


