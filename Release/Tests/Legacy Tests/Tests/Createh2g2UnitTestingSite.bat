echo This script will create a h2g2UnitTestingSite as a second web site. Continue ?

REM - Presume Default Web Site is site 1 and configured.
cscript.exe c:\InetPub\AdminScripts\adsutil.vbs COPY W3SVC/1 W3SVC/2

REM - Change the root path to h2g2UnitTesting
cscript.exe c:\InetPub\AdminScripts\adsutil.vbs SET w3SVC/2/root/path "c:\InetPub\wwwroot\h2g2UnitTesting"

REM - Change the name
cscript.exe c:\InetPub\AdminScripts\adsutil.vbs set w3svc/2/ServerComment "h2g2UnitTesting"


REM - Set port of test server to 8081
cscript.exe c:\Inetpub\AdminScripts\adsutil.vbs SET w3svc/2/serverbindings ":8081:"

REM - Create Schemas Directory
c:\Inetpub\AdminScripts\adsutil.vbs CREATE w3svc/2/root/Schemas "IIsWebVirtualDir"
c:\Inetpub\AdminScripts\adsutil.vbs SET w3svc/2/root/Schemas/path "D:\vp-dev-dna-1\User Services\Main\Source\Schemas"

cscript.exe c:\InetPub\AdminScripts\adsutil.vbs enum w3svc

PAUSE