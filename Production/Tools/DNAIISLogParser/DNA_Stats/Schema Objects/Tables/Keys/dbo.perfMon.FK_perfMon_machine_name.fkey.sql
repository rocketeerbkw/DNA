ALTER TABLE [dbo].[perfMon] ADD
CONSTRAINT [FK_perfMon_machine_name] FOREIGN KEY ([machine_name]) REFERENCES [dbo].[machine_name] ([id])


