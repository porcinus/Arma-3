/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Set relationship between Independents and remaining sides from mission param

	Parameter(s):
	NUMBER - side relation
		-1: Nobody
		0: OPFOR
		1: BLUFOR
		2: Everybody

	Returns:
	BOOL
*/

params [["_status", -1]];
if !(_status isEqualType 0) then {_status = -1};

if (isServer) then
{
	private _east = 0;
	private _west = 0;

	switch _status do 
	{
		case 0: {_east = 1};
		case 1: {_west = 1};
		case 2: {_east = 1; _west = 1};
		default {};
	};

	east setFriend [resistance, _east];
	resistance setFriend [east, _east];
	west setFriend [resistance, _west];
	resistance setFriend [west, _west];
};

true