USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspAdmin_TableCountsPCDleakage] (@CheckHistoricArchiveTables char(1)='N',@debug varchar(1)='N') AS 

--- exec uspAdmin_TableCountsPCDleakage @CheckHistoricArchiveTables='Y',@debug='Y'

------------------------------------------------------------
--- Check the input for SQL Injection and simply exit to deny an attacker any hints. Thanks to Jeff Moden. :)

IF @CheckHistoricArchiveTables LIKE '%[^N,Y]' ESCAPE '_'
RETURN
IF @debug LIKE '%[^N,Y]' ESCAPE '_'
RETURN

------------------------------------------------------------

--DECLARE @debug		varchar(1)='Y'
DECLARE @table		varchar(512) 
DECLARE @insert		varchar(max)
DECLARE @command	varchar(max) 
DECLARE @error		varchar(2000)

IF(@debug='N')
BEGIN
SET NOCOUNT ON
END

IF NOT EXISTS(select name from sys.objects where name = 'TblAdmin_TableCountsPCDleakage')
BEGIN
CREATE TABLE TblAdmin_TableCountsPCDleakage(TableName varchar(255) NOT NULL
										   ,ColumnName varchar(255) NOT NULL
										   ,ColumnMeasure varchar(255) NOT NULL
										   ,Records BIGINT NOT NULL
										   ,PercentageOfRecords DECIMAL(8,2) NOT NULL
										   ,ColumnMin varchar(255) NULL
										   ,ColumnMax varchar(255) NULL
										   ,DateLastChecked smalldatetime NOT NULL
										   )
END

------------------------------------------------------------

--TRUNCATE TABLE TblAdmin_TableCountsPCDleakage

SELECT TableName 
INTO #tables_new
FROM TblAdmin_TableCountsPCDleakage as P
WHERE EXISTS(select 1
			 from TblLog_Imports as L
			 where p.TableName = L.TableName
				and L.ImportStartDateTime > P.DateLastChecked
			 )
GROUP BY TableName

DELETE
FROM TblAdmin_TableCountsPCDleakage
WHERE TableName IN(select TableName from #tables_new) 

INSERT INTO #tables_new(TableName)
SELECT [name]
FROM sys.objects 
WHERE [type]='U'
	AND [name] NOT IN(select TableName from #tables_new)
	AND [name] NOT IN(select TableName from TblAdmin_TableCountsPCDleakage group by TableName)

------------------------------------------------------------

DECLARE table_cursor CURSOR LOCAL FAST_FORWARD FOR 
	SELECT
	 OBJECT_NAME(so.object_id) as ObjectName
	FROM sys.objects so
	WHERE so.[type] = 'U'
		AND so.[name] <> 'TblAdmin_TableCountsPCDleakage'
		AND so.[name] IN(select TableName from #tables_new)
		AND CASE 
			WHEN so.[name] LIKE '%HistoricArchive' AND @CheckHistoricArchiveTables = 'N' THEN 0 -- Default is not to check historic archive tables
			WHEN so.[name] LIKE '%Archived[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' AND @CheckHistoricArchiveTables = 'N' THEN 0 -- Default is not to check archived tables
			ELSE 1 
			END = 1
	ORDER BY OBJECT_NAME(so.object_id)

OPEN table_cursor 
        FETCH NEXT FROM table_cursor into @table
WHILE @@FETCH_STATUS = 0 
        BEGIN 

------------------------------------------------------------

IF(@debug='Y')
BEGIN
PRINT @table
END

BEGIN TRY 


SET @command = '
IF NOT EXISTS(select 1 from ['+@table+'])
BEGIN
INSERT INTO TblAdmin_TableCountsPCDleakage(TableName,ColumnName,ColumnMeasure,Records,PercentageOfRecords,DateLastChecked) VALUES('''+@table+''',''All columns'',''Records'',0,100,''05-Jul-1948'')
END

IF EXISTS(select 1 from ['+@table+'])
BEGIN
INSERT INTO TblAdmin_TableCountsPCDleakage(TableName,ColumnName,ColumnMeasure,Records,PercentageOfRecords,ColumnMin,ColumnMax,DateLastChecked)
exec uspAdmin_DeterminePossiblePCDleakageInTableV2 @table='''+@table+''',@debug='''+@debug+'''
--exec uspAdmin_DeterminePossiblePCDleakageInTable @table='''+@table+''',@debug='''+@debug+'''
END
' 
IF(@debug='Y')
BEGIN 
PRINT @command
END
exec(@command) 

END TRY 

---Catch error (if any)
BEGIN CATCH
  PRINT 'Error detected'
SET @error =
	  (SELECT 
	/*ERROR_NUMBER() ERNumber,
	ERROR_SEVERITY() Error_Severity,
	ERROR_STATE() Error_State,
	ERROR_PROCEDURE() Error_Procedure,
	ERROR_LINE() Error_Line,*/
	ERROR_MESSAGE() Error_Message)

INSERT INTO TblAdmin_TableCountsPCDleakage(TableName,ColumnName,ColumnMeasure,Records,PercentageOfRecords,DateLastChecked) VALUES(@table,'',CAST(@error as varchar(255)),-1,100,GETDATE())

    -- Test whether the transaction is uncommittable.
    IF (XACT_STATE()) = -1
    BEGIN
    PRINT 'The transaction is in an uncommittable state. ' +
            'Rolling back transaction.'
        ROLLBACK TRANSACTION;
    END;

    -- Test whether the transaction is active and valid.
    IF (XACT_STATE()) = 1
    BEGIN
        PRINT 'The transaction is committable. ' +
            'Committing transaction.'
        COMMIT TRANSACTION;   
    END;

END CATCH

IF(@debug='Y')
BEGIN
PRINT '------------------------------------------------------------'
PRINT ''
PRINT ''
END

------------------------------------------------------------
---Close cursor 

        FETCH NEXT FROM table_cursor INTO @table
END 
CLOSE table_cursor 
DEALLOCATE table_cursor

------------------------------------------------------------

DROP TABLE #tables_new

------------------------------------------------------------

IF(@debug='Y')
BEGIN
SELECT * 
FROM TblAdmin_TableCountsPCDleakage 
END

------------------------------------------------------------
GO