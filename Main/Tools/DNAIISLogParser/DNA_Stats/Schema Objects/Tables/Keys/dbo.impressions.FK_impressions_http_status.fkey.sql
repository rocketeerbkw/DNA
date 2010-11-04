ALTER TABLE [dbo].[impressions] ADD
CONSTRAINT [FK_impressions_http_status] FOREIGN KEY ([http_status]) REFERENCES [dbo].[http_status] ([id])


