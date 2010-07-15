iisreset /stop
net stop "memcached server"
net start "memcached server"
iisreset /start
pause