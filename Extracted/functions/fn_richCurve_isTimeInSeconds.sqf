/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Whether the time of the keys belonging to this curve are in seconds

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Bool - True if in seconds, false if in alpha
*/

// Parameters
private _curve = _this param [0, objNull, [objNull]];

// In 3DEN we use attribute
// In game we use variable set by the attribute
if (is3DEN) then
{
	(_curve get3DENAttribute "TimeInSeconds") select 0;
}
else
{
	_curve getVariable ["TimeInSeconds", true];
};