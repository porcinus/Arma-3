/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The simulated curves of a timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Array - List of curve objects that are simulated by this timeline
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	[];
};

// The sync objects
private _list = [];
private _syncObjs = if (is3DEN) then {get3DENConnections _timeline} else {synchronizedObjects _timeline};

// Go through all sync objects and find curve
{
	private _curve = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_curve isKindOf "Curve_F") then
	{
		_list pushBackUnique _curve;
	};
}
forEach _syncObjs;

// Return
_list;