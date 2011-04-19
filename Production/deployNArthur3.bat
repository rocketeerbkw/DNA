echo Deploying to NAthur3
pause
call deploywebserviceslive.bat wwwroot \\192.168.239.13\d$\Inetpub\wwwroot\ filter.reg 192.168.239.13 >deploy_NAthur3.txt
pause
