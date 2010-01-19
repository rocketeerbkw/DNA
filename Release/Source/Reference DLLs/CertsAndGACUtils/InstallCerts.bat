REM You need to edit this before running it. Please make sure you change IWAM_ to your computer name i.e. IWAM_OPSDNA1. Once done, remove the goto end: line
pause
goto end:
winhttpcertcfg.exe -i dna-dev.pfx -p dnatesting -c local_machine\my -a ASPNET 
winhttpcertcfg.exe -i dna-live.pfx -p dn41d3nt1tyl1nk -c local_machine\my -a ASPNET
winhttpcertcfg.exe -g -c local_machine\my -s dna -a IWAM_YOUR-MACHINE-NAME-HERE!!! <--
winhttpcertcfg.exe -g -c local_machine\my -s "dna live" -a IWAM_YOUR-MACHINE-NAME-HERE!!! <--
winhttpcertcfg.exe -l -c local_machine\my -s dna
winhttpcertcfg.exe -l -c local_machine\my -s "dna live"
pause
end:
