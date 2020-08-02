/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the key arrive tangent weight

	Parameter(s):
	_this select 0: Object	- The key
	_this select 1: Float	- The new arrive tangent weight

	Returns:
	Nothing
*/

// Parameters
private _key 					= _this param [0, objNull, [objNull]];
private _arriveTangentWeight 	= _this param [1, 1.0, [1.0]];

// Set this key's arrive tangent weight
if (is3DEN) then
{
	_key set3DENAttribute ["ArriveTangentWeight", _arriveTangentWeight];
}
else
{
	_key setVariable ["ArriveTangentWeight", _arriveTangentWeight];
};