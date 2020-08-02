/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the key leave tangent weight

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key leave tangent weight
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Return the leave tangent weight of this key
if (is3DEN) then
{
	(_key get3DENAttribute "LeaveTangentWeight") select 0;
}
else
{
	_key getVariable ["LeaveTangentWeight", 1.0];
};