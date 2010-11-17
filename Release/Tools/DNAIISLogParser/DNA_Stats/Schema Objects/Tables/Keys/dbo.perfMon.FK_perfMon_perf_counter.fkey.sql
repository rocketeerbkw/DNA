ALTER TABLE [dbo].[perfMon] ADD
CONSTRAINT [FK_perfMon_perf_counter] FOREIGN KEY ([perf_counter]) REFERENCES [dbo].[perf_counter] ([id])


