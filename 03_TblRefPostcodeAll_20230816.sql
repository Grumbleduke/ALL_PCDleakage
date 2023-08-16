USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TblRefPostcodeAll](
	[Postcode] [varchar](10) NOT NULL,
	[HAcode] [varchar](6) NULL,
	[PCOcode] [varchar](3) NULL,
 CONSTRAINT [PK_TblRefPostcodeAll] PRIMARY KEY CLUSTERED 
(
	[Postcode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO


DECLARE @filepathname varchar(255) = 'D:\Github\TRNS_PCDleakage\TblRefPostcodeAll_20230816.txt'
DECLARE @command	  varchar(8000)= ' TRUNCATE TABLE dbo.TblRefPostcodeAll
BULK INSERT dbo.TblRefPostcodeAll FROM "'+@filepathname+'"
WITH(TABLOCK,CODEPAGE=''RAW'',FIELDTERMINATOR = ''|''
	,ROWTERMINATOR = ''\n'',FIRSTROW = 1)
'
exec (@command)
GO
DELETE 
FROM dbo.TblRefPostcodeAll
WHERE CASE
		WHEN LEN(Postcode) < 5 THEN 1 -- Partial postcodes sectors (1679 rows affected)
		WHEN LEN(Postcode) < 7 AND Postcode LIKE '%[0-9]' THEN 1 -- Partial postcode local areas (9436 rows affected)
		ELSE 0
		END = 1
GO