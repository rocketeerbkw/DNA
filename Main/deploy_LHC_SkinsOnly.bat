echo Are you sure you want to deploy the skins to all LHC servers?
pause

echo Deploying to NAthur16
call deployskinslive.bat wwwroot \\172.31.58.14\d$\Inetpub\wwwroot\ filter.reg 172.31.58.14 >deploy_NAthur16.txt

echo Deploying to NAthur17
call deployskinslive.bat wwwroot \\172.31.58.3\d$\Inetpub\wwwroot\ filter.reg 172.31.58.3 >deploy_NAthur17.txt

echo Deploying to NAthur18
call deployskinslive.bat wwwroot \\172.31.58.4\d$\Inetpub\wwwroot\ filter.reg 172.31.58.4 >deploy_NAthur18.txt

echo Deploying to NAthur19
call deployskinslive.bat wwwroot \\172.31.58.5\d$\Inetpub\wwwroot\ filter.reg 172.31.58.5 >deploy_NAthur19.txt

echo Deploying to NAthur20
call deployskinslive.bat wwwroot \\172.31.58.6\d$\Inetpub\wwwroot\ filter.reg 172.31.58.6 >deploy_NAthur20.txt

echo Deploying to NAthur21
call deployskinslive.bat wwwroot \\172.31.58.7\d$\Inetpub\wwwroot\ filter.reg 172.31.58.7 >deploy_NAthur21.txt

echo Deploying to NAthur22
call deployskinslive.bat wwwroot \\172.31.58.8\d$\Inetpub\wwwroot\ filter.reg 172.31.58.8 >deploy_NAthur22.txt

echo Deploying to NAthur23
call deployskinslive.bat wwwroot \\172.31.58.9\d$\Inetpub\wwwroot\ filter.reg 172.31.58.9 >deploy_NAthur23.txt

echo Deploying to NAthur24
call deployskinslive.bat wwwroot \\172.31.58.10\d$\Inetpub\wwwroot\ filter.reg 172.31.58.10 >deploy_NAthur24.txt

echo Deploying to NAthur25
call deployskinslive.bat wwwroot \\172.31.58.11\d$\Inetpub\wwwroot\ filter.reg 172.31.58.11 >deploy_NAthur25.txt

echo Deploying to NAthur26
call deployskinslive.bat wwwroot \\172.31.58.12\d$\Inetpub\wwwroot\ filter.reg 172.31.58.12 >deploy_NAthur26.txt

echo Deploying to NAthur27
call deployskinslive.bat wwwroot \\172.31.58.13\d$\Inetpub\wwwroot\ filter.reg 172.31.58.13 >deploy_NAthur27.txt

Done!
pause
