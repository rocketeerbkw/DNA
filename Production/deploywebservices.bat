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
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Dnapages\ %varServerLocation%\dna\dnapages %varRobocopyParams%

echo Copying DNA.Services.Comments
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Comments\ %varServerLocation%\dna\api\comments %varRobocopyParams%

echo Copying DNA.Services.Moderation
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Moderation\ %varServerLocation%\dna\api\moderation %varRobocopyParams%

echo Copying DNA.Services.Articles
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Articles\ %varServerLocation%\dna\api\articles %varRobocopyParams%

echo Copying DNA.Services.Categories
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Categories\ %varServerLocation%\dna\api\categories %varRobocopyParams%

echo Copying DNA.Services.Forums
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Forums\ %varServerLocation%\dna\api\forums %varRobocopyParams%

echo Copying DNA.Services.Users
robocopy %varBinaryRoot%\%varBuildConfig%\_PublishedWebsites\BBC.DNA.Services.Users\ %varServerLocation%\dna\api\users %varRobocopyParams%

echo Copying Ripley
echo not deploying ripley here
echo robocopy %varBinaryRoot%\Win32\%varBuildConfig% %varServerLocation%\ %varRobocopyParams%

echo Starting IIS
sc \\%varServerName% start "memcached server"
sc \\%varServerName% start w3svc

echo Deploying Filter.reg
REG IMPORT %varFilterReg%
REG COPY "HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" "\\%varServerName%\HKLM\SOFTWARE\The Digital Village\h2g2 web server\URLmap\Prefixes" /f /s

echo ErrorLevel: %ERRORLEVEL%
exit %ERRORLEVEL% 