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
set varRobocopyParams=RipleyServer.dll /E /XF web.config /R:1

echo Stopping IIS
sc \\%varServerName% stop w3svc
sc \\%varServerName% stop "memcached server"
sleep 5

echo Copying Ripley
robocopy %varBinaryRoot%\Win32\%varBuildConfig%\ %varServerLocation%\ %varRobocopyParams%

echo Starting IIS
sc \\%varServerName% start "memcached server"
sc \\%varServerName% start w3svc

echo ErrorLevel: %ERRORLEVEL%
exit %ERRORLEVEL% 