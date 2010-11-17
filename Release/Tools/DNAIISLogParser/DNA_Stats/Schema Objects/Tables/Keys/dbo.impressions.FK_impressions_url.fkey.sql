ALTER TABLE [dbo].[impressions] ADD
CONSTRAINT [FK_impressions_url] FOREIGN KEY ([url]) REFERENCES [dbo].[url] ([id])


