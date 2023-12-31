USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAdmin_DeterminePossiblePCDleakageInTableV2]  (@table varchar(128),@debug char(1)='N') AS

IF @debug LIKE '%[^N,Y]' ESCAPE '_'
RETURN
;
/*
IF @table LIKE '%[^-__A-Za-z0-9:\. ¡¥©§±|]%' ESCAPE '_' -- Need to think about these patterns
RETURN
;
*/
---------------------------------------------------------------------------------
---Declare variables

--DECLARE @debug		 varchar(1)		SET @debug = 'Y' -- Set to Y to print statements
DECLARE @column		 varchar(128)
DECLARE @columns	 int			SET @columns = (select COUNT(*) as NoOfColumns from sys.columns where OBJECT_NAME(object_id)=@table)
DECLARE @columnid	 int
DECLARE @columnLen	 int
DECLARE @column_type tinyint
--DECLARE @compression varchar(5)
DECLARE @command0	 varchar(8000)	SET @command0  = ''
DECLARE @command1	 varchar(max)	SET @command1  = CAST('' as varchar(max))
DECLARE @command2	 varchar(max)	SET @command2  = CAST('' as varchar(max))
DECLARE @command3	 varchar(max)	SET @command3  = CAST('' as varchar(max))
DECLARE @command4	 varchar(max)	SET @command4  = CAST('' as varchar(max))
DECLARE @command5	 varchar(max)	SET @command5  = CAST('' as varchar(max))
DECLARE @command6	 varchar(max)	SET @command6  = CAST('' as varchar(max))
DECLARE @command7	 varchar(max)	SET @command7  = CAST('' as varchar(max))
DECLARE @command8	 varchar(max)	SET @command8  = CAST('' as varchar(max))
DECLARE @command9	 varchar(max)	SET @command9  = CAST('' as varchar(max))
DECLARE @command11	 varchar(max)	SET @command11 = CAST('' as varchar(max))
DECLARE @command21	 varchar(max)	SET @command21 = CAST('' as varchar(max))
DECLARE @command31	 varchar(max)	SET @command31 = CAST('' as varchar(max))
DECLARE @command41	 varchar(max)	SET @command41 = CAST('' as varchar(max))
DECLARE @command51	 varchar(max)	SET @command51 = CAST('' as varchar(max))
DECLARE @command61	 varchar(max)	SET @command61 = CAST('' as varchar(max))
DECLARE @command71	 varchar(max)	SET @command71 = CAST('' as varchar(max))
DECLARE @command81	 varchar(max)	SET @command81 = CAST('' as varchar(max))
DECLARE @command91	 varchar(max)	SET @command91 = CAST('' as varchar(max))
--DECLARE @command12	 varchar(max)	SET @command12 = CAST('' as varchar(max))
DECLARE @command22	 varchar(max)	SET @command22 = CAST('' as varchar(max))
DECLARE @datestamp	 varchar(20)	SET @datestamp = (SELECT CONVERT(varchar(20),GETDATE(),113))
DECLARE @int		 int			SET @int   = 0
DECLARE @intp		 int			SET @intp  = 0
--DECLARE @table		 varchar(128)	SET @table = 'import_example'
DECLARE @tableOut	varchar(255)	SET @tableOut	  = '##Results_'+REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(SUSER_NAME()+CONVERT(varchar(24),GETDATE(),113),'\',''),'/',''),':',''),' ',''),'-',''),'$','')
DECLARE @threshold  int				SET @threshold = 50

IF(@debug='N')
BEGIN
SET NOCOUNT ON
END

---------------------------------------------------------------------------------

SET @command0 = '
CREATE TABLE ['+@tableOut+'](
 TableName varchar(255) NOT NULL
,ColumnName varchar(255) NOT NULL
,ColumnMeasure varchar(255) NOT NULL
,Records int NOT NULL
,PercentageOfRecords DECIMAL(8,2) NOT NULL
,ColumnMin varchar(255) NULL
,ColumnMax varchar(255) NULL
)
'
IF(@debug='Y')
BEGIN
PRINT @command0
END
exec(@command0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------

WHILE @int < (SELECT MAX(column_id)+1 FROM sys.columns WHERE OBJECT_NAME(object_id)=@table)
BEGIN -- Start of WHILE loop
	SET @int = @int+@threshold

IF(@debug='Y')
BEGIN
PRINT '-->-- Columns '+CAST(@intp as varchar(20))+' to '+CAST(@int+1 as varchar(20))
END

SET @command1 = 'INSERT INTO ['+@tableOut+'](TableName,ColumnName,ColumnMeasure,Records,PercentageOfRecords,ColumnMin,ColumnMax)
SELECT
 p.TableName
,x.ColumnName
,x.ColumnMeasure
,ISNULL(x.ColumnValue1,0) as Records
,ISNULL(ROUND(CAST(100.00 as float) * CAST(CASE 
									--WHEN x.ColumnMeasure = ''Maximum length'' THEN NULL
									WHEN p.Records > 0 THEN CAST(x.ColumnValue1 as float) / CAST(p.Records as float) 
									ELSE 0.00 
									END as float),2),100.00) as PercentageOfRecords
,ISNULL(x.ColumnMin,CAST('''+CASE WHEN @columns > 101 THEN 'Expression services limit has been reached over 101 columns.' ELSE '' END+''' as varchar(255))) as ColumnMin
,ISNULL(x.ColumnMax,CAST('''+CASE WHEN @columns > 101 THEN 'Query processor runs out of internal resources over 750 columns.' ELSE '' END+''' as varchar(255))) as ColumnMax
FROM (-- p
SELECT '''+@table+''' as TableName,COUNT(*) as Records'

--- Reset command in cursor (excludes @command1, @command11, @command9, @command91)
SET @command2  = CAST('' as varchar(max)) SET @command3  = CAST('' as varchar(max)) SET @command4  = CAST('' as varchar(max)) SET @command5  = CAST('' as varchar(max))
SET @command6  = CAST('' as varchar(max)) SET @command7  = CAST('' as varchar(max)) SET @command8  = CAST('' as varchar(max)) 
SET @command21 = CAST('' as varchar(max)) SET @command31 = CAST('' as varchar(max)) SET @command41 = CAST('' as varchar(max)) SET @command51 = CAST('' as varchar(max))
SET @command61 = CAST('' as varchar(max)) SET @command71 = CAST('' as varchar(max)) SET @command81 = CAST('' as varchar(max)) 
SET @command22 = CAST('' as varchar(max)) 

---------------------------------------------------------------------------------

--- Declare column cusor
DECLARE cursor_column CURSOR FOR 
	select --TOP 1
	 sc.[name] as ColumnName
	,sc.column_id 
	,sc.system_type_id as ColumnType
	from sys.columns sc 
	where object_name(object_id) = @table 
		AND column_id > @intp AND column_id < @int+1 -- Based on threshold where errors for complexity start being generated.
		--and column_id < 102 -- More than 101 columns is too complex.
		--and column_id < 750 -- More than 750 columns causes an error.
	ORDER BY sc.column_id

--- Open column cursor        
OPEN cursor_column 
        FETCH NEXT FROM cursor_column into @column,@columnid,@column_type
WHILE @@FETCH_STATUS = 0 
        BEGIN 

IF(@debug='Y')
BEGIN
PRINT '--' + @table + ' ' + @column 
END

--2x - NHSno
SET @command2 = @command2 + '
,SUM('+CASE WHEN @column_type IN(34	 -- image
								,36  -- uniqueidentifier
								,40  --	date
								,41  --	time
								,42  --	datetime2
								,43  --	datetimeoffset
								,48  --	tinyint
								,52  --	smallint
								,58  --	smalldatetime
								,61  --	datetime
								,98  --	sql_variant
								,104 --	bit
								,240 --	hierarchyid
								,240 --	geometry
								,240 --	geography
								,165 --	varbinary
								,189 --	timestamp
								)
			THEN '0' 
		WHEN @columnLen < 10
			THEN '0'
		ELSE 'n'+CAST(@columnid as varchar(20))+'.PossiblyContainsNHSno' END +') as [c'+CAST(@columnid as varchar(5))+'_NHSno]'
SET @command21 = @command21 + '
,('''+REPLACE(@column,'''','''''')+''',''Possible NHSno'',ISNULL([c'+CAST(@columnid as varchar(122))+'_NHSno],''''),CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),2)'
SET @command22 = @command22 
	 + CASE WHEN @column_type IN(34	 -- image
								,36  -- uniqueidentifier
								,40  --	date
								,41  --	time
								,42  --	datetime2
								,43  --	datetimeoffset
								,48  --	tinyint
								,52  --	smallint
								,58  --	smalldatetime
								,61  --	datetime
								,98  --	sql_variant
								,104 --	bit
								,240 --	hierarchyid
								--,240 --	geometry
								--,240 --	geography
								,165 --	varbinary
								,189 --	timestamp
								)
			THEN '' 
		WHEN @columnLen < 10
			THEN ''
		ELSE '
	CROSS APPLY dbo.tFnFindNHSno(CAST(['+@column+'] as varchar(8000))) as n'+CAST(@columnid as varchar(20)) END
--3x - number
SET @command3 = @command3 + '
,SUM('+CASE WHEN @column_type IN(48  --	tinyint
								,52  --	smallint
								,56  --	int
								,59  --	real
								,60  --	money
								,62  --	float
								,104 --	bit
								,106 --	decimal
								,108 --	numeric
								,122 --	smallmoney
								,127 --	bigint
								)
	THEN '1' ELSE 'CASE WHEN ISNUMERIC(CAST(['+@column+'] as varchar(255))/*+''e0''*/)=1 AND ['+@column+'] IS NOT NULL THEN 1 ELSE 0 END' END+') as [c'+CAST(@columnid as varchar(5))+'_ISNUMERIC]'
SET @command31 = @command31 + '
,('''+REPLACE(@column,'''','''''')+''',''Valid numbers'',[c'+CAST(@columnid as varchar(5))+'_ISNUMERIC],CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),3)'
--4x - DoB
SET @command4 = @command4 + '
,SUM('+CASE WHEN @column_type IN(40  --	date
								,41	 -- time
								,42	 -- datetime2
								,43	 -- datetimeoffset
								,58	 -- smalldatetime
								,61	 -- datetime
								) 
		THEN 'CASE WHEN DATEDIFF(YEAR,['+@column+'],GETDATE()) > 12 THEN 1 ELSE 0 END'
	WHEN @columnLen < 6 and @column_type NOT IN(56,127) --56 = int, 127 = bigint
		THEN '0'
	ELSE 'CASE WHEN ISDATE(CAST(['+@column+'] as varchar(255)))=1 THEN CASE WHEN CAST(['+@column+'] as datetime) < DATEADD(YEAR,-12,GETDATE()) THEN 1 ELSE 0 END ELSE 0 END' 
	END+') as [c'+CAST(@columnid as varchar(5))+'_DoB]'
SET @command41 = @command41 + '
,('''+REPLACE(@column,'''','''''')+''',''Possible DoB'',[c'+CAST(@columnid as varchar(5))+'_DoB],CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),4)'
--5x - postcode
SET @command5 = @command5 + '
,SUM('+CASE WHEN @column_type IN(34	 -- image
								,36  -- uniqueidentifier
								,40  --	date
								,41  --	time
								,42  --	datetime2
								,43  --	datetimeoffset
								,48  --	tinyint
								,52  --	smallint
								,56  --	int
								,58  --	smalldatetime
								,59  --	real
								,60  --	money
								,61  --	datetime
								,62  --	float
								,98  --	sql_variant
								,104 --	bit
								,106 --	decimal
								,108 --	numeric
								,122 --	smallmoney
								,127 --	bigint
								,165 --	varbinary
								,189 --	timestamp
								,240 --	hierarchyid
								--,240 --	geometry
								--,240 --	geography
								) 
					THEN '0' 
				WHEN @columnLen < 6
					THEN '0'
				ELSE +'CASE WHEN CAST(['+@column+'] as varchar(8000)) LIKE ''%[a-Z][0-9,a-Z][ ,0-9,a-Y][ ,0-9,a-Y][ ][0-9][a-Z][a-Z]%'' THEN 1 --f8
							WHEN CAST(['+@column+'] as varchar(8000)) LIKE ''%[a-Z][0-9,a-Z][0-9,a-Y][ ][0-9][a-Z][a-Z]%'' THEN 1 --v7
							WHEN CAST(['+@column+'] as varchar(8000)) LIKE ''%[b-W][0-9][ ][0-9][a-Z][a-Z]%'' THEN 1 --v7
							ELSE 0 
							END' 
				END+') as [c'+CAST(@columnid as varchar(5))+'_Postcode]'
SET @command51 = @command51 + '
,('''+REPLACE(@column,'''','''''')+''',''Possible postcode'',[c'+CAST(@columnid as varchar(5))+'_Postcode],CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),5)'
--8x - Valid dates
SET @command8 = @command8 + '
,SUM('+CASE WHEN @column_type IN(40  --	date
								,41	 -- time
								,42	 -- datetime2
								,43	 -- datetimeoffset
								,58	 -- smalldatetime
								,61	 -- datetime
								) THEN '1'
	ELSE 'CASE WHEN ISDATE(CAST(['+@column+'] as varchar(255)))=1 THEN 1 ELSE 0 END' 
	END+') as [c'+CAST(@columnid as varchar(5))+'_ISDATE]'
SET @command41 = @command41 + '
,('''+REPLACE(@column,'''','''''')+''',''Valid dates'',[c'+CAST(@columnid as varchar(5))+'_ISDATE],CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),8)'

--- NEED THESE (6&7) TO GO INTO A ColumnValue2 & 3 FIELD!
--[2,3,4,5]y
SET @command6 = @command6 + '
,MIN('+CASE WHEN @column_type IN(34	 -- image
								,104 --	bit
								,240 --	geometry
								,240 --	geography
								,241 --	xml
								)
	THEN 'CAST(['+@column+'] as varchar(8000))' ELSE '['+@column+']' END+') as [c'+CAST(@columnid as varchar(5))+'_Min]'
/*SET @command61 = @command61 + '
,('''+REPLACE(@column,'''','''''')+''',''Minimum value'',NULL,CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),6)'*/
--[2,3,4,5]z
SET @command7 = @command7 + '
,MAX('+CASE WHEN @column_type IN(34	 -- image
								,104 --	bit
								,240 --	geometry
								,240 --	geography
								,241 --	xml
								)
	THEN 'CAST(['+@column+'] as varchar(8000))' ELSE '['+@column+']' END+') as [c'+CAST(@columnid as varchar(5))+'_Max]'
/*SET @command71 = @command71 + '
,('''+REPLACE(@column,'''','''''')+''',''Maximum value'',NULL,CAST([c'+CAST(@columnid as varchar(5))+'_Min] as varchar(255)),CAST([c'+CAST(@columnid as varchar(5))+'_Max] as varchar(255)),7)'*/

--- Loop column cursor
        FETCH NEXT FROM cursor_column INTO @column,@columnid,@column_type
END 
--- Close column cursor 
CLOSE cursor_column 
DEALLOCATE cursor_column 

---------------------------------------------------------------------------------

SET @command9 = '
FROM [' + @table + '] as t
'+@command22+'
) as p'

SET @command11 = '
CROSS APPLY (VALUES(''' + @table + ''',''Record count'',p.[Records],NULL,NULL,1)'

SET @command91 = '
			) x (ColumnName,ColumnMeasure,ColumnValue1,ColumnMin,ColumnMax,ColumnPosition)
WHERE x.ColumnMeasure IS NOT NULL
ORDER BY x.ColumnName
,x.ColumnMeasure

OPTION(RECOMPILE)
--OPTION(RECOMPILE,QUERYTRACEON 2453)
'

IF(@debug='Y')
BEGIN
PRINT @command1
PRINT @command2
PRINT @command3
PRINT @command4
PRINT @command5
PRINT @command6
PRINT @command7
PRINT @command8
PRINT @command9
PRINT @command11
PRINT @command21
PRINT @command31
PRINT @command41
PRINT @command51
--PRINT @command61
--PRINT @command71
PRINT @command81
PRINT @command91
END

---------------------------------------------------------------------------------

EXEC(@command1+@command2+@command3+@command4+@command5+@command6+@command7+@command8+@command9+@command11+@command21+@command31+@command41+@command51+@command81+@command91)

---------------------------------------------------------------------------------
--- Start next batch of columns where we left off
SET @intp = @int

	IF @intp > (select MAX(column_id) from sys.columns where OBJECT_NAME(object_id)=@table)
		BREAK
	ELSE CONTINUE

END -- End of WHILE loop

SET @command0 = '
SELECT *,CONVERT(smalldatetime,'''+@datestamp+''',113) as Datestamp  FROM ['+@tableOut+']
'
IF(@debug='Y')
BEGIN
PRINT @command0
END
exec(@command0)

SET @command0 = '
DROP TABLE ['+@tableOut+']'
IF(@debug='Y')
BEGIN
PRINT @command0
END
exec(@command0)

---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
GO