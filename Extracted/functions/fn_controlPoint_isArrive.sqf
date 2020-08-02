/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether given control point is arrive, not leave

	Parameter(s):
	_this select 0: Object 	- The control point

	Returns:
	Bool - True if control point is Arrive, not Leave
*/

// Parameters
private _controlPoint = _this param [0, objNull, [objNull]];

// Validate control point
if (isNull _controlPoint) exitWith
{
	false;
};

// Return
if (is3DEN) then
{
	(_controlPoint get3DENAttribute "TangentType") select 0 == 0;
}
else
{
	_controlPoint getVariable ["TangentType", 0] == 0;
};