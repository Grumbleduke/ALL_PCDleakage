USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[tFnFindPostcodesInString] --Function name

(@string varchar(8000)) --Input variable specification

RETURNS TABLE --Output variable specification

AS RETURN
(
SELECT 
 CAST(CASE
	WHEN @string LIKE '%[a-Z][0-9,a-Z][ ,0-9,a-Y][ ,0-9,a-Y][ ][0-9][a-Z][a-Z]%' THEN SUBSTRING(@string,PATINDEX('%[a-Z][0-9,a-Z][ ,0-9,a-Y][ ,0-9,a-Y][ ][0-9][a-Z][a-Z]%',@string),8) -- Fixed 8 characters
	WHEN @string LIKE '%[a-Z][0-9,a-Z][0-9,a-Y][ ][0-9][a-Z][a-Z]%' THEN SUBSTRING(@string,PATINDEX('%[a-Z][0-9,a-Z][0-9,a-Y][ ][0-9][a-Z][a-Z]%',@string),6) -- Variable length 7 characters
	WHEN @string LIKE '%[b-W][0-9][ ][0-9][a-Z][a-Z]%' THEN SUBSTRING(@string,PATINDEX('%[b-W][0-9][ ][0-9][a-Z][a-Z]%',@string),6) -- Variable length 6 characters
	END as varchar(128)) as PossiblePostcodeString
,CAST(CASE
		WHEN @string LIKE '%[a-Z][0-9,a-Z][ ,0-9,a-Y][ ,0-9,a-Y][ ][0-9][a-Z][a-Z]%' THEN 1 -- Fixed 8 characters
		WHEN @string LIKE '%[a-Z][0-9,a-Z][0-9,a-Y][ ][0-9][a-Z][a-Z]%' THEN 1 -- Variable length 7 characters
		WHEN @string LIKE '%[b-W][0-9][ ][0-9][a-Z][a-Z]%' THEN 1 -- Variable length 6 characters
		ELSE 0
		END as bit) as PossiblyContainsPostcode -- 1 = true.
)
GO


