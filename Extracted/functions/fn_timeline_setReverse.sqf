/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's this timeline playback as reverse or not

	Parameter(s):
	_this select 0: Object - The timeline
	_this select 1: Bool - True to reverse timeline, false to not reverse it

	Returns:
	Nothing
*/

// Parameters
private _timeline 	= _this param [0, objNull, [objNull]];
private _reverse	= _this param [1, true, [true]];

// Validate object
if (isNull _timeline) exitWith {};

_timeline setVariable ["Reverse", _reverse];