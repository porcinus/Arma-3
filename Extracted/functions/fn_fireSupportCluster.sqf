/*
	Author: WattyWatts, summer 2016

	Description:
	Virtual fire support - cluster shell

	Select 0 - ARRAY or OBJECT or STRING: Target position ([x,y,z] or Object or "Marker").
	Select 1 - STRING: Ammo (you can use nil or empty string for default 40mm HEDP grenade shell).
	Select 2 - NUMBER: Radius. Default 100m.
	Select 3 - ARRAY: Number of cluster shells to be fired and submunition quantity. Default [1,20].
	Select 4 - NUMBER or ARRAY: Delay between rounds - use either #x for precise timing or [#x,#y] for setting min and max delay. Default 10 sec.
	Select 5 - (OPTIONAL) CODE: Condition to end fire support before all cluster shells are fired.
	Select 6 - (OPTIONAL) NUMBER: Safezone radius - minimal distance from the target position where cluster may be spawned at. Default is 0m.
	Select 7 - (OPTIONAL) NUMBER: Altitude where the submunition will be spawned. Default 100m.
	Select 8 - (OPTIONAL) NUMBER: Descending velocity, in m/s. Default is 100.
	Select 9 - (OPTIONAL) ARRAY: Strings of sounds to be played on the incoming submunition, default is silence.

	Returns: boolean

	EXAMPLE 1: _cluster = [BIS_Player,"G_40mm_HEDP",100,[4,10],10] spawn BIS_fnc_fireSupportCluster;
	EXAMPLE 2: _cluster = [[3600,3600,0],nil,100,[4,10],10] spawn BIS_fnc_fireSupportCluster;
	EXAMPLE 3: _cluster = ["BIS_mrkTargetArea","",100,[4,10],10,{BIS_Player distance BIS_EscapeZone < 100}] spawn BIS_fnc_fireSupportCluster;
	EXAMPLE 4: _cluster = [BIS_Player,nil,100,[4,20],10,{dayTime > 20},50] spawn BIS_fnc_fireSupportCluster;
	EXAMPLE 5: _cluster = [BIS_Victim,"G_40mm_HEDP",100,[5,25],10,{dayTime > 20},75,500,150,["shell1","shell2"]] spawn BIS_fnc_fireSupportCluster;
	EXAMPLE 6: _cluster =
	[
		BIS_Victim,
		"G_40mm_HEDP",
		100,
		[5,25],
		[5,10],
		{dayTime > 20},
		75,
		200,
		125,
		["shell1","shell2"]
	] spawn BIS_fnc_fireSupportCluster;
*/

// Params
params
[
	["_position",objNull,[objNull,[],""]],
	["_ammo","G_40mm_HEDP",[""]],
	["_radius",100,[999]],
	["_quantity",[1,20],[[]]],
	["_delay",10,[999,[]]],
	["_condition",{false},[{}]],
	["_safeZone",0,[999]],
	["_altitude",100,[999]],
	["_velocity",100,[999]],
	["_shellSounds",[""],[[]]]
];

// Check for validity
if ((_position isEqualType "") and {getMarkerType _position == ""}) exitWith {["VIRTUAL CLUSTER: Non-existent marker %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType objNull) and {isNull _position}) exitWith {["VIRTUAL CLUSTER: Non-existent object %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if ((_position isEqualType []) and {count _position != 3}) exitWith {["VIRTUAL CLUSTER: Wrong coordinates %1 for barrage used!",_position] call BIS_fnc_logFormat; false};
if (_ammo == "") then {_ammo = "G_40mm_HEDP"};
if (!(isClass (configFile >> "CfgAmmo" >> _ammo))) exitWith {["VIRTUAL CLUSTER: Non-existing ammo classname %1 for virtual fire support!",_ammo] call BIS_fnc_logFormat; false};
if (_radius < 0) exitWith {"VIRTUAL CLUSTER: radius cannot be lower than 0 meters!" call BIS_fnc_log; false};
if (_quantity select 0 < 1) exitWith {"VIRTUAL CLUSTER: At least one round must be fired!" call BIS_fnc_log; false};
if (_quantity select 1 < 2) exitWith {"VIRTUAL CLUSTER: Cluster must contain at least two pieces of submunition!" call BIS_fnc_log; false};
if ((_delay isEqualType 999) and {_delay < 0}) exitWith {"VIRTUAL CLUSTER: Delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {count _delay != 2}) exitWith {"VIRTUAL CLUSTER: Wrong format of random delay, use [#x,#y]." call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 0 < 0}) exitWith {"VIRTUAL CLUSTER: Min delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < 0}) exitWith {"VIRTUAL CLUSTER: Max delay cannot be less than 0 seconds!" call BIS_fnc_log; false};
if ((_delay isEqualType []) and {_delay select 1 < _delay select 0}) exitWith {"VIRTUAL CLUSTER: Max delay cannot be lower than min delay!" call BIS_fnc_log; false};
if (_safeZone < 0) exitWith {"VIRTUAL CLUSTER: Safezone cannot be lower than 0!" call BIS_fnc_log; false};
if (_safeZone > _radius) exitWith {"VIRTUAL CLUSTER: Safezone cannot be bigger than radius!" call BIS_fnc_logFormat; false};
if (_altitude < 0) exitWith {"VIRTUAL CLUSTER: Altitude cannot be lower than 0m!" call BIS_fnc_logFormat; false};

// Private variables, set roundsFired to 0
private ["_limit","_submunition","_roundsFired","_targetPos","_finalPos","_marker","_shell","_minDelay","_maxDelay","_finalDelay"];
_roundsFired = 0;
      _limit = _quantity select 0;
      _submunition = _quantity select 1;

// Handle delays
if (_delay isEqualType 999) then {_minDelay = _delay; _maxDelay = _delay};
if (_delay isEqualType []) then {_minDelay = _delay select 0; _maxDelay = _delay select 1};

// Log the action
// ["VIRTUAL CLUSTER: target: %1 ammo: %2 limit: %3 submunition: %4",_position, _ammo, _limit, _submunition] call BIS_fnc_logFormat;

// Fire support
While
{
	(_roundsFired < _limit)
}
Do
{
	// if the condition is triggered, stop the barrage
	if (!(isNil _condition) and (_condition)) exitWith {/*["VIRTUAL CLUSTER: Condition to end bombardment activated."] call BIS_fnc_log*/};

	// Getting the position - done each time to be able to track moving targets
	if (_position isEqualType "") then {_targetPos = getMarkerPos _position};
	if (_position isEqualType objNull) then {_targetPos = getPos _position};
	if (_position isEqualType []) then {_targetPos = _position};

	// Dispersing submunition
	for "_i" from 1 to _submunition do
	{
		_finalPos = [_targetPos,(random (_radius - _safeZone)) + _safeZone, random 360] call BIS_fnc_relPos;
		_shell = _ammo createVehicle [_finalPos select 0, _finalPos select 1, _altitude];
		_shell setVectorUp [0,0,-1];
		_shell setVelocity [0,0,-(abs _velocity)];
		if !(_shellSounds isEqualTo [""]) then {[_shell,(selectRandom _shellSounds)] remoteExec ["say3D"]};

		sleep 0.1;
	};

	_roundsFired = _roundsFired + 1;

	_finalDelay = _minDelay + (random (_maxDelay - _minDelay));
	sleep _finalDelay;

};

// if !(_roundsFired < _limit) then {["VIRTUAL CLUSTER: Fire mission finished, shell limit:%1 reached.",_limit] call BIS_fnc_logFormat};

// Return value
true
