ALTER TABLE [dbo].[perfMon] ADD CONSTRAINT [PK_perfMon] PRIMARY KEY CLUSTERED  ([datetime], [machine_name], [perf_type], [perf_instance], [perf_counter]) ON [PRIMARY]


