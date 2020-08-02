/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key arrive tangent

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key arrive tangent
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// If we have a arrive control point, use it
private _controlPoint = [_key] call BIS_fnc_key_getArriveControlPoint;

if (!isNull _controlPoint) exitWith
{
	getPosASL _key vectorDiff getPosASL _controlPoint vectorMultiply -1;
};

// Custom variable
if (is3DEN) then
{
	(_key get3DENAttribute "ArriveTangent") select 0;
}
else
{
	_key getVariable ["ArriveTangent", [0.0, 0.0, 0.0]];
};