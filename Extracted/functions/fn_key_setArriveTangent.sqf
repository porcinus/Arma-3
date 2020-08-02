/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the key arrive tangent

	Parameter(s):
	_this select 0: Object 	- The key
	_this select 1: float	- The new arrive tangent

	Returns:
	Nothing
*/

// Parameters
private _key 			= _this param [0, objNull, [objNull]];
private _arriveTangent 	= _this param [1, 0.0, [0.0, []]];

// Set this key's new arrive tangent
if (is3DEN) then
{
	_key set3DENAttribute ["ArriveTangent", _arriveTangent];
}
else
{
	_key setVariable ["ArriveTangent", _arriveTangent];
};