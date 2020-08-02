/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's this timeline playback loop mode

	Parameter(s):
	_this select 0: Object - The timeline
	_this select 1: Bool - True to loop timeline, false to not loop it

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _loop		= _this param [1, true, [true]];

// Validate object
if (isNull _timeline) exitWith {};

_timeline setVariable ["Loop", _loop];