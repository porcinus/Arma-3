/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN connections of a timeline is changed

	Parameter(s):
	_this select 0: Object	- The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate
if (isNull _timeline) exitWith {};