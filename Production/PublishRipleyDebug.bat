iisreset /stop
xcopy "D:\vp-dev-dna-1\User Services\Main\Source\Ripley\Debug"\ripley*.* C:\Inetpub\wwwroot\h2g2\ /Y
xcopy "D:\vp-dev-dna-1\User Services\Main\Source\Ripley\Debug"\ripley*.* C:\Inetpub\wwwroot\h2g2UnitTesting\ /Y
iisreset
pause