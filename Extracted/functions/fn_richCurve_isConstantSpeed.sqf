/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether the movement on this curve is constant, by parameterizing the curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Bool - True if speed is constant when moving along this curve, false if not
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// In 3DEN we use attribute
// In game we use variable set by the attribute
if (is3DEN) then
{
	(_curve get3DENAttribute "ConstantSpeed") select 0;
}
else
{
	_curve getVariable ["ConstantSpeed", false];
};