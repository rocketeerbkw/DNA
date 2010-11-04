CREATE TABLE [dbo].[perfMon]
(
[datetime] [datetime] NOT NULL,
[machine_name] [int] NOT NULL,
[perf_type] [int] NOT NULL,
[perf_instance] [int] NOT NULL,
[perf_counter] [int] NOT NULL,
[value] [real] NOT NULL
) ON [PRIMARY]


