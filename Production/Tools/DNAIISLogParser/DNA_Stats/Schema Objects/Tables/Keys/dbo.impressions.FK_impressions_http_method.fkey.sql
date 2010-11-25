ALTER TABLE [dbo].[impressions] ADD
CONSTRAINT [FK_impressions_http_method] FOREIGN KEY ([http_method]) REFERENCES [dbo].[http_method] ([id])


