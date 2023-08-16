USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TblAdmin_TableCountsPCDleakage](
	[TableName] [varchar](255) NOT NULL,
	[ColumnName] [varchar](255) NOT NULL,
	[ColumnMeasure] [varchar](255) NOT NULL,
	[Records] [bigint] NOT NULL,
	[PercentageOfRecords] [decimal](8, 2) NOT NULL,
	[ColumnMin] [varchar](255) NULL,
	[ColumnMax] [varchar](255) NULL,
	[DateLastChecked] [smalldatetime] NOT NULL
) ON [PRIMARY]
GO


