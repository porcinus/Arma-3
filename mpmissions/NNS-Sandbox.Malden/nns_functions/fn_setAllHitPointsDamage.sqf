/*
NNS
Set hitpoints damage using a single array.
This function exist to limit locality problems.

Example: 
_null = [vehi01,_hitpointarray] call NNS_fnc_setAllHitPointsDamage;
[vehi01,_hitpointarray] remoteExec ["NNS_fnc_setAllHitPointsDamage",vehi01];
*/

// Params
params
[
	["_vehicle",objNull], //unit to check
	["_array",[]] //damages to apply
];

// Check for validity
if (isNull _vehicle) exitWith {[format["NNS_fnc_setAllHitPointsDamage : Non-existing unit %1 used!",_vehicle]] call NNS_fnc_debugOutput;};
if !(local _vehicle) exitWith {[format["NNS_fnc_setAllHitPointsDamage : %1 not local",_vehicle]] call NNS_fnc_debugOutput;};
if (count _array == 0) exitWith {["NNS_fnc_setAllHitPointsDamage : Empty damage array"] call NNS_fnc_debugOutput;};
if !(isDamageAllowed _vehicle) then {[format["NNS_fnc_setAllHitPointsDamage : %1 damage was disabled",_vehicle]] call NNS_fnc_debugOutput;};

_vehicle allowDamage true; //allow damage

_vehiHitCount = (count _array) - 1; //number of hitpoints
for "_i" from 0 to _vehiHitCount do { //hitpoint loop
	_vehicle setHitIndex [_i, _array select _i, false]; //apply damage
};
