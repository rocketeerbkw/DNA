gacutil -u DnaIdentityWebServiceProxy
gacutil -i "..\..\Shared\DnaIdentityWebServiceProxy\bin\Debug\DnaIdentityWebServiceProxy.dll"
gacutil -l DnaIdentityWebServiceProxy
pause
regasm /unregister "..\..\Shared\DnaIdentityWebServiceProxy\bin\Debug\DnaIdentityWebServiceProxy.dll"
regasm /register "..\..\Shared\DnaIdentityWebServiceProxy\bin\Debug\DnaIdentityWebServiceProxy.dll"
pause