/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Computes the curve that owns key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Curve - The owner curve object
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// The owner curve
private _ownerCurve = objNull;

// Validate key
if (isNull _key) exitWith
{
	_ownerCurve;
};

// Connections
private _objs = if (is3DEN) then {get3DENConnections _key} else {synchronizedObjects _key};

// Go through all sync objects and find curve
{
	private _curve = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_curve isKindOf "Curve_F") exitWith
	{
		_ownerCurve = _curve;
	};
}
forEach _objs;

// Return
_ownerCurve;