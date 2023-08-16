USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAdmin_TableCountsPCDleakage_DisplayPossibleNHSnumbers] (@table varchar(128)='',@column varchar(128)='',@debug char(1)='N') AS

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
--DECLARE @column  varchar(128)--='ATTENDANCE IDENTIFIER'
DECLARE @command varchar(8000)
--DECLARE @table   varchar(128)--='DRUGSNEL_RP4_2122'

IF(@debug='N')
BEGIN
SET NOCOUNT ON
END

------------------------------------------------------------

SELECT *
FROM [dbo].[TblAdmin_TableCountsPCDleakage] as p --where TableName = 'TblSLAM_NVE01pld2122flx_Import'
WHERE Records > 0 AND ColumnMeasure = 'Possible NHSno'
	AND ColumnName NOT IN('RecordInputHash_AllFields')
	AND NOT(ColumnMin LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
			AND ColumnMax LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
			)
	AND NOT(ColumnMin LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
			AND ColumnMax = 'pas-unique-id'
			)
	AND NOT(ISDATE(ColumnMin)=1 AND ISDATE(ColumnMax)=1)
	AND NOT EXISTS(select 1
				   from TblAdmin_TableCountsPCDleakage as L1
				   where ColumnMeasure = 'Valid numbers' AND PercentageOfRecords = 100.00
					and p.TableName = L1.TableName
				   )
	AND NOT EXISTS(select 1
				   from TblAdmin_TableCountsPCDleakage as L2
				   where ColumnMeasure = 'Valid dates' AND PercentageOfRecords = 100.00 -- On the assumption they really will have pseudonymised DoB!
					and p.TableName = L2.TableName
				   ) -- 
	AND CASE WHEN @table = '' THEN TableName ELSE @table END = p.TableName
	AND CASE WHEN @column = '' THEN ColumnName ELSE @column END = p.ColumnName
ORDER BY TableName,ColumnName,ColumnMeasure

------------------------------------------------------------

DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR 
	SELECT --TOP 1
	 TableName,ColumnName
	FROM [dbo].[TblAdmin_TableCountsPCDleakage] as p
	WHERE Records > 0 AND ColumnMeasure = 'Possible NHSno'
		AND ColumnName NOT IN('RecordInputHash_AllFields','RecordInputHash')
		--AND TableName = 'XXX' AND ColumnName = 'YYY'
		AND NOT(ColumnMin LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
				AND ColumnMax LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
				)
		AND NOT(ColumnMin LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'
				AND ColumnMax = 'pas-unique-id'
				)
		AND NOT(ISDATE(ColumnMin)=1 AND ISDATE(ColumnMax)=1)
		AND NOT EXISTS(select 1
					   from TblAdmin_TableCountsPCDleakage as L1
					   where ColumnMeasure = 'Valid numbers' AND PercentageOfRecords = 100.00
						and p.TableName = L1.TableName
					   )
		AND NOT EXISTS(select 1
					   from TblAdmin_TableCountsPCDleakage as L2
					   where ColumnMeasure = 'Valid dates' AND PercentageOfRecords = 100.00 -- On the assumption they really will have pseudonymised DoB!
						and p.TableName = L2.TableName
					   ) -- 
		AND CASE WHEN @table = '' THEN TableName ELSE @table END = p.TableName
		AND CASE WHEN @column = '' THEN ColumnName ELSE @column END = p.ColumnName
	ORDER BY TableName,ColumnName,ColumnMeasure

OPEN table_cursor 
        FETCH NEXT FROM table_cursor into @table,@column
WHILE @@FETCH_STATUS = 0 
        BEGIN 

------------------------------------------------------------

SET @command = '
SELECT TOP 1000 '''+@table+''' as TableName,t1.['+@column+'],n1.PossibleNHSno
FROM ['+@table+'] as t1
	CROSS APPLY dbo.tFnFindNHSno(t1.['+@column+']) as n1
WHERE n1.PossiblyContainsNHSno = 1
	AND CAST(['+@column+'] as varchar(255)) NOT LIKE ''[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]'' 
/*AND CASE WHEN CAST(['+@column+'] as varchar(255)) IS NULL OR len(rtrim(CAST(['+@column+'] as varchar(255)))) < 10 OR CONVERT(BIGINT, LEFT(CAST(['+@column+'] as varchar(255)), PATINDEX(''%[^0-9]%'', CAST(['+@column+'] as varchar(255)) + '' '') - 1)) < 1000000000 
	THEN 0 
	ELSE CASE WHEN CASE WHEN 11 - ((CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 1, 1)) * 10 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 2, 1)) * 9 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 3, 1)) * 8 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 4, 1)) * 7 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 5, 1)) * 6 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 6, 1)) * 5 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 7, 1)) * 4 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 8, 1)) * 3 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 9, 1)) * 2 - (11 * (((CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 1, 1)) * 10 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 2, 1)) * 9 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 3, 1)) * 8 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 4, 1)) * 7 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 5, 1)) * 6 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 6, 1)) * 5 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 7, 1)) * 4 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 8, 1)) * 3 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 9, 1)) * 2) / 11))))) = 11 THEN 0 ELSE 11 - ((CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 1, 1)) * 10 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 2, 1)) * 9 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 3, 1)) * 8 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 4, 1)) * 7 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 5, 1)) * 6 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 6, 1)) * 5 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 7, 1)) * 4 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 8, 1)) * 3 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 9, 1)) * 2 - (11 * (((CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 1, 1)) * 10 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 2, 1)) * 9 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 3, 1)) * 8 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 4, 1)) * 7 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 5, 1)) * 6 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 6, 1)) * 5 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 7, 1)) * 4 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 8, 1)) * 3 + CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 9, 1)) * 2) / 11))))) END = CONVERT(int, substring(CAST(['+@column+'] as varchar(255)), 10, 1)) 
		THEN 1
		ELSE 0
		END 
	END = 1
AND CASE
	WHEN LEN(REPLACE(['+@column+'],'' '','''')) IN(9,10) THEN 1
	WHEN PATINDEX(''%[^0-9]%'',SUBSTRING(['+@column+'],PATINDEX(''%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'',['+@column+'])+1,10)) > 0 AND PATINDEX(''%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'',['+@column+']) > 0 THEN 1
	WHEN PATINDEX(''%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%'',['+@column+'])+9 = LEN(['+@column+']) THEN 1
	ELSE 0
	END = 1*/
GROUP BY t1.['+@column+'],n1.PossibleNHSno
ORDER BY t1.['+@column+'] DESC
'
exec(@command)

------------------------------------------------------------
---Close cursor 

        FETCH NEXT FROM table_cursor INTO @table,@column
END 
CLOSE table_cursor 
DEALLOCATE table_cursor

------------------------------------------------------------
GO