/*
NNS
Set hitpoints damage using a single array.
This function exist to limit locality problems.

Example: 
_null = [vehi01,_hitpointarray] call BIS_fnc_NNS_setAllHitPointsDamage;
[vehi01,_hitpointarray] remoteExec ["BIS_fnc_NNS_setAllHitPointsDamage",vehi01];
*/

// Params
params
[
	["_vehicle",objNull], //unit to check
	["_array",[]] //damages to apply
];

// Check for validity
if (isNull _vehicle) exitWith {[format["BIS_fnc_NNS_setAllHitPointsDamage : Non-existing unit %1 used!",_vehicle]] call BIS_fnc_NNS_debugOutput;};
if !(local _vehicle) exitWith {[format["BIS_fnc_NNS_setAllHitPointsDamage : %1 not local",_vehicle]] call BIS_fnc_NNS_debugOutput;};
if (count _array == 0) exitWith {["BIS_fnc_NNS_setAllHitPointsDamage : Empty damage array"] call BIS_fnc_NNS_debugOutput;};
if !(isDamageAllowed _vehicle) then {[format["BIS_fnc_NNS_setAllHitPointsDamage : %1 damage was disabled",_vehicle]] call BIS_fnc_NNS_debugOutput;};

_vehicle allowDamage true; //allow damage

_vehiHitCount = (count _array) - 1; //number of hitpoints
for "_i" from 0 to _vehiHitCount do { //hitpoint loop
	_vehicle setHitIndex [_i, _array select _i, false]; //apply damage
};
