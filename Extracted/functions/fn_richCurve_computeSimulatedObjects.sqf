/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's all simulated objects

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - List of objects simulated by given curve
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _forced	= _this param [1, false, [false]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

private _list = [];
private _objs = if (is3DEN) then {get3DENConnections _curve} else {synchronizedObjects _curve};

{
	private _obj = if (_x isEqualType []) then {_x select 1} else {_x};

	if (!(_obj isKindOf "Curve_F") && {!(_obj isKindOf "Key_F")} && {!(_obj isKindOf "ControlPoint_F")} && {!(_obj isKindOf "Timeline_F")}) then
	{
		_list pushBackUnique _obj;
	};
}
forEach _objs;

_list;