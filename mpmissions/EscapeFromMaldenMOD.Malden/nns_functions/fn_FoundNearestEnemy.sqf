/*
NNS
Found and return nearest "man" enemy (visible or not from unit), only support west and east.

Example: _tmp_nearest_enemy = [player,800] call NNS_fnc_FoundNearestEnemy;

*/

params
[
	["_unit",objNull],
	["_radius",400]
];

if (_unit isEqualTo objNull) exitWith {["NNS_fnc_FoundNearestEnemy : Object needed"] call NNS_fnc_debugOutput;};

_enemyside = side _unit;
if (side _unit == west) then {_enemyside = east;} else {_enemyside = west;}; //enemy side

_tmp_nearest_enemy = [];
_tmp_nearest = nearestObjects [getPos _unit, ["Man"], _radius]; //detect man objects near unit
{if((side _x == _enemyside) && (alive _x)) then {_tmp_nearest_enemy append [_x];};} foreach _tmp_nearest; //add enemy to a array

if((count _tmp_nearest_enemy) == 0) exitWith {
	[format["NNS_fnc_FoundNearestEnemy : unit:%1, Failed to detect enemy",_unit]] call NNS_fnc_debugOutput; //debug
	objNull
}; //return objNull if none found

_nearest_enemy = [_tmp_nearest_enemy, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy; //sort by distance

[format["NNS_fnc_FoundNearestEnemy : unit:%1, nearest enemy at %2m",_unit,_unit distance2d (_nearest_enemy select 0)]] call NNS_fnc_debugOutput; //debug
	
_nearest_enemy select 0