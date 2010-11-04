ALTER TABLE [dbo].[impressions] ADD
CONSTRAINT [FK_impressions_site] FOREIGN KEY ([site]) REFERENCES [dbo].[site] ([id])


