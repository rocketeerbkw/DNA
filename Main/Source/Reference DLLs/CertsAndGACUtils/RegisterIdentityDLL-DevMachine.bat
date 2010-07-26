gacutil -u DnaIdentityWebServiceProxy
gacutil -i ..\DnaIdentityWebServiceProxy.dll
gacutil -l DnaIdentityWebServiceProxy
pause
regasm /unregister ..\DnaIdentityWebServiceProxy.dll
regasm /register ..\DnaIdentityWebServiceProxy.dll 
pause