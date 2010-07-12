@echo off

set varBinaryRoot=%1
echo BinaryRoot: "%varBinaryRoot%"
set varServerLocation=%2
echo ServerLocation: "%varServerLocation%"
set varFilterReg=%3
echo FilterReg: "%varFilterReg%"
set varServerName=%4
echo ServerName: "%varServerName%"
set varBuildConfig=%5
echo BuildConfig: "%varBuildConfig%"
set varRobocopyParams=/E /XF web.config /R:1

echo Stopping IIS
sc \\%varServerName% stop w3svc
sc \\%varServerName% stop "memcached server"
sleep 5

echo Copying DNA.Pages
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Dnapages\ %varServerLocation%\wwwroot\dnapages %varRobocopyParams%

echo Copying DNA.Services.Comments
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Comments\ %varServerLocation%\wwwroot\api\comments %varRobocopyParams%

echo Copying DNA.Services.Moderation
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Moderation\ %varServerLocation%\wwwroot\api\moderation %varRobocopyParams%

echo Copying Ripley
robocopy %varBinaryRoot%\Win32\%varBuildConfig% %varServerLocation%\ %varRobocopyParams%\wwwroot\h2g2

echo Starting IIS
sc \\%varServerName% start "memcached server"
sc \\%varServerName% start w3svc

echo Deploying Filter.reg
REG IMPORT %varFilterReg%
REG COPY "HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" "\\%varServerName%\HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" /f /s

echo ErrorLevel: %ERRORLEVEL%
exit %ERRORLEVEL% 