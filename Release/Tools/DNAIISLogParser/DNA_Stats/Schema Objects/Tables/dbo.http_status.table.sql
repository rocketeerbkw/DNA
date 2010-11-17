CREATE TABLE [dbo].[http_status]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[value] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]


