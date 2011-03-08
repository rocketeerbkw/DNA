echo Deploying to dna-staging
pause
call deploywebserviceslive.bat wwwroot d:\Inetpub\wwwroot\ filter.reg 192.168.238.19 >deploy_staging.txt
pause
