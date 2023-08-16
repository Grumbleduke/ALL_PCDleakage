# ALL_PCDleakage
Check for (new) personal confidential data in your data.

NOTES.

Designed to spot possible Personal Confidential Data (PCD) in any tables within the database. Any data breaches need to be reported to the relevant people and the data deleted. 

Create the objects in the numbered ordering.

The main stored procedure is dbo.uspAdmin_TableCountsPCDleakage which calls dbo.uspAdmin_DeterminePossiblePCDleakageInTableV2 and places the results in dbo.TblAdmin_TableCountsPCDleakage. Any table logged in dbo.TblLog_Imports that hasn't changed since the date last checked is excluded, as is any archived table with a name ending ArchivedCCYYMMDD (CCYYMMDD is the ISO date format). Any table ending HistoricArchive will also be skipped if the parameter @CheckHistoricArchiveTables is set to N.

To view the summary results then SELECT from the results table or to view the specific records within the appropriate table then use the following procedures:

dbo.uspAdmin_TableCountsPCDleakage_DisplayPossibleDoB
dbo.uspAdmin_TableCountsPCDleakage_DisplayPossibleNHSnumbers
dbo.uspAdmin_TableCountsPCDleakage_DisplayPossiblePostcodes

The following reference table is required to check for valid postcodes dbo.TblRefPostcodeAll with the contents of that table stored in file 03_TblRefPostcodeAll_20230816.txt (you'll have to change the path in the 03_TblRefPostcodeAll_20230816.sql script to BULK INSERT the reference data).

In addition to the reference data the following 3 table functions will also be required:

dbo.tFnFindDatesInString
dbo.tFnFindNHSno
dbo.tFnFindPostcodesInString

Personally I used to run the stored procedure dbo.uspAdmin_TableCountsPCDleakage each night to check any new data imported.
