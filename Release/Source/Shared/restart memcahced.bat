rem try and stop memcached
sc stop "memcached server" | FIND "does not exist"

rem if it finds the string "does not exist" in the response, it's not installed, so end
if %errorlevel% == 0 goto end

rem keep looping until the service is in a stopped state
:loop
sc query "memcached server" | FIND "STOPPED"
if %errorlevel% == 1 goto loop

rem start memcached
sc start "memcached server"

:end
