echo Deploying to Extdev int
pause
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-int\ filter.reg 192.168.239.15 >deploy_extdevint.txt

echo Deploying to Extdev test
pause
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-test\ filter.reg 192.168.239.15 >deploy_extdevtest.txt

echo Deploying to Extdev stable
pause
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-stable\ filter.reg 192.168.239.15 >deploy_extdevstable.txt

echo Deploying to Extdev 
pause
call deployskinslive.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\ filter.reg 192.168.239.15 >deploy_extdev.txt
pause