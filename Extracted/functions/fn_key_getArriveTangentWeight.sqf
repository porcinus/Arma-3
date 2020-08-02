/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key arrive tangent weight

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key arrive tangent weight
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Return the time of this key
if (is3DEN) then
{
	(_key get3DENAttribute "ArriveTangentWeight") select 0;
}
else
{
	_key getVariable ["ArriveTangentWeight", 1.0];
};