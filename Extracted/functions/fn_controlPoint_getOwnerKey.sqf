/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key owner of given control point

	Parameter(s):
	_this select 0: Object 	- The control point

	Returns:
	Object - The owner key
*/

// Parameters
private _controlPoint = _this param [0, objNull, [objNull]];

// Validate control point
if (isNull _controlPoint) exitWith
{
	objNull;
};

// Return
_controlPoint getVariable ["OwnerKey", objNull];