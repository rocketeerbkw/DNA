-- Create a Database Mail account

EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'DNA Email Account for moderation',
    @description = 'The account used for sending moderation emails.',
    @email_address = 'no-reply@bbc.co.uk',
    @replyto_address = '',
    @display_name = 'BBC Moderation Email',
    @mailserver_name = 'ops-fs0.national.core.bbc.co.uk' ; -- needs changing according to the environment
    

-- Create a Database Mail profile

EXECUTE msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'DNA Moderation Email Profile',
    @description = 'The Moderation profile' ;

-- Add the account to the profile

EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'DNA Moderation Email Profile',
    @account_name = 'DNA Email Account for moderation',
    @sequence_number =1 ;

-- Grant access to the profile to all users in the msdb database

EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'DNA Moderation Email Profile',
    @principal_name = 'public',
    @is_default = 1 ;

-- Database Email Configuration

execute msdb.dbo.sysmail_configure_sp 'AccountRetryAttempts', '1000' 
execute msdb.dbo.sysmail_configure_sp 'AccountRetryDelay', '600'