USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAdmin_TableCountsPCDleakage_DisplayPossibleDoB] (@table varchar(128)='',@column varchar(128)='',@debug char(1)='N') AS

IF @debug LIKE '%[^N,Y]' ESCAPE '_'
RETURN
;
/*
IF @table LIKE '%[^-__A-Za-z0-9:\. ¡¥©§±|]%' ESCAPE '_' -- Need to think about these patterns
RETURN
;
*/
/*
IF @column LIKE '%[^-__A-Za-z0-9:\. ¡¥©§±|]%' ESCAPE '_' -- Need to think about these patterns
RETURN
;
*/
------------------------------------------------------------
--DECLARE @column  varchar(128)  = ''
DECLARE @command varchar(8000)
--DECLARE @debug   char(1) = 'Y'
--DECLARE @table   varchar(128)  = ''

IF(@debug='N')
BEGIN
SET NOCOUNT ON
END

------------------------------------------------------------

SELECT *
FROM [dbo].[TblAdmin_TableCountsPCDleakage] as p --where TableName = 'TblSLAM_NVE01pld2122flx_Import'
WHERE Records > 0 AND ColumnMeasure = 'Possible DoB'
	AND ColumnName NOT IN('RecordInputHash_AllFields')
	AND NOT(ISDATE(ColumnMin)=1 AND ISDATE(ColumnMax)=1)
	AND NOT EXISTS(select 1
				   from TblAdmin_TableCountsPCDleakage as L1
				   where ColumnMeasure = 'Valid numbers' AND PercentageOfRecords = 100.00
					and p.TableName = L1.TableName
				   )
/*	AND NOT EXISTS(select 1
				   from TblAdmin_TableCountsPCDleakage as L2
				   where ColumnMeasure = 'Valid dates' AND PercentageOfRecords = 100.00 -- On the assumption they really will have pseudonymised DoB!
					and p.TableName = L2.TableName
				   )*/ -- 
	AND CASE WHEN @table = '' THEN TableName ELSE @table END = p.TableName
	AND CASE WHEN @column = '' THEN ColumnName ELSE @column END = p.ColumnName
ORDER BY TableName,ColumnName,ColumnMeasure

------------------------------------------------------------

DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR 
	SELECT --TOP 1
	 TableName,ColumnName
	FROM [dbo].[TblAdmin_TableCountsPCDleakage] as p
	WHERE Records > 0 AND ColumnMeasure = 'Possible DoB'
		AND ColumnName NOT IN('RecordInputHash_AllFields','RecordInputHash')
		--AND TableName = 'XXX' AND ColumnName = 'YYY'
		AND NOT(ISDATE(ColumnMin)=1 AND ISDATE(ColumnMax)=1)
		AND NOT EXISTS(select 1
					   from TblAdmin_TableCountsPCDleakage as L1
					   where ColumnMeasure = 'Valid numbers' AND PercentageOfRecords = 100.00
						and p.TableName = L1.TableName
					   )
		/*AND NOT EXISTS(select 1
					   from TblAdmin_TableCountsPCDleakage as L2
					   where ColumnMeasure = 'Valid dates' AND PercentageOfRecords = 100.00 -- On the assumption they really will have pseudonymised DoB!
						and p.TableName = L2.TableName
					   )*/ -- 
		AND CASE WHEN @table = '' THEN TableName ELSE @table END = p.TableName
		AND CASE WHEN @column = '' THEN ColumnName ELSE @column END = p.ColumnName
	ORDER BY TableName,ColumnName,ColumnMeasure

OPEN table_cursor 
        FETCH NEXT FROM table_cursor into @table,@column
WHILE @@FETCH_STATUS = 0 
        BEGIN 

IF(@debug='Y')
BEGIN
PRINT @table
PRINT @column
END

------------------------------------------------------------

BEGIN TRY

SET @command = '
SELECT ['+@column+'],d1.DateAsString
INTO #d
FROM ['+@table+'] as t
	CROSS APPLY dbo.tFnFindDatesInString(CAST(['+@column+'] as varchar(8000))) as d1
WHERE d1.DateAsString IS NOT NULL
GROUP BY ['+@column+'],d1.DateAsString

SELECT TOP 1000 '''+@table+''' as TableName,d.['+@column+'],d.DateAsString,d2.StringAsDate,d2.AssumedDateFormatCode,d2.DateConversionAccuracy,d2.PossibleFormats,d2.DateConversionAccuracy
FROM #d as d
	CROSS APPLY dbo.tFnConvertStringToSmallDateTime(d.DateAsString) as d2
WHERE d2.StringAsDate IS NOT NULL
	AND DATEDIFF(YEAR,d2.StringAsDate,GETDATE()) > 10
ORDER BY d2.StringAsDate DESC
--d.['+@column+'] DESC

DROP TABLE #d
'
IF(@debug='Y')
BEGIN
PRINT @command
END
exec(@command)

END TRY

BEGIN CATCH

SELECT 
	''+@table+'' as TableName,''+@column+'' as ColumnName
	,ERROR_NUMBER() ERNumber
	,ERROR_SEVERITY() Error_Severity
	,ERROR_STATE() Error_State
	,ERROR_PROCEDURE() Error_Procedure
	,ERROR_LINE() Error_Line
	,ERROR_MESSAGE() Error_Message

END CATCH

------------------------------------------------------------
---Close cursor 

        FETCH NEXT FROM table_cursor INTO @table,@column
END 
CLOSE table_cursor 
DEALLOCATE table_cursor

------------------------------------------------------------
GO


