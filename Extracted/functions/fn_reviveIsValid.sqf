#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Check if player can perform revive action on given unit.

	Parameters:
	0: OBJECT - unconscious unit

	Returns:
	BOOL - is player able to revive the unit and is the unit revivable?

	Example:
	_reviveIsValid = [_unit] call bis_fnc_reviveIsValid;
*/

params
[
	["_unit",objNull,[objNull]]
];

//no valid unit or required key is not pressed
if (isNull _unit) exitWith {false};

//check distance
if (player distance _unit > REVIVE_DISTANCE) exitWith {false};

//check validity of player
if (IN_VEHICLE(player) || {REVIVE_ALLOWED2(player,_unit) < 0}) exitWith {false};

//check side; can revive only friendlies
if (side group player getFriend side group _unit < 0.6) exitWith {false};

//check life state
if (lifeState _unit != "INCAPACITATED" || {!IS_DISABLED(_unit)}) exitWith {false};

//check positioning
_pos = unitAimPositionVisual _unit;
_dist = (_pos distance player) max 1;

if (_dist > REVIVE_DISTANCE_BODY_CENTER) exitWith {false};

//get position on the screen & exit if it is not on the screen
_pos = worldToScreen _pos; if (count _pos == 0) exitWith {false};

//unit must be in the center of the screen
/*
_pos set [2,0];
if (_pos distance [0.5,0.5,0] > 2/_dist) exitWith {false};
*/

true