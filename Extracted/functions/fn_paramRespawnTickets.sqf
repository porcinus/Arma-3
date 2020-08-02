/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Set side respawn tickets from mission param

	Parameter(s):
	NUMBER - respawn tickets

	Returns:
	BOOL
*/

params [["_tickets", 500]];
if !(_tickets isEqualType 0) then {_tickets = 500};

if (_tickets >= 0) then 
{
	{
		if (playableSlotsNumber _x > 0) then 
		{
			[_x, _tickets] call BIS_fnc_respawnTickets;
		};
	} 
	forEach [east, west, resistance];
};

true