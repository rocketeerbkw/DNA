ALTER TABLE [dbo].[impressions] ADD
CONSTRAINT [FK_impressions_machine_name] FOREIGN KEY ([machine_name]) REFERENCES [dbo].[machine_name] ([id])


