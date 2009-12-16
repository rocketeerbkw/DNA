rem memcached.exe -uninstall
rem memcached.exe -help
rem "install with 50MB memory usage"
memcached.exe -d install -m 50
memcached.exe -d start
pause