USE [DatabaseName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[tFnFindDatesInString] --Function name

(@string varchar(8000)) --Input variable specification

RETURNS TABLE --Output variable specification

AS RETURN
(
SELECT 
 CAST(CASE
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].0000000%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].0000000%',@string),27) -- 120 = yyyy-mm-dd hh:mi:ss(24h)
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [1,2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[a-Z][a-Z][a-Z] [0-3][0-9] [1,2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),26) -- 109 = mon dd yyyy hh:mi:ss:mmmAM (or PM)
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),26) -- 130 = dd mon yyyy hh:mi:ss:mmmAM )-- Stating 130 causes error!
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%',@string),24) -- 113 = dd mon yyyy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]Z%' 
		THEN SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]Z%',@string),24) -- 127 = yyyy-mm-ddThh:mi:ss.mmmZ
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[a-Z][a-Z][a-Z] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),24) -- 9 = mon dd yy hh:mi:ss:mmmAM (or PM)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),23) -- 121 = yyyy-mm-dd hh:mi:ss.mmm(24h)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),23) -- 126 = yyyy-mm-ddThh:mi:ss.mmm (no spaces)
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),23) -- 131 = dd/mm/yy hh:mi:ss:mmmAM )-- Bombs out with error!
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%',@string),22) -- 13 = dd mon yy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),21) -- 21 = yy-mm-dd hh:mi:ss.mmm(24h) )-- Stating 21 causes error!
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]%',@string),20) -- 113 = dd mon yyyy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9] [A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9] [A,P]M%',@string),20) -- 22 = mm/dd/yy hh:mi:ss AM (or PM)
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%',@string),19) --100 = mon dd yyyy hh:miAM (or PM)
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),19) -- 120 = yyyy-mm-dd hh:mi:ss(24h)
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),19) -- 211 = 103+108
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' 
		THEN SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%',@string),17) -- 0 = mon dd yy hh:miAM (or PM)
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),17) -- 20 = yy-mm-dd hh:mi:ss(24h) )-- Stating 20 causes error!
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]%',@string),16) -- 211 = --103+108 = dd/mm/yyyy + hh:mi:ss
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-2][0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-2][0-9][0-9][0-9]%',@string),12) -- 107 = Mon dd, yyyy
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9]%',@string),12) -- 114 = hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-2][0-9][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-2][0-9][0-9][0-9]%',@string),11) -- 106 = dd mon yyyy
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-9][0-9]%',@string),10) -- 7  7 = Mon dd, yy
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-2][0-9][0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9].[0,1][0-9].[0-2][0-9][0-9][0-9]%',@string),10) -- 104 = dd.mm.yyyy
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9]%',@string),10) -- 103 = dd/mm/yyyy
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-2][0-9][0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]-[0,1][0-9]-[0-2][0-9][0-9][0-9]%',@string),10) -- 105 = dd-mm-yyyy
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9].[0,1][0-9].[0-3][0-9]%',@string),10) -- 102 = yyyy.mm.dd
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]/[0,1][0-9]/[0-3][0-9]%',@string),10) -- 111 = yyyy/mm/dd
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-2][0-9][0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-2][0-9][0-9][0-9]%',@string),10) -- 101 = mm/dd/yyyy
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-9][0-9]%' 
		THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-9][0-9]%',@string),9) -- 6 = dd mon yyyy
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9][0,1][0-9][0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9][0,1][0-9][0-3][0-9]%',@string),8) -- 112 = yyyymmdd
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9].[0,1][0-9].[0-9][0-9]%',@string),8) -- 4 = dd.mm.yy
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-9][0-9]%',@string),8) -- 3 = dd/mm/yy
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-3][0-9]-[0,1][0-9]-[0-9][0-9]%',@string),8) -- 5 = dd-mm-yy
	WHEN @string LIKE '%[0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-9][0-9]/[0,1][0-9]/[0-3][0-9]%',@string),8) -- 11 = yy/mm/dd
	WHEN @string LIKE '%[0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-9][0-9].[0,1][0-9].[0-3][0-9]%',@string),8) -- 2 = yy.mm.dd
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-9][0-9]%',@string),8) -- 1 = mm/dd/yy
	WHEN @string LIKE '%[0,1][0-9]-[0-3][0-9]-[0-9][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0,1][0-9]-[0-3][0-9]-[0-9][0-9]%',@string),8) -- 10 = mm-dd-yy
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),8) -- 108 = hh:mi:ss
	WHEN @string LIKE '%[0-9]:[0-5][0-9]:[0-5][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-9]:[0-5][0-9]:[0-5][0-9]%',@string),7) -- 108 = hh:mi:ss - leading zero truncated
	WHEN @string LIKE '%[0-9][0-9][0,1][0-9][0-3][0-9]%' THEN SUBSTRING(@string,PATINDEX('%[0-9][0-9][0,1][0-9][0-3][0-9]%',@string),6) -- 12 = yymmdd
	END as varchar(128)) as DateAsString
,CAST(CASE 
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].0000000%' THEN 120
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [1,2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' THEN 109
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' THEN 130
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]%' THEN 113
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]Z%' THEN 127
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' THEN 9
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' THEN 121
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' THEN 126
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' THEN 131
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' THEN 13
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' THEN 21
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' THEN 113
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9] [A,P]M%' THEN 22
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' THEN 100
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' THEN 120 --19 character version
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' THEN 0
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' THEN 20
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]%' THEN 211 -- 103+108
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-2][0-9][0-9][0-9]%' THEN 107
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9]%' THEN 114
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-2][0-9][0-9][0-9]%' THEN 106
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-9][0-9]%' THEN 7
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-2][0-9][0-9][0-9]%' THEN 104
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9]%' THEN 103
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-2][0-9][0-9][0-9]%' THEN 105
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN 102
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN 111
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-2][0-9][0-9][0-9]%' THEN 101
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-9][0-9]%' THEN 6
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9][0,1][0-9][0-3][0-9]%' THEN 112
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-9][0-9]%' THEN 4
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9]%' THEN 3
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-9][0-9]%' THEN 5
	WHEN @string LIKE '%[0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN 11
	WHEN @string LIKE '%[0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN 2
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9]%' THEN 1
	WHEN @string LIKE '%[0,1][0-9]-[0-3][0-9]-[0-9][0-9]%' THEN 10
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' THEN 108
	WHEN @string LIKE '%[0-9]:[0-5][0-9]:[0-5][0-9]%' THEN 108
	WHEN @string LIKE '%[0-9][0-9][0,1][0-9][0-3][0-9]%' THEN 12
	END as tinyint) as DateFormatCode -- 1 = TRUE
,CAST(CASE
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].0000000%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].0000000%',@string),27),120) -- yyyy-mm-dd hh:mi:ss(24h)
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [1,2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[a-Z][a-Z][a-Z] [0-3][0-9] [1,2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),26),109) -- mon dd yyyy hh:mi:ss:mmmAM (or PM)
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),26),130) -- dd mon yyyy hh:mi:ss:mmmAM )
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%',@string),24),113) -- dd mon yyyy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]Z%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]Z%',@string),24),127) -- yyyy-mm-ddThh:mi:ss.mmmZ
	WHEN @string LIKE '%[a-Z][a-Z][a-Z] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[a-Z][a-Z][a-Z] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),24),9) -- mon dd yy hh:mi:ss:mmmAM (or PM)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),23),121) -- yyyy-mm-dd hh:mi:ss.mmm(24h)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9]T[0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),23),126) -- yyyy-mm-ddThh:mi:ss.mmm (no spaces)
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-9][0-9] [0,1][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9][A,P]M%',@string),23),131) -- dd/mm/yy hh:mi:ss:mmmAM )
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]:[0-9][0-9][0-9]%',@string),22),13) -- dd mon yy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9].[0-9][0-9][0-9]%',@string),21),21) -- yy-mm-dd hh:mi:ss.mmm(24h) )
	WHEN @string LIKE '%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9] [a-Z][a-Z][a-Z] [1,2][0-9][0-9][0-9] [0-9][0-9]:[0-9][0-9]:[0-9][0-9]%',@string),20),113) -- dd mon yyyy hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-2][0-9][0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%',@string),19),100) -- mon dd yyyy hh:miAM (or PM)
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),19),120) -- yyyy-mm-dd hh:mi:ss(24h)
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),19),211) -- --103+108) -- dd/mm/yyyy + hh:mi:ss
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9] [0-9][0-9] [ ,0,1][0-9]:[0-5][0-9][A,P]M%',@string),17),0) -- mon dd yy hh:miAM (or PM)
	WHEN @string LIKE '%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9][0-9]-[0,1][0-9]-[0-3][0-9] [0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),17)+'.0000000',120) -- 20 = yy-mm-dd hh:mi:ss(24h) )
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-2][0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-2][0-9][0-9][0-9]%',@string),12),107) -- Mon dd, yyyy
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]:[0-9][0-9][0-9]%',@string),12),114) -- hh:mi:ss:mmm(24h)
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-2][0-9][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-2][0-9][0-9][0-9]%',@string),11),106) -- dd mon yyyy
	WHEN @string LIKE '%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y] [0-3][0-9], [0-9][0-9]%',@string),10),7) -- Mon dd, yy
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-2][0-9][0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9].[0,1][0-9].[0-2][0-9][0-9][0-9]%',@string),10),104) -- dd.mm.yyyy
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-2][0-9][0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]-[0,1][0-9]-[0-2][0-9][0-9][0-9]%',@string),10),105) -- dd-mm-yyyy
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9].[0,1][0-9].[0-3][0-9]%',@string),10),102) -- yyyy.mm.dd
	WHEN @string LIKE '%[0-2][0-9][0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9][0-9][0-9]/[0,1][0-9]/[0-3][0-9]%',@string),10),111) -- yyyy/mm/dd
	WHEN @string LIKE '%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-9][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9][ ,-][A,D,F,J,M,N,O,S][a,c,e,o,p,u][b,c,g,l,n,p,r,t,v,y][ ,-][0-9][0-9]%',@string),9),6) -- mon dd yy hh:mi:ss:mmmAM (or PM)
	WHEN @string LIKE '%[1,2][0-9][0-9][0-9][0,1][0-9][0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[1,2][0-9][0-9][0-9][0,1][0-9][0-3][0-9]%',@string),8),112) -- yyyymmdd
	WHEN @string LIKE '%[0-3][0-9].[0,1][0-9].[0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9].[0,1][0-9].[0-9][0-9]%',@string),8),4) -- dd.mm.yy
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-9][0-9]%',@string),8),3) -- dd/mm/yy
	WHEN @string LIKE '%[0-3][0-9]-[0,1][0-9]-[0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]-[0,1][0-9]-[0-9][0-9]%',@string),8),5) -- dd-mm-yy
	WHEN @string LIKE '%[0-9][0-9]/[0,1][0-9]/[0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9][0-9]/[0,1][0-9]/[0-3][0-9]%',@string),8),11) -- yy/mm/dd
	WHEN @string LIKE '%[0-9][0-9].[0,1][0-9].[0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9][0-9].[0,1][0-9].[0-3][0-9]%',@string),8),2) -- yy.mm.dd
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-9][0-9]%',@string),8),1) -- mm/dd/yy
	WHEN @string LIKE '%[0,1][0-9]-[0-3][0-9]-[0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0,1][0-9]-[0-3][0-9]-[0-9][0-9]%',@string),8),10) -- mm-dd-yy
	WHEN @string LIKE '%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-2][0-9]:[0-5][0-9]:[0-5][0-9]%',@string),8),108) -- hh:mi:ss
	WHEN @string LIKE '%[0-9]:[0-5][0-9]:[0-5][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9]:[0-5][0-9]:[0-5][0-9]%',@string),7),108) -- hh:mi:ss - leading zero truncated
	WHEN @string LIKE '%[0-9][0-9][0,1][0-9][0-3][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-9][0-9][0,1][0-9][0-3][0-9]%',@string),6),12) -- yymmdd
--- Tricky ones next!
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9] [A,P]M%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-9][0-9] [ ,0,1][0-9]:[0-5][0-9]:[0-5][0-9] [A,P]M%',@string),20),22) -- mm/dd/yy hh:mi:ss AM (or PM)
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]%' 
		THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9] [0-2][0-9]:[0-5][0-9]%',@string),16)+':00',211) -- --103+108) -- dd/mm/yyyy + hh:mi:ss
	WHEN @string LIKE '%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0-3][0-9]/[0,1][0-9]/[0-2][0-9][0-9][0-9]%',@string),10),103) -- dd/mm/yyyy
	WHEN @string LIKE '%[0,1][0-9]/[0-3][0-9]/[0-2][0-9][0-9][0-9]%' THEN CONVERT(datetime,SUBSTRING(@string,PATINDEX('%[0,1][0-9]/[0-3][0-9]/[0-2][0-9][0-9][0-9]%',@string),10),101) -- mm/dd/yyyy
	END as datetime) as PossibleDate
)
GO