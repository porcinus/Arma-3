/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether this camera is selected in 3den

	Parameter(s):
	_this select 0: Object	- The camera

	Returns:
	Bool - True if selected, false if not
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];

// Validate
if (isNull _camera || {!is3DEN}) exitWith
{
	false;
};

_camera getVariable ["_edenSel", false];