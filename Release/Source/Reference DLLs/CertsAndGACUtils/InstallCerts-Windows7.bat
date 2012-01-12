winhttpcertcfg.exe -i dna-dev.pfx -p dna -c local_machine\my -a IUSR
winhttpcertcfg.exe -l -c local_machine\my -s dna
pause
winhttpcertcfg.exe -i dna-live.pfx -p dn41d3nt1tyl1nk -c local_machine\my -a IUSR
winhttpcertcfg.exe -l -c local_machine\my -s "dna live"
pause
end:
