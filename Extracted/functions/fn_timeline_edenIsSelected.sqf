/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether this timeline is selected in 3den

	Parameter(s):
	_this select 0: Object	- The timeline

	Returns:
	Bool - True if selected, false if not
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Timeline is selected
if (_timeline getVariable ["_edenSel", false]) exitWith
{
	true;
};

private _bSelected = false;

{
	if ([_x] call BIS_fnc_richCurve_edenIsSelected) exitWith
	{
		_bSelected = true;
	};
}
forEach ([_timeline] call BIS_fnc_timeline_getSimulatedCurves);

_bSelected;