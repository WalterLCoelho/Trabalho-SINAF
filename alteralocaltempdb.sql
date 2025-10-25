--Determine os nomes de arquivo lógicos do banco de dados tempdb e o seu local atual no disco.
SELECT name, physical_name AS CurrentLocation
FROM sys.master_files
WHERE database_id = DB_ID(N'tempdb');
GO

--Altere o local de cada arquivo usando ALTER DATABASE.
USE master;
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =tempdev, FILENAME = 'T:\TEMP\PROD01\tempdb.mdf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =temp2, FILENAME = 'T:\TEMP\PROD01\tempd_mssql_2.ndf');
GO
--ALTER DATABASE tempdb
--MODIFY FILE (NAME =temp3, FILENAME = 'T:\TEMP\PROD01\tempd_mssql_3.ndf');
--GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =temp4, FILENAME = 'T:\TEMP\PROD01\tempd_mssql_4.ndf');
GO
--ALTER DATABASE tempdb
--MODIFY FILE (NAME =temp5, FILENAME = 'T:\TEMP\PROD01\tempdb_mssql_5.ndf');
--GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =temp6, FILENAME = 'T:\TEMP\PROD01\tempdb_mssql_6.ndf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =templog, FILENAME = 'T:\TEMP\PROD01\templog.ldf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =temp7, FILENAME = 'T:\TEMP\PROD01\tempdb_mssql_7.ndf');
GO
ALTER DATABASE tempdb
MODIFY FILE (NAME =temp8, FILENAME = 'T:\TEMP\PROD01\tempdb_mssql_8.ndf');
GO
--ALTER DATABASE tempdb
--MODIFY FILE (NAME =tempdev, FILENAME = 'D:\TEMP\PROD01\tempdb.mdf');
--GO
--ALTER DATABASE tempdb
--MODIFY FILE (NAME =templog1, FILENAME = 'L:\temp\templog1.ldf');
--GO

--ALTER DATABASE tempdb
--MODIFY FILE (NAME =templog1, FILENAME = 'E:\LOG\TEMP\PRD01\templog_mssql_1.ldf');
--GO


--— Pare e reinicie a instância do SQL Server.

--–Verifique a alteração do arquivo.
--SELECT name, physical_name AS CurrentLocation, state_desc
--FROM sys.master_files
--WHERE database_id = DB_ID(N’tempdb’);


tempdev	H:\SQLDATA\PRD03\tempdb.mdf
templog	D:\LOG\PRD03\\templog.ldf
tempdev1	H:\SQLDATA\PRD03\tempdev1.ndf
tempdev2	D:\SQLDATA\PRD03\tempdev2.ndf
tempdev3	H:\SQLDATA\PRD03\tempdev3.ndf
templog1	D:\LOG\PRD03\templog1.ldf
tempdev4	D:\SQLDATA\PRD03\tempdev4.ndf
tempdev5	D:\SQLDATA\PRD03\tempdve5.ndf
templog2	E:\TEMP\templog2.ldf
templog3	L:\LOG\PRD01\templog3.ldf
tempdev6	T:\Temp\tempdev6.ndf