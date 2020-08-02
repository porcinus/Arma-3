/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether control points of given key are set to locked

	Parameter(s):
	_this select 0: Object - The key object

	Returns:
	Bool - True if control points are locked, false if not
*/

// 3DEN only
if (!is3DEN) exitWith
{
	false;
};

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate
if (isNull _key) exitWith
{
	false;
};

(_key get3DENAttribute "LockControlPoints") select 0;