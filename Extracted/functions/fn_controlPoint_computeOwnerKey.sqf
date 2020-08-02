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

// The owner key
private _ownerKey = objNull;

// Validate control point
if (isNull _controlPoint) exitWith
{
	_ownerKey;
};

// The syncronized objects, so we look for a key
private _objs = if (is3DEN) then {get3DENConnections _controlPoint} else {synchronizedObjects _controlPoint};

// Go through sync objects and find a key
{
	private _key = if (_x isEqualType []) then {_x select 1} else {_x};

	if (_key isKindOf "Key_F") exitWith
	{
		_ownerKey = _key;
	};
}
forEach _objs;

// Return the key
_ownerKey;