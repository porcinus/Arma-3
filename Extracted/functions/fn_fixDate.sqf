/*
	Author: 
		Jiri Wainar, optimised by Killzone_Kid

	Description:
		Checks the array with date data and makes sure, the values are within the boundries

	Parameter(s):
		_this: ARRAY - date array [year, month, day, hour, minute]

	Example:
		_fixedDate = [2033,-2,89,25,75] call BIS_fnc_fixDate; //[2032,12,29,2,15]

	Returns:
		ARRAY - fixed date array [year, month, day, hour, minute]
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [0,0,0,0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_year", "_month", "_day", "_hour", "_minute"];

_minute = round _minute;
_hour = round _hour;
_day = round _day;
_month = round _month;
_year = round _year;

private _hourFix = floor (_minute / 60);
_minute = _minute - _hourFix * 60;
_hour = _hour + _hourFix;

private _dayFix = floor (_hour / 24);
_hour = _hour - _dayFix * 24;
_day = _day + _dayFix;

if (_month % 12 == 0) then 
{
	_year = _year - 1 + floor (_month / 12);
	_month = 12;
}
else
{
	private _yearFix = floor (_month / 12);
	_year = _year + _yearFix;
	_month = _month - _yearFix * 12;
};

private _monthDays = [_year, _month] call BIS_fnc_monthDays;
private _monthFix  = floor ((_day - 1) / _monthDays);

for [{private _do = true},{_do},{_monthFix = floor ((_day - 1) / _monthDays)}] do
{
	_do = call 
	{
		if (_monthFix < 0) exitWith
		{
			_month = _month - 1;
			if (_month == 0) then {_year = _year - 1; _month = 12};
			_monthDays = [_year, _month] call BIS_fnc_monthDays;
			_day = _day + _monthDays;
			
			true
		};
		
		if (_monthFix > 0) exitWith
		{
			_monthDays = [_year, _month] call BIS_fnc_monthDays;
			_day = _day - _monthDays;
			_month = _month + 1;
			if (_month > 12) then {_year = _year + 1; _month = 1};
			
			true
		};

		false
	};
};

[_year, _month, _day, _hour, _minute]