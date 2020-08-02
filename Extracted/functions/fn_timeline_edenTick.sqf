/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Time line is updated in 3den

	Parameter(s):
	_this select 0: Object	- The timeline
	_this select 1: Float	- The delta time

	Returns:
	Nothing
*/

// Parameters
private _timeline	= _this param [0, objNull, [objNull]];
private _deltaTime	= _this param [1, 0.0, [0.0]];

// Validate
if (isNull _timeline || {(is3DEN && {!([_timeline] call BIS_fnc_timeline_edenIsSelected)})}) exitWith {};