echo Deploying to NAthur24
pause
call deploywebserviceslive.bat wwwroot \\172.31.58.10\d$\Inetpub\wwwroot\ filter.reg 172.31.58.10 >deploy_NAthur24.txt
pause
