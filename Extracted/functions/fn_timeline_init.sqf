/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Initialized a timeline

	Parameter(s):
	_this select 0: Object 	- The timeline
	_this select 1: Number 	- The initial position
	_this select 2: Number 	- The length in seconds
	_this select 3: Number 	- The play rate
	_this select 4: Bool 	- Whether loop is enabled
	_this select 5: Bool 	- Whether we should play backwards
	_this select 6: Bool 	- Whether to start playing at scenario start
	_this select 7: Bool 	- Whether to be destroyed when finishing playing

	Returns:
	Nothing
*/

// Parameters
private _timeline 				= _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	["Invalid timeline object provided %1", _timeline] call BIS_fnc_error;
};

// The rest of the parameters
private _position 				= _this param [1, _timeline getVariable ["Pos", 0.0], [0.0]];
private _length 				= _this param [2, _timeline getVariable ["Length", 10.0], [0.0]];
private _playRate 				= _this param [3, _timeline getVariable ["PlayRate", 1.0], [0.0]];
private _loop	 				= _this param [4, _timeline getVariable ["Loop", false], [false]];
private _reverse 				= _this param [5, _timeline getVariable ["Reverse", false], [false]];
private _playFromStart 			= _this param [6, _timeline getVariable ["PlayFromStart", false], [false]];
private _destroyWhenFinished 	= _this param [7, _timeline getVariable ["DestroyWhenFinished", false], [false]];

// If we start in reverse we set initial position to the end of the timeline
if (_reverse) then
{
	_position = _length;
};

// Override settings
_timeline setVariable ["Pos", 					_position];
_timeline setVariable ["Length", 				_length];
_timeline setVariable ["PlayRate", 				_playRate];
_timeline setVariable ["Loop", 					_loop];
_timeline setVariable ["Reversed", 				_reverse];
_timeline setVariable ["PlayFromStart", 		_playFromStart];
_timeline setVariable ["DestroyWhenFinished", 	_destroyWhenFinished];
_timeline setVariable ["Playing", 				false];
_timeline setVariable ["Paused", 				false];
_timeline setVariable ["Finished", 				false];
_timeline setVariable ["PlayTime", 				-1.0];
_timeline setVariable ["StopTime", 				-1.0];
_timeline setVariable ["PauseTime", 			-1.0];

// In case timeline requires play from start, play it
if (_playFromStart) then
{
	[_timeline, _position] call BIS_fnc_timeline_play;
};