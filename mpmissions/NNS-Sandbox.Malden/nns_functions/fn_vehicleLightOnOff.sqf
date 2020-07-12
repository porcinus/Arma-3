/*
NNS
Search all hitpoint containing "light" for a given vehicles and destroy/restore them.
Used to try to "fix" vehicles headlight flickering when hit by zombie or server desync.
Designed to work locally, to be used with remoteExec.

Example: 
_null = [vehicle,"ON"] call NNS_fnc_vehicleLightOnOff;
_null = [vehicle,"OFF"] call NNS_fnc_vehicleLightOnOff;


Debug:
	Experiment function on player vehicle:
		[(objectParent player),"ON"] call NNS_fnc_vehicleLightOnOff;
		[(objectParent player),"OFF"] call NNS_fnc_vehicleLightOnOff;

*/

// Params
params
[
	["_vehicle", objNull], //vehicle to work on
	["_command", "ON"] //on/off
];

_command = toUpper _command; //uppercase the command

// Check for validity
if (isNull _vehicle) exitWith {[format["NNS_fnc_vehicleLightOnOff : Non-existing vehicle %1 used!",_vehicle]] call NNS_fnc_debugOutput;};
if !(local _vehicle) exitWith {[format["NNS_fnc_vehicleLightOnOff : %1 not local",_vehicle]] call NNS_fnc_debugOutput;};
if (_command != "ON" && _command != "OFF") exitWith {['NNS_fnc_vehicleLightOnOff : Wrong command given, only accept "ON"/"OFF"'] call NNS_fnc_debugOutput;};

_damage = [1,0] select (_command == "ON"); //damage to apply

_vehiHit = getAllHitPointsDamage _vehicle; //get vehicle hitpoints array
if (count _vehiHit < 2) exitWith {["NNS_fnc_vehicleLightOnOff : Failed to get hitpoints array"] call NNS_fnc_debugOutput};

_vehiHitName = _vehiHit select 0; //extract hitpoints name array
_vehiHitNew = _vehiHit select 2; //array to send to client
_vehiHitCount = (count _vehiHitName) - 1; //number of hitpoints

for "_i" from 0 to _vehiHitCount do { //hitpoint loop
	if (["light", toLower (_vehiHitName select _i), true] call BIS_fnc_inString) then {_vehiHitNew set [_i,_damage]}; //hitpoint contain "light", set wanted damage
};

[_vehicle,_vehiHitNew] remoteExec ["NNS_fnc_setAllHitPointsDamage",_vehicle];

_vehiHitNew