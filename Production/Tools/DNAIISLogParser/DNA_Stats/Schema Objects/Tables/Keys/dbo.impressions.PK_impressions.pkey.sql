ALTER TABLE [dbo].[impressions] ADD CONSTRAINT [PK_impressions] PRIMARY KEY CLUSTERED  ([date], [http_method], [http_status], [machine_name], [site], [url]) ON [PRIMARY]


