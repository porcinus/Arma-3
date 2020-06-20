/*
NNS
Set random damage to vehicle hitpoint.
Specific behave, all random damage over 0.65 will be set to 1 if hitpoint doesn't contain "hull" to limit risk of vehicle explosion.
Work in parallel with NNS_fnc_setAllHitPointsDamage via remoteExec.

Example: 
_null = [vehicle,["hitfuel","hitengine"],0.1,0.7] call NNS_fnc_randomVehicleDamage;

Damage range:
0 -> 0.32 : white
0.33 -> 0.65 : orange
over 0.65 : red

Debug:
	Get current player vehicle hitpoint list:
		_hitpointlist = [];
		{_hitpointlist pushback _x;} foreach ((getAllHitPointsDamage (objectParent player)) select 0);
		systemChat format ["hitpoint: %1",_hitpointlist joinString ","];
		diag_log format ["hitpoint: %1",_hitpointlist joinString ","];
		
	Set current player vehicle specific hitpoint damage:
		(objectParent player) setHitPointDamage ["hitpoint", damage, false];

	Experiment function on player vehicle:
		[(objectParent player),["hitfuel"],0.4,0.8] call NNS_fnc_randomVehicleDamage;

*/

// Params
params [
	["_vehicle",objNull], //unit to check
	["_ignore",[]], //parts to keep good
	["_mindamage",0], //min damage to apply
	["_maxdamage",1] //max damage to apply
];

// Check for validity
if (isNull _vehicle) exitWith {[format["NNS_fnc_randomVehicleDamage : Non-existing unit %1 used!",_vehicle]] call NNS_fnc_debugOutput;};

[format["NNS_fnc_randomVehicleDamage : %1 : ignore : %2",_vehicle,_ignore]] call NNS_fnc_debugOutput; //debug

_maxrandom = _maxdamage-_mindamage; //max random possible

_vehiHit = getAllHitPointsDamage _vehicle; //get vehicle hitpoints array

if (count _vehiHit == 0) exitWith {[format["NNS_fnc_randomVehicleDamage : %1 : No hitpoint detected",_vehicle]] call NNS_fnc_debugOutput;};

_vehiHitName = _vehiHit select 0; //extract hitpoints name array
_vehiHitCount = (count _vehiHitName) - 1; //number of hitpoints
_vehiHitNew = []; //array to send to client

for "_i" from 0 to _vehiHitCount do { //hitpoint loop
	_damage = 0; //reset damage value
	_name = _vehiHitName select _i; //extract name of current hitpoint
	if !(_name in _ignore) then {
		_damage = _mindamage + (random _maxrandom); //random value
		if (_damage > 0.65 && {!(["hull", _name] call BIS_fnc_inString)}) then {_damage = 1;}; //value over 0.65 and hitpoint not contain "hull"
	};
	_vehiHitNew pushBack _damage; //add new damage to array
};

//[_vehicle,_vehiHitNew] remoteExec ["NNS_fnc_setAllHitPointsDamage"];
[_vehicle, _vehiHitNew] remoteexec ['NNS_fnc_setAllHitPointsDamage',_vehicle];

_vehiHitNew