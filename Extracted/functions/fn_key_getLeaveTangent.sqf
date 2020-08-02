/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key leave tangent

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key leave tangent
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// If we have a leave control point, use it
private _controlPoint = [_key] call BIS_fnc_key_getLeaveControlPoint;

if (!isNull _controlPoint) exitWith
{
	getPosASL _key vectorDiff getPosASL _controlPoint vectorMultiply -1;
};

// Return the leave tangent of this key
if (is3DEN) then
{
	(_key get3DENAttribute "LeaveTangent") select 0;
}
else
{
	_key getVariable ["LeaveTangent", [0.0, 0.0, 0.0]];
};