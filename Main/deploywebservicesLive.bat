@echo off

set varBinaryRoot=%1
echo BinaryRoot: %varBinaryRoot%
set varServerLocation=%2
echo ServerLocation: %varServerLocation%
set varFilterReg=%3
echo FilterReg: %varFilterReg%
set varServerName=%4
echo ServerName: %varServerName%
set varRobocopyParams=/E /XF web.config /R:1

echo Stopping IIS
sc \\%varServerName% stop w3svc
sc \\%varServerName% stop "memcached server"
sleep 5

echo Copying DNA.Pages
robocopy %varBinaryRoot%\Dnapages\ %varServerLocation%\dnapages %varRobocopyParams%

echo Copying Apis
robocopy %varBinaryRoot%\api\ %varServerLocation%\api\ %varRobocopyParams%

echo Copying skins
robocopy %varBinaryRoot%\h2g2\skins %varServerLocation%\h2g2\skins %varRobocopyParams%

echo Ripley
xcopy %varBinaryRoot%\h2g2\RipleyServer.dll  %varServerLocation%\h2g2\ /y

echo Starting IIS
sc \\%varServerName% start "memcached server"
sc \\%varServerName% start w3svc

echo Deploying Filter.reg
REG IMPORT %varFilterReg%
REG COPY "HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" "\\%varServerName%\HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" /f /s
