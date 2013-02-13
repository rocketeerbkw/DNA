echo Are you sure you want to deploy the skins to extdev?
pause

echo Deploying to Extdev int
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-int\ filter.reg 192.168.239.15 >deploy_extdevint.txt

echo Deploying to Extdev test
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-test\ filter.reg 192.168.239.15 >deploy_extdevtest.txt

echo Deploying to Extdev stable
call deployskinsExtdevOthers.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\dna-stable\ filter.reg 192.168.239.15 >deploy_extdevstable.txt

echo Deploying to Extdev 
call deployskinslive.bat wwwroot \\192.168.239.15\d$\Inetpub\wwwroot\ filter.reg 192.168.239.15 >deploy_extdev.txt

echo Done!
pause