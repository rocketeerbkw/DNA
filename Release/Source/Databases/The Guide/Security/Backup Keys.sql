/*
These commands were used to generate the SMK files for the two DNA SQL Server production instances, GUIDE6-1 and GUIDE6-2

The GUIDE6-1 key was restored to GUIDE6-2 so that they both have the same SMK, which allows seamless decryption
when the TheGuide is failed over between the instances

*/
BACKUP SERVICE MASTER KEY TO FILE = 'E:\Database Scripts\GUIDE6-1.smk' 
    ENCRYPTION BY PASSWORD = 'ItrWn%^6%236*(jnHtgjjk-RUSH';
GO
BACKUP SERVICE MASTER KEY TO FILE = 'E:\Database Scripts\GUIDE6-2.smk' 
    ENCRYPTION BY PASSWORD = '987jkhuhYf%$f%$f22-PULP';
GO

