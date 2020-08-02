/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Set overcast from mission param

	Parameter(s):
	NUMBER - overcast

	Returns:
	NUMBER - overcast
*/

params [["_overcast", 0]];
if !(_overcast isEqualType 0) then {_overcast = 0};

if (isServer) then
{
	0 setOvercast (_overcast * 0.01);
	forceWeatherChange;
};

_overcast