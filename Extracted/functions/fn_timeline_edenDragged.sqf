/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Entity is dragged in 3DEN

	Parameter(s):
	_this select 0: Object	- The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate
if (isNull _timeline) exitWith {};

// Store last dragged operation time
missionNamespace setVariable ["_lastDragOperationTime", time];