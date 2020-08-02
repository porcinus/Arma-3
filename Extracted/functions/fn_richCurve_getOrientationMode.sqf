/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns orientation mode for objects animated by this curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Integer - The mode (0 = None, 1 = Look At, 2 = Movement Direction)
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	0;
};

// Return
if (is3DEN) then
{
	(_curve get3DENAttribute "OrientationMode") select 0;
}
else
{
	_curve getVariable ["OrientationMode", 0];
};