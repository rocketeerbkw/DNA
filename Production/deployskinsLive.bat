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

echo Copying skins
robocopy %varBinaryRoot%\h2g2\skins %varServerLocation%\h2g2\skins %varRobocopyParams%

