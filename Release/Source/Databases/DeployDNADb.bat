title %1
set PublishXml=%1

set SqlPackage=%ProgramFiles(x86)%\Microsoft SQL Server\110\DAC\bin\SqlPackage.exe
"%SqlPackage%" /Action:Publish /SourceFile:DNADb.dacpac               /Profile:%PublishXml% /p:DropObjectsNotInSource=False
"%SqlPackage%" /Action:Publish /SourceFile:DNADb_DataMigration.dacpac /Profile:%PublishXml% /p:DropObjectsNotInSource=False

exit /B
