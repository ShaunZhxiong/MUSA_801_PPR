# MUSA project data deliverables metadata

## Program data

qryMUSA-export-PPR-programs-attended-2021-with-schedules.xlsx

* FacilityID - GUID facility ID as it appears in Permit data
* Facility - Facility long name. Not identical to Facility name in Permit data
* ProgramID - unique program ID (integer)
* ActvityTypeCategory - High level categorization of activity types
* ActivityType - low level activity categorization. 
* Gender - Male, Female, or Male/Female
* AgeLow - Lowest age for whom a program is *targeted*
* AgeHigh - highest age for whom a program is *targeted*
* AttendanceWeekDate - Monday date of the week for which attendance is recorded
* RegisteredIndividualsCount - Number of registered participants in a given week (not required)
* UniqueIndividualCount - Number of unique participants who attended a program in a given week (required)
* ProgramScheduleID - unique ID for Program Schedule records. One program can have many program schedules.
* DateFrom - Schedule Start Date for a program schedule
* DateTo - Scheduled End Dat a for a program schedule
* Days - line break separated list of weekdays of a program schedule record.
* TimeFrom - start times of program on days listed in Days record
* TimeTo - end times of program on days listed in Days record



## Permit data

* FacilityID - GUID facility ID as it appears in Program data
* FacilityName - Facility short name. Not identical to name found in Program data.
* Address - Facilty Address
* ZIP - Facility ZIP code
* PublishID - Unique ID of permit.
* StartDate - Start date of a permit. Permits can have one or more schedules (start and end date)
* EndDate - End date of a permit. Permits can have one or more schedules (start and end date)
* DayNumberSunday - Day number 1-7 with Sunday as 1. 
* StartTime - Start time on day(s) in DayNumberSunday field
* EndTime -End time on day(s) in DayNumberSunday field
* ActivityTypeName - Low level permit category, similar but not identical to program data
* Category - High level permit categorization, similar but not identical to program data
* AgeText - Age group text as provided by permit applicant
* AgeLow - Low end of AgeText as coded by PPR staff
* AgeHigh - High end of AgeText as coded by PPR staff
* ExpectedGroupSizeMin - Low estimate of anticipated unique participants in Permit
* ExpectedGroupSizeMax - High estimate of anticipated unique participants in Permit
* Measure - frequency of how often ExpectedGroupSize would occur during scheduled time