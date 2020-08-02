/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Stores owner timeline

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Object - The owner timeline object
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _forced	= _this param [1, false, [false]];

// Validate curve
if (isNull _curve) exitWith
{
	objNull;
};

private _timeline 	= objNull;
private _objs 		= if (is3DEN) then {get3DENConnections _curve} else {synchronizedObjects _curve};

{
	private _obj = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_obj isKindOf "Timeline_F") exitWith
	{
		_timeline = _obj;
	};
}
forEach _objs;

_timeline;