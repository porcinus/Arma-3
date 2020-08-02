/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the length of this timeline in seconds

	Parameter(s):
	_this select 0: Object 	- The timeline
	_this select 1: Float	- The new length

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _length 	= _this param [1, 10.0, [0.0]];

// Pause or unpause the timeline
_timeline setVariable ["Length", _length];