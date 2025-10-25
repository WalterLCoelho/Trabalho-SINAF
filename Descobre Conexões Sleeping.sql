
Select spid, loginame, program_name,login_time, status FROM master.dbo.sysprocesses
Where Status='sleeping'
order by loginame, spid


go

SELECT 
    loginame, 
    COUNT(*) AS Qtd_Conexoes,  -- Conta quantas conexões cada login tem
    STRING_AGG(spid, ', ') AS SPIDs, -- Lista os SPIDs associados ao login
    MAX(login_time) AS Ultimo_Login -- Exibe o horário mais recente de login
FROM master.dbo.sysprocesses
WHERE status = 'sleeping'
GROUP BY loginame
ORDER BY Qtd_Conexoes DESC; -- Ordena pela quantidade de conexões







  