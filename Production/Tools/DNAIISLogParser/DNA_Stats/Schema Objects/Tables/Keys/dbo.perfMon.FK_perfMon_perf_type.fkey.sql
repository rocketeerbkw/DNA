ALTER TABLE [dbo].[perfMon] ADD
CONSTRAINT [FK_perfMon_perf_type] FOREIGN KEY ([perf_type]) REFERENCES [dbo].[perf_type] ([id])


