/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Ticks a timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Nothing
*/

#include "\a3\functions_f\debug.inc"

PROFILING_START("BIS_fnc_timeline_tick: " + str (_this select 0));

// Parameters
private _timeline 				= _this param [0, objNull, [objNull]];
private _deltaTime 				= _this param [1, 0.0, [0.0]];

// Validate timeline
if (isNull _timeline) exitWith {PROFILING_STOP("");};

// If in 3DEN and not selected, do not tick
if (is3DEN && {!([_timeline] call BIS_fnc_timeline_edenIsSelected)}) exitWith {PROFILING_STOP("");};

// Gather timeline data
private _isPlaying 				= [_timeline] call BIS_fnc_timeline_isPlaying;
private _isPaused 				= [_timeline] call BIS_fnc_timeline_isPaused;
private _isPlayingNotPaused		= _isPlaying && {!_isPaused};
private _finished 				= false;

// Simulate if we are playing and not paused
if (_isPlayingNotPaused) then
{
	// Params
	private _position			= [_timeline] call BIS_fnc_timeline_getPosition;
	private _length 			= [_timeline] call BIS_fnc_timeline_getLength;
	private _playRate			= [_timeline] call BIS_fnc_timeline_getPlayRate;
	private _isReverse 			= [_timeline] call BIS_fnc_timeline_isReverse;
	private _isLooping 			= [_timeline] call BIS_fnc_timeline_isLooping;

	// Compute new position
	private _effectiveDeltaTime = _deltaTime * (if (_isReverse) then {-_playRate} else {_playRate});
	private _newPosition		= _position + _effectiveDeltaTime;

	// Whether we looped
	private _didLoop = false;

	// Moved forward
	if (_effectiveDeltaTime > 0.0) then
	{
		_didLoop = _isLooping && {_newPosition == _length || {_newPosition > _length}};

		if (_newPosition > _length) then
		{
			if (_isLooping) then
			{
				[_timeline, 0.0] call BIS_fnc_timeline_setPosition;

				if (_length > 0.0) then
				{
					while {_newPosition > _length} do
					{
						_newPosition = _newPosition - _length;
					};
				}
				else
				{
					_newPosition = 0.0;
				};
			}
			else
			{
				_newPosition = _length;
				[_timeline] call BIS_fnc_timeline_stop;
				_finished = true;
			};
		};
	}
	// Moved backwards
	else
	{
		if (_newPosition < 0.0) then
		{
			_didLoop = _isLooping && {_newPosition == 0.0 || {_newPosition < 0.0}};

			if (_isLooping) then
			{
				[_timeline, _length] call BIS_fnc_timeline_setPosition;

				if (_length > 0.0) then
				{
					while {_newPosition < 0.0} do
					{
						_newPosition = _newPosition + _length;
					};
				}
				else
				{
					_newPosition = 0.0;
				};
			}
			else
			{
				_newPosition = 0.0;
				[_timeline] call BIS_fnc_timeline_stop;
				_finished = true;
			};
		};
	};

	// Calculate alpha
	private _alphaN		= [0.0, _length, _newPosition] call BIS_fnc_inverseLerp;
	private _alpha		= [_alphaN, 0.0, 1.0] call BIS_fnc_clamp;

	// Update alpha
	_timeline setVariable ["Alpha", _alpha];

	// Set new position
	[_timeline, _newPosition] call BIS_fnc_timeline_setPosition;

	// In case we have registered curves, simulate them
	[_timeline, _alpha, _deltaTime] call BIS_fnc_timeline_simulateCurves;

	// Trigger looped event
	if (!is3DEN && {_didLoop}) then
	{
		// Call bound scripted event handlers
		[_timeline, "looped", [_timeline]] call BIS_fnc_callScriptedEventHandler;

		// Call event looped on timeline
		[_timeline] call compile (_timeline getVariable ["EventLooped", ""]);

		// Reset events states on all the keys
		// This means Keys can trigger their events again after we loop the timeline
		{
			[_x] call BIS_fnc_richCurve_resetKeysEventState;
		}
		forEach ([_timeline] call BIS_fnc_timeline_getSimulatedCurves);
	};
};

PROFILING_STOP("");

// In case we just finished, trigger events
if (_finished) then
{
	[_timeline] call BIS_fnc_Timeline_finish;
};