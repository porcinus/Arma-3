/*
	Author: Nelson Duarte

	Description:
	Spawns object of given class and makes it travel, hooming towards the target
	To be used with CfgAmmo type of entity, but can be used with virtually any kind of object

	Parameters:
		_startPos: 		ARRAY 			The initial position of the projectile (ASL)
		_class: 		STRING or OBJECT	The class name of the object to spawn or an object entity already existing
		_target:		OBJECT			The target object the projectile will be hooming towards to
		_speed:			SCALAR			The speed the object should assume
		_destroyTarget:		BOOL			Whether to force destruction of the target object on detonation
		_localOffset:		ARRAY			The model space position offset that projectile should be hooming towards to
		_minDistanceToTarget:	SCALAR			The minimal distance projectile needs to be from target position to enter ballistic mode
		_function		STRING			The function to execute on the created object with params [<object>]
		_isGlobalFunction	BOOL			Whether the executed function should be executed on all connected machine, false to execute only on the server

	Returns:
		NOTHING
*/

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Can only be run on the server
if (!isServer) exitWith
{
	"fn_guidedProjectile should run on the server" call BIS_fnc_error;
};

// Can only be run on scheduled env
if (!canSuspend) exitWith
{
	"fn_guidedProjectile should run on Scheduled Env" call BIS_fnc_error;
};

// Parameters
params
[
	["_startPos", [0.0 , 0.0, 0.0], [[]]],
	["_class", "M_Titan_AT", ["", objNull]],
	["_target", objNull, [objNull]],
	["_speed", 100.0, [0.0]],
	["_destroyTarget", true, [true]],
	["_localOffset", [0.0, 0.0, 0.0], [[]]],
	["_minDistanceToTarget", 5.0, [0.0]],
	["_function", "", [""]],
	["_isGlobalFunction", false, [true]]
];

// Validate parameters
if (count _startPos != 3 || {{typeName _x != typeName 0} count _startPos > 0}) exitWith {"fn_guidedProjectile invalid position, not a 3D vector" call BIS_fnc_error};
if (_startPos isEqualTo [0,0,0]) exitWith {"fn_guidedProjectile invalid position, at 0,0,0" call BIS_fnc_error};
if (typeName _class == typeName "" && {_class == ""}) exitWith {"fn_guidedProjectile invalid class provided" call BIS_fnc_error};
if (typeName _class == typeName objNull && {isNull _class}) exitWith {"fn_guidedProjectile invalid object provided" call BIS_fnc_error};
if (isNull _target) exitWith {"fn_guidedProjectile invalid target provided" call BIS_fnc_error};

// Create the projectile
private _rocket = if (typeName _class == typeName "") then {createVehicle [_class, _startPos, [], 0, "CAN_COLLIDE"]} else {_class};

// Make sure creation was succeeded
if (isNull _rocket) exitWith
{
	["fn_guidedProjectile could not spawn rocket of class %1 at %2", _class, _startPos] call BIS_fnc_error;
};

// Call function if requested
if (_function != "" && {call compile format["!isNil {%1}", _function]}) then
{
	[_rocket] remoteExec [_function, if (_isGlobalFunction) then {0} else {2}];
};

// Set correct initial position
_rocket setPosASL _startPos;

// Loop
while {!isNull _rocket && {!isNull _target}} do
{
	private _currentPos = getPosASLVisual _rocket;
	private _targetPos = if !(_localOffset isEqualTo [0.0, 0.0, 0.0]) then {AGLToASL (_target modelToWorldVisual _localOffset)} else {getPosASLVisual _target};

	private _forwardVector = vectorNormalized (_targetPos vectorDiff _currentPos);
	private _rightVector = (_forwardVector vectorCrossProduct [0,0,1]) vectorMultiply -1;
	private _upVector = _forwardVector vectorCrossProduct _rightVector;

	private _targetVelocity = _forwardVector vectorMultiply _speed;

	_rocket setVectorDirAndUp [_forwardVector, _upVector];
	_rocket setVelocity _targetVelocity;

	if (isNull _rocket || {isNull _target} || {getPosASLVisual _rocket distance _targetPos <= _minDistanceToTarget}) exitWith
	{
		if (!isNull _rocket) then {_rocket setDamage 1; _rocket = objNull;};
		if (_destroyTarget && {!isNull _target}) then {_target setDamage 1;};
	};

	sleep 0.01;
};