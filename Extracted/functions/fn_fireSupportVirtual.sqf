/*
	Author: Vaclav "Watty Watts" Oliva

	Description:
	Virtual fire support of artillery/mortar unit.

	Parameters:
	Select 0 - ARRAY or OBJECT or STRING: Target position ([x,y,z] or Object or "Marker")
	Select 1 - STRING: Ammo (you can use nil or empty string for default 82mm mortar)
	Select 2 - NUMBER: Radius
	Select 3 - NUMBER: Number of rounds to be fired
	Select 4 - NUMBER or ARRAY: Delay between rounds - use either #x for precise timing or [#x,#y] for setting min and max delay
	Select 5 - (OPTIONAL) CODE: Condition to end bombardment before all rounds are fired
	Select 6 - (OPTIONAL) NUMBER: Safezone radius - minimal distance from the target position where shells may be fired at
	Select 7 - (OPTIONAL) NUMBER: Altitude where the shell will be created, default 250
	Select 8 - (OPTIONAL) NUMBER: Descending velocity, in m/s. Default is 150, if you use flare as ammo, set it to lower value (1-5) to let it fall down slowly
	Select 9 - (OPTIONAL) ARRAY: String of sounds to be played on the incoming shell, default is silence

	Returns:
	Boolean

	Examples:
	_barrage = [BIS_Player,"Sh_82mm_AMOS",100,24,10] spawn BIS_fnc_fireSupportVirtual;
	_barrage = [[3600,3600,0],nil,100,24,10] spawn BIS_fnc_fireSupportVirtual;
	_barrage = ["BIS_mrkTargetArea","",100,24,10,{BIS_Player distance BIS_EscapeZone < 100}] spawn BIS_fnc_fireSupportVirtual;
	_barrage = [BIS_Player,nil,100,24,10,{dayTime > 20},50] spawn BIS_fnc_fireSupportVirtual;
	_barrage = [BIS_Victim,"Sh_82mm_AMOS",100,24,10,{dayTime > 20},75,500,200,["mortar1","mortar2"]] spawn BIS_fnc_fireSupportVirtual;
	_barrage = [
		BIS_Victim,
		"Sh_82mm_AMOS",
		100,
		24,
		[10,20],
		{dayTime > 20},
		75,
		500,
		200,
		["mortar1","mortar2"]
	] spawn BIS_fnc_fireSupportVirtual;
*/

// Params
params
[
	["_position",objNull,[objNull,[],""]],
	["_ammo","Sh_82mm_AMOS",[""]],
	["_radius",100,[999]],
	["_limit",10,[999]],
	["_delay",10,[999,[]]],
	["_condition",{false},[{}]],
	["_safeZone",0,[999]],
	["_altitude",250,[999]],
	["_velocity",150,[999]],
	["_shellSounds",[""],[[]]]
];

// Check for validity
if ((_position isEqualType "") and {getMarkerType _position == ""}) exitWith {["VIRTUAL ARTILLERY SUPPORT: Non-existent marker %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType objNull) and {isNull _position}) exitWith {["VIRTUAL ARTILLERY SUPPORT: Non-existent object %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType []) and {count _position != 3}) exitWith {["VIRTUAL ARTILLERY SUPPORT: Wrong coordinates %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if (_ammo == "") then {_ammo = "Sh_82mm_AMOS"};
if (!(isClass (configFile >> "CfgAmmo" >> _ammo))) exitWith {["VIRTUAL ARTILLERY SUPPORT: Non-existing ammo classname %1 for virtual fire support!",_ammo] call BIS_fnc_logFormat; false};
if (_radius < 0) exitWith {"VIRTUAL ARTILLERY SUPPORT: radius cannot be lower than 0 meters!" call BIS_fnc_log; false};
if (_limit < 1) exitWith {"VIRTUAL ARTILLERY SUPPORT: At least one round must be fired!" call BIS_fnc_log; false};
if ((_delay isEqualType 999) and {_delay < 0}) exitWith {"VIRTUAL ARTILLERY SUPPORT: Delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {count _delay != 2}) exitWith {"VIRTUAL ARTILLERY SUPPORT: Wrong format of random delay, use [#x,#y]." call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 0 < 0}) exitWith {"VIRTUAL ARTILLERY SUPPORT: Min delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < 0}) exitWith {"VIRTUAL ARTILLERY SUPPORT: Max delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < _delay select 0}) exitWith {"VIRTUAL ARTILLERY SUPPORT: Max delay cannot be lower than min delay!" call BIS_fnc_log; false};
if (_safeZone < 0) exitWith {"VIRTUAL ARTILLERY SUPPORT: Safezone cannot be lower than 0!" call BIS_fnc_log; false};
if (_safeZone > _radius) exitWith {"VIRTUAL ARTILLERY SUPPORT: Safezone cannot be bigger than radius!" call BIS_fnc_logFormat; false};
if (_altitude < 0) exitWith {"VIRTUAL ARTILLERY SUPPORT: Altitude cannot be lower than 0m!" call BIS_fnc_logFormat; false};

// Private variables, set roundsFired to 0
private ["_roundsFired","_targetPos","_finalPos","_marker","_shell","_minDelay","_maxDelay","_finalDelay"];
_roundsFired = 0;

// Handle delays
if (_delay isEqualType 999) then {_minDelay = _delay; _maxDelay = _delay};
if (_delay isEqualType []) then {_minDelay = _delay select 0; _maxDelay = _delay select 1};

// Log the action
// ["VIRTUAL ARTILLERY SUPPORT: target: %1 ammo: %2 limit: %3",_position, _ammo, _limit] call BIS_fnc_logFormat;

// Fire support
while
{
	(_roundsFired < _limit)
}
do
{
	// if the condition is triggered, stop the barrage
	if (!(isNil _condition) and (_condition)) exitWith {/*["VIRTUAL ARTILLERY SUPPORT: Condition to end bombardment activated."] call BIS_fnc_log*/};

	// Getting the position - done each time to be able to track moving targets
	if (_position isEqualType "") then {_targetPos = getMarkerPos _position};
	if (_position isEqualType objNull) then {_targetPos = getPos _position};
	if (_position isEqualType []) then {_targetPos = _position};

	// Selecting the final position where the AI should fire
	_finalPos = [_targetPos,(random (_radius - _safeZone)) + _safeZone, random 360] call BIS_fnc_relPos;
	_shell = _ammo createVehicle [_finalPos select 0, _finalPos select 1, _altitude];
	_shell setVectorUp [0,0,-1];
	_shell setVelocity [0,0,-(abs _velocity)];
	_roundsFired = _roundsFired + 1;

	if !(_shellSounds isEqualTo [""]) then {[_shell,(selectRandom _shellSounds)] remoteExec ["say3D"]};

	_finalDelay = _minDelay + (random (_maxDelay - _minDelay));
	sleep _finalDelay;
};

// if !(_roundsFired < _limit) then {["VIRTUAL ARTILLERY SUPPORT: Fire mission finished, shell limit:%1 reached.",_limit] call BIS_fnc_logFormat};

// Return
true
