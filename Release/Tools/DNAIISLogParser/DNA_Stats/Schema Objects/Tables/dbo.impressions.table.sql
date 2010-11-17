CREATE TABLE [dbo].[impressions]
(
[date] [datetime] NOT NULL,
[http_method] [int] NOT NULL,
[http_status] [int] NOT NULL,
[machine_name] [int] NOT NULL,
[site] [int] NOT NULL,
[url] [int] NOT NULL,
[count] [int] NOT NULL,
[min] [int] NOT NULL,
[max] [int] NOT NULL,
[avg] [int] NOT NULL
) ON [PRIMARY]


