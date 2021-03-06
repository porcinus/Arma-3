/*
NNS
Kill all given groups if building destroyed

Example: 
[_tower,[_grp01]] call NNS_fnc_CleanBuilding;

*/

// Params
params
[
	["_object",objNull], //object to monitor
	["_groups",[]] //goups to kill
];

// Check for validity
if (isNull _object) exitWith {["NNS_fnc_CleanBuilding : No object selected"] call NNS_fnc_debugOutput;};
if (count _groups == 0) exitWith {["NNS_fnc_CleanBuilding : No group(s) selected"] call NNS_fnc_debugOutput;};

sleep 2;

[_object,_groups] spawn {
	_object = _this select 0; //recover object
	_groups = _this select 1; //recover groups
	_object_destroyed = false; //is object destroyed
	while {!_object_destroyed} do { //loop
		if (!alive _object) then {
			{if !(isNull _x) then {{_x setDamage 1;} forEach units _x;};} forEach _groups; //groups still exist, kill all units in group
			_object_destroyed = true; //object destroyed
			sleep 10;
		};
	};
};
