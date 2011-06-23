echo Deploying to NAthur2
pause
call deploywebserviceslive.bat wwwroot \\192.168.239.12\Inetpub\wwwroot\ filter.reg 192.168.239.12 >deploy_NAthur2.txt
pause
