CREATE LOGIN [ripley] WITH PASSWORD='S0meth1ngTr1cky', DEFAULT_DATABASE=[TheGuide], DEFAULT_LANGUAGE=[us_english], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF
GO
USE TheGuide
GO
-- Map the "ripley" user in TheGuide with the "ripley" login
EXEC sp_change_users_login 'Update_One','ripley','ripley'
