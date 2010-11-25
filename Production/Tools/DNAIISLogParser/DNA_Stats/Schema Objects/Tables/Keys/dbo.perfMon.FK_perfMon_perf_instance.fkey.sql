ALTER TABLE [dbo].[perfMon] ADD
CONSTRAINT [FK_perfMon_perf_instance] FOREIGN KEY ([perf_instance]) REFERENCES [dbo].[perf_instance] ([id])


