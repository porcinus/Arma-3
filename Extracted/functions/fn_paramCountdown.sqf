/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Set side mission time from mission param

	Parameter(s):
	NUMBER - time (in seconds)

	Returns:
	BOOL
*/

params [["_countdown", -1]];
if !(_countdown isEqualType 0) then {_countdown = -1};

if (isServer && _countdown >= 0) then
{ 
	_countdown spawn 
	{
		waitUntil {time > 0};
		estimatedTimeLeft _this;
	};
};

true