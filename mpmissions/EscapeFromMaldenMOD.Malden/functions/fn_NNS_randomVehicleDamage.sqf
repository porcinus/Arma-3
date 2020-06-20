/*
NNS
Set random damage to vehicle hitpoint.
Specific behave, all random damage over 0.65 will be set to 1 if hitpoint doesn't contain "hull" to limit risk of vehicle explosion.

Example: 
_null = [vehicle,["hitfuel","hitengine"],0.1,0.7] call BIS_fnc_NNS_randomVehicleDamage;

Damage range:
0 -> 0.32 : white
0.33 -> 0.65 : orange
over 0.65 : red

Debug:
	Get current player vehicle hitpoint list:
		_hitpointlist = [];
		{_hitpointlist pushback _x;} foreach ((getAllHitPointsDamage (objectParent player)) select 0);
		systemChat format ["hitpoint: %1",_hitpointlist joinString ","];

	Set current player vehicle specific hitpoint damage:
		(objectParent player) setHitPointDamage ["hitpoint", damage, false];

	Experiment function on player vehicle:
		[(objectParent player),["hitfuel"],0.4,0.8] call BIS_fnc_NNS_randomVehicleDamage;

*/

// Params
params
[
	["_vehicle",objNull], //unit to check
	["_ignore",[]], //parts to keep good
	["_mindamage",0], //check interval
	["_maxdamage",1] //tolerance to trigger
];

// Check for validity
if (isNull _vehicle) exitWith {[format["BIS_fnc_NNS_randomVehicleDamage : Non-existing unit %1 used!",_vehicle]] call BIS_fnc_NNS_debugOutput;};

[format["BIS_fnc_NNS_randomVehicleDamage : %1 : ignore : %2",_vehicle,_ignore]] call BIS_fnc_NNS_debugOutput; //debug

_maxrandom = _maxdamage-_mindamage; //max random possible

{
	if !(_x in _ignore) then {
		_random = _mindamage + (random _maxrandom); //random value
		if (_random > 0.65 && {!(["hull", _x] call BIS_fnc_inString)}) then {_random = 1;}; //value over 0.65 and hitpoint not contain "hull"
		[_vehicle, [_x, _random, false]] remoteExec ["setHitPointDamage", _vehicle]; //set hitpoint damage
		//[format["BIS_fnc_NNS_randomVehicleDamage : %1 : %2 : %3",_vehicle,_x,_random]] call BIS_fnc_NNS_debugOutput; //debug
	}else{
		//[format["BIS_fnc_NNS_randomVehicleDamage : %1 : %2 ignored",_vehicle,_x]] call BIS_fnc_NNS_debugOutput; //debug
	};
} foreach ((getAllHitPointsDamage _vehicle) select 0);

objNull