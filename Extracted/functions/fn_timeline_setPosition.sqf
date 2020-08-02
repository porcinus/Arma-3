/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the playback position

	Parameter(s):
	_this select 0: Object - The timeline
	_this select 1: Float - The new timeline playback position

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _position	= _this param [1, 0.0, [0.0]];

// Validate object
if (isNull _timeline) exitWith {};

// Set the position in this timeline
_timeline setVariable ["Pos", _position];