
/************************************************************
	Compare two Dates
	Author: Zozo

Parameters: [date1, date2]

Returns the newer date or returns the input if dates are identical


Example: [date, [2035,8,29,11,55] ] call BIS_fnc_CompareDateTimes
************************************************************/
#include "DateTime.inc"
params [ ["_date1", date, [[]] ], ["_date2", date, [[]] ]];

if( _date1#0 == _date2#0 ) then
{
	if( (dateToNumber _date1) - (dateToNumber _date2) >= 0 ) then { _date1 } else { _date2 }
}
else
{
	if( _date1#0 > _date2#0 ) then { _date1 } else { _date2 }
}
