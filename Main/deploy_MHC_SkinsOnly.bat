echo Are you sure you want to deploy the skins to all MHC servers?
pause

echo Deploying to NArthur1
call deployskinslive.bat wwwroot \\192.168.239.11\Inetpub\wwwroot\ filter.reg 192.168.239.11 >deploy_NAthur1.txt

echo Deploying to NArthur2
call deployskinslive.bat wwwroot \\192.168.239.12\Inetpub\wwwroot\ filter.reg 192.168.239.12 >deploy_NAthur2.txt

echo Deploying to NArthur3
call deployskinslive.bat wwwroot \\192.168.239.13\Inetpub\wwwroot\ filter.reg 192.168.239.13 >deploy_NAthur3.txt

echo Deploying to NArthur4
call deployskinslive.bat wwwroot \\192.168.239.14\Inetpub\wwwroot\ filter.reg 192.168.239.14 >deploy_NAthur4.txt

echo Deploying to NArthur8
call deployskinslive.bat wwwroot \\192.168.239.18\Inetpub\wwwroot\ filter.reg 192.168.239.18 >deploy_NAthur8.txt

echo Deploying to NArthur9
call deployskinslive.bat wwwroot \\192.168.239.19\Inetpub\wwwroot\ filter.reg 192.168.239.19 >deploy_NAthur9.txt

echo Deploying to NArthur10
call deployskinslive.bat wwwroot \\192.168.239.20\Inetpub\wwwroot\ filter.reg 192.168.239.20 >deploy_NAthur10.txt

echo Deploying to NArthur11
call deployskinslive.bat wwwroot \\192.168.239.21\Inetpub\wwwroot\ filter.reg 192.168.239.21 >deploy_NAthur11.txt

echo Deploying to NArthur12
call deployskinslive.bat wwwroot \\192.168.239.22\Inetpub\wwwroot\ filter.reg 192.168.239.22 >deploy_NAthur12.txt

echo Deploying to NArthur13
call deployskinslive.bat wwwroot \\192.168.239.23\Inetpub\wwwroot\ filter.reg 192.168.239.23 >deploy_NAthur13.txt

echo Deploying to NArthur14
call deployskinslive.bat wwwroot \\192.168.239.24\Inetpub\wwwroot\ filter.reg 192.168.239.24 >deploy_NAthur14.txt

echo Deploying to NArthur15
call deployskinslive.bat wwwroot \\192.168.239.25\Inetpub\wwwroot\ filter.reg 192.168.239.25 >deploy_NAthur15.txt

Done!
pause
