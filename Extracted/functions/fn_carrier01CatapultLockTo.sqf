/*
	Author: Jiri Wainar

	Description:
	Moves player aircraft through interpolation to given catapult and once there locks it there.

	Parameter(s):
		0: carrier part containing the catapult
		1: name of catapult memory point
		2: direction offset of the catapult relative to carrier part direction

	Returns:
	Nothing.

	Example:
	[_part,_memPoint,_dirOffset] call bis_fnc_carrier01CatapultLockTo;
*/

#include "defines.inc"

#define INTERPOLATION_MOVE_SPEED		5				//in meters/second
#define INTERPOLATION_TURN_SPEED		15				//in degrees/second
#define INTERPOLATION_STEP_LENGTH		0.001			//smoothness of the interpolation

private _plane = cameraOn; if (player == _plane) exitWith {};

//terminate if plane is attached to something
if (!isNull attachedTo _plane) exitWith {};

params
[
	["_part", objNull],
	["_memPoint", ""],
	["_dirOffset", 0]
];

private _posStart = getPosWorld _plane;
private _height = _posStart select 2;
private _posCatapult = _part modelToWorld (_part selectionPosition _memPoint); _posCatapult set [2, _height];

private _vectorUp = vectorUp _plane;

private _posDelta = [_posCatapult,_posStart] call BIS_fnc_vectorDiff;
private _distance = (_posStart distance2D _posCatapult) max 0.1;

private _dirStart = (getDir _plane) % 360;
private _dirCatapult = (getDir _part - _dirOffset - 180) % 360;
private _dirDelta = (_dirCatapult - _dirStart) % 360;

if (_dirDelta < -180) then
{
	_dirDelta = _dirDelta + 360;
}
else
{
	if (_dirDelta > 180) then {_dirDelta = _dirDelta - 360;};
};

/*
["[ ] _dirStart: %1",_dirStart] call bis_fnc_logFormat;
["[ ] _dirCatapult: %1",_dirCatapult] call bis_fnc_logFormat;
["[ ] _dirDelta: %1",_dirDelta] call bis_fnc_logFormat;

["[ ] _posCatapult: %1",_posCatapult] call bis_fnc_logFormat;
["[ ] _posStart: %1",_posStart] call bis_fnc_logFormat;
["[ ] _posCatapult: %1",_posCatapult] call bis_fnc_logFormat;

["[ ] _distance: %1",_distance] call bis_fnc_logFormat;
*/

//private _velocity = [_posDelta,INTERPOLATION_MOVE_SPEED/_distance] call BIS_fnc_vectorMultiply;

private _timeMax = 0.75 * (getNumber(missionConfigFile >> "CfgCarrier" >> "LaunchSettings" >> "duration") max 6);
private _minSpeedMove = _distance / _timeMax;
private _minSpeedTurn = abs(_dirDelta / _timeMax);

//["[ ] MOVE - default speed: %1 | min: %2",INTERPOLATION_MOVE_SPEED,_minSpeedMove] call bis_fnc_logFormat;
//["[ ] TURN - default speed: %1 | min: %2",INTERPOLATION_TURN_SPEED,_minSpeedTurn] call bis_fnc_logFormat;

private _timeMove = _distance / (INTERPOLATION_MOVE_SPEED max _minSpeedMove);
private _timeTurn = abs(_dirDelta / (INTERPOLATION_TURN_SPEED max _minSpeedTurn));
private _timeStart = time;
private _timeDelta = 0;

private ["_posOffset","_posPlane","_dirOffset","_dirPlane"];

while {!(GET_CATAPULT_STATE in [LAUNCH_CANCELLED,LAUNCH_COMPLETED]) && {isNull attachedTo _plane}} do
{
	_timeDelta = time - _timeStart;
	_plane setVectorUp _vectorUp;

	//moving: lock airplane
	if (_timeDelta >= _timeMove) then
	{
		ATTACHED_TO_CATAPULT(true);

		_plane setPosWorld _posCatapult;
		_plane setVelocity [0,0,0];
	}
	//moving: interpolate airplane
	else
	{
		_posOffset = [_posDelta,_timeDelta/_timeMove] call BIS_fnc_vectorMultiply;
		_posPlane = _posStart vectorAdd _posOffset; _posPlane set [2, _height];
		_plane setPosWorld _posPlane;
	};

	//turning: lock airplane
	if (_timeDelta >= _timeTurn) then
	{
		_plane setDir _dirCatapult;
	}
	//turning: interpolate airplane
	else
	{
		_dirOffset = _dirDelta * _timeDelta/_timeTurn;
		_dirPlane = _dirStart + _dirOffset;
		_plane setDir _dirPlane;
	};

	sleep INTERPOLATION_STEP_LENGTH;
};

ATTACHED_TO_CATAPULT(false);