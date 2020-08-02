/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given control point is selected in 3den

	Parameter(s):
	_this select 0: Object	- The control point object

	Returns:
	Bool - True if selected, false if not
*/

// Parameters
private _cp = _this param [0, objNull, [objNull]];

// Return
_cp getVariable ["_edenSel", false];