/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Pauses or unpauses timeline

	Parameter(s):
	_this select 0: Object 	- The timeline
	_this select 1: Bool	- True to pause, false to unpause timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _paused 	= _this param [1, true, [true]];

// Pause or unpause the timeline
_timeline setVariable ["Paused", _paused];