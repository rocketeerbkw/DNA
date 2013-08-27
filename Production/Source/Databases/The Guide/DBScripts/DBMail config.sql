USE master
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'Database Mail XPs', 1;
RECONFIGURE
GO

USE [msdb]
EXEC msdb.dbo.sysmail_start_sp
GO

-- Create a Database Mail account

EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'DNA Email Account (GUIDE6-2)',
    @description = 'The account GUIDE6-2 will use.',
    @email_address = 'guide6-2@bbc.co.uk',
    @replyto_address = '',
    @display_name = 'DNA Guide6-2',
    @mailserver_name = '172.31.130.24' ;

-- Create a Database Mail profile

EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'GUIDE6-2 DNA Email Profile',
    @description = 'The profile used by GUIDE6-2' ;

-- Add the account to the profile

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'GUIDE6-2 DNA Email Profile',
    @account_name = 'DNA Email Account (GUIDE6-2)',
    @sequence_number =1 ;

-- Grant access to the profile to all users in the msdb database

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'GUIDE6-2 DNA Email Profile',
    @principal_name = 'public',
    @is_default = 1 ;

EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'GUIDE6-2 DNA Email Profile',
    @recipients = 'mark.neves@bbc.co.uk',
    @body = 'If you got this, the dbmail configuration for GUIDE6-2 was successful.',
    @subject = 'Testing GUIDE6-2 email' ;

GO

-- Enable SQL Server Agent to use DB Mail
USE [msdb]
GO
EXEC msdb.dbo.sp_set_sqlagent_properties @email_save_in_sent_folder=1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'UseDatabaseMail', N'REG_DWORD', 1
GO
EXEC master.dbo.xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'SOFTWARE\Microsoft\MSSQLServer\SQLServerAgent', N'DatabaseMailProfile', N'REG_SZ', N'GUIDE6-2 DNA Email Profile'
GO

-- Add an operator that can be used to send notifications about SQL Server Agent jobs
USE [msdb]
GO
EXEC msdb.dbo.sp_add_operator @name=N'DNA Ops Team', 
		@enabled=1, 
		@weekday_pager_start_time=80000, 
		@weekday_pager_end_time=180000, 
		@saturday_pager_start_time=80000, 
		@saturday_pager_end_time=180000, 
		@sunday_pager_start_time=80000, 
		@sunday_pager_end_time=180000, 
		@pager_days=127, 
		@email_address=N'mark.neves@bbc.co.uk;jim.lynn@bbc.co.uk;mark.howitt@bbc.co.uk'
GO

-- ************* RESTART SQL SERVER AGENT *************
-- Manually configure which jobs should send notifications

-- Have a look at the emails sent so far
SELECT * FROM dbo.sysmail_allitems

