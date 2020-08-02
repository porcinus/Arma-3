/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Set time of the day from mission param

	Parameter(s):
	NUMBER - daytime or hour

	Returns:
	ARRAY - date
*/

params [["_daytime", daytime]];
if !(_daytime isEqualType 0) then {_daytime = daytime};

private _date = date;

if (isServer) then
{
	_date set [3, floor _daytime];
	_date set [4, 0];
	setDate _date;
};

_date