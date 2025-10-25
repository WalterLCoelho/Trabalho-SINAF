
-- 1. Habilita autenticação mista (Mixed Mode)
EXEC xp_instance_regwrite 
    N'HKEY_LOCAL_MACHINE',
    N'Software\Microsoft\MSSQLServer\MSSQLServer',
    N'LoginMode',
    REG_DWORD,
    2;
GO

-- 2. Habilita o login 'sa' e troca a senha
ALTER LOGIN sa WITH PASSWORD = 'prdc@200';
ALTER LOGIN sa ENABLE;
GO
