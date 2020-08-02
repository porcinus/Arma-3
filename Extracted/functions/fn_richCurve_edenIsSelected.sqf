/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given curve is selected in 3den

	Parameter(s):
	_this select 0: Object	- The curve object

	Returns:
	Bool - True if selected, false if not
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// Curve is selected
if (_curve getVariable ["_edenSel", false]) exitWith
{
	true;
};

private _bSelected = false;

{
	if ([_x] call BIS_fnc_key_edenIsSelected) exitWith
	{
		_bSelected = true;
	};
}
forEach ([_curve] call BIS_fnc_richCurve_getKeys);

_bSelected;