echo Deploying to Extdev int
pause
call deploywebserviceslive.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-int\ filter.reg 192.168.239.15 >deploy_extdevint.txt
echo Deploying to Extdev test
pause
call deploywebserviceslive.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-test\ filter.reg 192.168.239.15 >deploy_extdevint.txt
echo Deploying to Extdev
pause
call deploywebserviceslive.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\ filter.reg 192.168.239.15 >deploy_extdevint.txt
pause