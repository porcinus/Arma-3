/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's keys assigned to given curve

	Parameter(s):
	_this select 0: Object 	- The curve
	_this select 1: Bool	- Whether or not to sort the keys by time

	Returns:
	Array - List of assigned keys
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];
private _sort	= _this param [1, true, [false]];
private _forced	= _this param [2, false, [false]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

// Connections
private _objs 		= if (is3DEN) then {get3DENConnections _curve} else {synchronizedObjects _curve};
private _syncKeys 	= [];

// Go through syncronized objects
{
	private _key = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_key isKindOf "Key_F") then
	{
		_syncKeys pushBackUnique _key;
	};
}
forEach _objs;

// Return
if (!_sort) then
{
	_syncKeys;
}
else
{
	[_syncKeys, [], {[_x] call BIS_fnc_key_getTime}, "ASCEND"] call BIS_fnc_sortBy;
};