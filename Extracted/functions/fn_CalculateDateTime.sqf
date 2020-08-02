
/************************************************************
	Calculate Date
	Author: Zozo

Parameters: [start datetime, time offset (in seconds) or end datetime, time unit]
time unit:
- "s" (default) - seconds
- "m" - minutes
- "h" - hours
- "d" - days

Returns the new datetime if offset is passed or
difference between dates if end datetime is passed
(in seconds)

Example: [date, 3600] call BIS_fnc_CalculateDateTime
Example: [date, 60, "m"] call BIS_fnc_CalculateDateTime
Example: [date, [2035,8,29,11,55], "h"] call BIS_fnc_CalculateDateTime
************************************************************/
#include "DateTime.inc"
params [ ["_date1", date, [[]] ], ["_date2", date, [[],999] ], ["_timeUnit", UNIT_SECONDS, [""] ] ];
private _unit = TIME_FLOAT_CONVERT_SECONDS;

switch (_timeUnit) do
{
  case UNIT_MINUTES: 	{ _unit = TIME_FLOAT_CONVERT_MINUTES };
  case UNIT_HOURS: 		{ _unit = TIME_FLOAT_CONVERT_HOURS };
  case UNIT_DAYS: 		{ _unit = TIME_FLOAT_CONVERT_DAYS };
};

if(_date2 isEqualType 0) exitWith
{
  private _floatDate = ((dateToNumber _date1) + (1/_unit)*_date2 );
  numberToDate [(_date1 select 0) + floor _floatDate, _floatDate % 1];
};
private _year = _unit-_unit*(_date1#0-_date2#0);
private _days = _unit-(((dateToNumber _date2 - dateToNumber _date1) % 1)*_unit);
_year - _days
