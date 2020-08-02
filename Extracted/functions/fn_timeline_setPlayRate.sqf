/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's this timeline play rate

	Parameter(s):
	_this select 0: Object	- The timeline
	_this select 1: Float	- The rate at which to play the timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _rate		= _this param [1, 1.0, [0.0]];

_timeline setVariable ["PlayRate", _rate];