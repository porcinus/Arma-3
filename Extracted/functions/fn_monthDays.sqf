/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Returns number of days in given month. Takes in account for leap year.

	Parameter(s):
	_this select 0: SCALAR - year; a non-decimal number
	_this select 1: SCALAR - month; a non-decimal number between 1-12

	Example:
	_days = [2035,7] call BIS_fnc_monthDays;

	Returns:
	SCALAR - number of days in given month
*/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_year", "_month"];

private _data = [31,28,31,30,31,30,31,31,30,31,30,31];
if (_year call BIS_fnc_isLeapYear) then {_data set [1, 29]};

_data select (0 max (floor _month - 1) min 11)