/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns the time of given key

	Parameter(s):
	_this select 0: Object - The key

	Returns:
	Float - The key time
*/

// Parameters
private _key = _this param [0, objNull, [objNull]];

// Validate key
if (isNull _key) exitWith {};

// Return
if (is3DEN) then
{
	(_key get3DENAttribute "Time") select 0;
}
else
{
	_key getVariable ["Time", 0.0];
};