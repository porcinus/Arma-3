
/************************************************************
	Copmare two Dates
	Author: Zozo

Parameters: [date1, date2]

Returns true if the first passed datetime is newer than the second one


Example: [date, [2035,8,29,11,55] ] call BIS_fnc_IsDateTimeNewer
************************************************************/
#include "DateTime.inc"
params [ ["_date1", date, [[]] ], ["_date2", date, [[]] ]];

if( (_date1#0 == _date2#0) && {(dateToNumber _date1) - (dateToNumber _date2) > 0} ) then
{ true }
else
{
	if(_date1#0 > _date2#0) exitWith {true};
	false
}
