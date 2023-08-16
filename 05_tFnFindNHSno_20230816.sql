USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[tFnFindNHSno] --Function name

(@string varchar(8000)) --Input variable specification

RETURNS TABLE --Output variable specification

AS RETURN
(
SELECT 
 SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10) as PossibleNHSno
,CAST(CASE 
	WHEN @string IS NULL THEN 0
	WHEN len(rtrim(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''))) < 10 THEN 0
	WHEN @string LIKE '[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]-[0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z][0-9,a-Z]' THEN 0
	WHEN PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')) = 0 THEN 0
	WHEN (CONVERT(BIGINT, SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10)) - 1) < 1000000000 
		THEN 0
	ELSE CASE WHEN CASE WHEN 11 - ((CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 1, 1)) * 10 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 2, 1)) * 9 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 3, 1)) * 8 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 4, 1)) * 7 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 5, 1)) * 6 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 6, 1)) * 5 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 7, 1)) * 4 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 8, 1)) * 3 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 9, 1)) * 2 
						 - (11 * (((CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 1, 1)) * 10 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 2, 1)) * 9 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 3, 1)) * 8 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 4, 1)) * 7 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 5, 1)) * 6 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 6, 1)) * 5 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 7, 1)) * 4 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 8, 1)) * 3 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 9, 1)) * 2) 
						 / 11))))) = 11 
							THEN 0 
						ELSE 11 - ((CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 1, 1)) * 10 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 2, 1)) * 9 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 3, 1)) * 8 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 4, 1)) * 7 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 5, 1)) * 6 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 6, 1)) * 5 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 7, 1)) * 4 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 8, 1)) * 3 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 9, 1)) * 2 
						 - (11 * (((CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 1, 1)) * 10 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 2, 1)) * 9 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 3, 1)) * 8 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 4, 1)) * 7 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 5, 1)) * 6 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 6, 1)) * 5 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 7, 1)) * 4 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 8, 1)) * 3 
								  + CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 9, 1)) * 2) 
						 / 11))))) 
						END = CONVERT(BIGINT, substring(SUBSTRING(REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-',''), PATINDEX('%[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]%',REPLACE(REPLACE(CAST(@string as varchar(255)),' ',''),'-','')),10), 10, 1)) 
			THEN 1
		ELSE 0
		END 
	END as tinyint) as PossiblyContainsNHSno -- 1 = TRUE
)
GO


