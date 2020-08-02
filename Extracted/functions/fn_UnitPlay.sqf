/*
	Author: Karel Moricky (based on a script by Martin Melicharek)

	Description:
	Plays back input movement data on input unit.

	Parameter(s):
		0: OBJECT - unit to play movement data on
		1: ARRAY - movement data recorder by BIS_fnc_unitCapture
		2: ARRAY (Optional) - variable to set once playback has finished. The array is in the following format:
			0: NAMESPACE, GROUP or OBJECT
			1: STRING - variable name
		3: BOOL - true to allow playaback on destroyed objects (normally the playback will stop once the object is destroyed)
		4: NOTHING - obsolete param, preserved because of backward compatibility
		5: NOTHING - obsolete param, preserved because of backward compatibility
		6: NUMBER - seconds to skip at the start of playback

	Returns:
	BOOL - always true. The script is completed once the playback is finished.
*/

if !(_this isEqualType "") then
{
	//--- Initialize
	waituntil {time > 0};
	private ["_object","_recording","_endParams","_ignoreDisabled","_startRecordingTime","_endSpace","_endVar","_dataVar","_handlerDraw3D","_data"];

	_object = _this param [0,objnull,[objnull]];
	_recording = _this param [1,[],[[]]];
	_endParams = _this param [2,[],[[]]];
	_ignoreDisabled = _this param [3,false,[false]];
	_startRecordingTime = _this param [6,0,[0]];

	_object setvariable ["BIS_fnc_unitPlay_terminate",nil];

	_endSpace = _endParams param [0,missionnamespace,[missionnamespace,objnull,grpnull]];
	_endVar = _endParams param [1,"",[""]];

	_dataVar = "bis_fnc_unitPlay" + str (["bis_fnc_unitPlay_counter",1] call bis_fnc_counter);
	missionnamespace setvariable
	[
		_dataVar,
		[
			_object,				//--- 0: Object
			_recording,				//--- 1: Recording
			count _recording,		//--- 2: Recording count
			_ignoreDisabled,		//--- 3: Ignore disabled
			_startRecordingTime,	//--- 4: Start time
			time,					//--- 5: Start playback time
			-1,						//--- 6: Step
			0,						//--- 7: Current time
			0,						//--- 8: Next time
			[],						//--- 9: Velocity transformation
			[_endSpace,_endVar]		//--- 10: End params
		]
	];

	//--- Each frame event
	addMissionEventHandler ["EachFrame", format ["'%1' call bis_fnc_unitPlay;", _dataVar]];

	// Wait for scene to finish and kill this script thread
	// Needed for scripts which wait for this one
	waituntil {isNil {missionNamespace getVariable _dataVar}};
	true
}
else
{
	//--- Loop
	_dataVar = _this;

	_data = missionnamespace getvariable _dataVar;
	_data params ["_object", "_recording", "_recordingCount", "_ignoreDisabled", "_startRecordingTime", "_startPlaybackTime", "_step", "_currentTime", "_nextTime", "_velocityTransformation"];

	_playbackTime = time - _startPlaybackTime + _startRecordingTime;

	//--- Terminate when the recording is finished or when the object is disabled
	if (_object getvariable ["BIS_fnc_unitPlay_terminate",false] || {_step >= _recordingCount - 2} || {!_ignoreDisabled && {!alive _object || {!canmove _object}}}) exitwith
	{
		//--- Terminate
		missionNamespace setVariable [_dataVar, nil];

		//--- Remove event
		removeMissionEventHandler ["EachFrame", _thisEventHandler];

		//--- Set end variable
		_endParams = _data select 10;
		if ((_endParams select 1) != "") then {(_endParams select 0) setvariable [_endParams select 1,true];};
	};

	//--- Select step (skip multiple if necessary)
	while {_step < _recordingCount - 2 && {_nextTime <= _playbackTime || {_currentTime < _startRecordingTime}}} do
	{
		_step = _step + 1;

		_currentData = _recording select _step;
		_currentTime = _currentData select 0;

		_nextData = _recording select (_step + 1);
		_nextTime = _nextData select 0;

		_velocityTransformation = [
			_currentData select 1,_nextData select 1,
			_currentData select 4,_nextData select 4,
			_currentData select 2,_nextData select 2,
			_currentData select 3,_nextData select 3
		];

		_data set [6,_step];
		_data set [7,_currentTime];
		_data set [8,_nextTime];
		_data set [9,_velocityTransformation];
	};

	_stepProgress = linearConversion [_currentTime,_nextTime,_playbackTime,0,1];
	_velocityTransformation set [8,_stepProgress];
	_object setvelocitytransformation _velocityTransformation;
};