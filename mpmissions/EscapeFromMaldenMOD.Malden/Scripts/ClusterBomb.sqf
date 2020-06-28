/*
NNS : Spawn a bomb, mortar or cluster bomb on wanted location

example : [_target,_pos,"mortar"] execVM 'scripts\ClusterBomb.sqf';

_target is here only for debug.
Allowed type : "mk82", "mortar", "cluster"

*/

params
[
	["_target",objNull],
	["_pos",objNull],
	["_type",objNull]
];

if (_type isEqualTo objNull) exitWith {["ClusterBomb type needed"] call NNS_fnc_debugOutput;};

_explosion_radius = 0; _explosion_count = 1;
if (_type == "mk82") then {_explosion_radius = 1; _explosion_count = 1;};
if (_type == "mortar") then {_explosion_radius = 60; _explosion_count = 10;};
if (_type == "cluster") then {_explosion_radius = 40; _explosion_count = 16;};
if (_explosion_radius==0) exitWith {["Wrong ClusterBomb type"] call NNS_fnc_debugOutput;};

for "_i" from 1 to _explosion_count do {
	if (count _pos > 1) then { // valid position
		_explosion_pos = _pos getPos [_explosion_radius * sqrt random 1, random 360];
		_explosion = grpNull;
		if (_type == "mk82") then {_explosion = "Bo_Mk82" createVehicle _explosion_pos; sleep .1;};
		if (_type == "mortar") then {_explosion = "M_Mo_82mm_AT_LG" createVehicle _explosion_pos; sleep 3;};
		if (_type == "cluster") then {_explosion = "M_Scalpel_AT" createVehicle _explosion_pos; sleep .05;};
		deleteVehicle _explosion;
	};
};
