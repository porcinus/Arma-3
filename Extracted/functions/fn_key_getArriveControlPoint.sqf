/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the arrive control point of a key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Object - The control point
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// The arrive control point
private _controlPoint = objNull;

// Validate key
if (isNull _key) exitWith
{
	"Provided key is NULL" call BIS_fnc_error;
	_controlPoint;
};

private _objs = if (is3DEN) then {get3DENConnections _key} else {synchronizedObjects _key};

// Go through all sync objects and find arrive control point
{
	private _cp = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_cp isKindOf "ControlPoint_F" && {[_cp] call BIS_fnc_controlPoint_isArrive}) exitWith
	{
		_controlPoint = _cp;
	};
}
forEach _objs;

// Return
_controlPoint;