USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TblLog_Imports](
	[LocalIndex_imp] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](255) NOT NULL,
	[SourcePath] [varchar](255) NOT NULL,
	[SourceName] [varchar](255) NOT NULL,
	[SourceDateStamp] [smalldatetime] NULL,
	[ImportStartDateTime] [smalldatetime] NULL,
	[ImportEndDateTime] [smalldatetime] NULL,
	[ImportDurationMinutes] [float] NULL,
	[Records] [int] NULL,
	[FlagNewColumnsReceived] [varchar](1) NULL,
	[Comments] [varchar](8000) NULL,
 CONSTRAINT [PK_TblLog_Imports] PRIMARY KEY CLUSTERED 
(
	[LocalIndex_imp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO


