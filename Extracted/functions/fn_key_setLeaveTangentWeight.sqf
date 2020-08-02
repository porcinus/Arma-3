/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the key leave tangent weight

	Parameter(s):
	_this select 0: Object 	- The key
	_this select 1: Float	- The new leave tangent weight

	Returns:
	Nothing
*/

// Parameters
private _key 				= _this param [0, objNull, [objNull]];
private _leaveTangentWeight = _this param [1, 1.0, [1.0]];

// Set's the leave tangent weight of this key
if (is3DEN) then
{
	_key set3DENAttribute ["LeaveTangentWeight", _leaveTangentWeight];
}
else
{
	_key setVariable ["LeaveTangentWeight", _leaveTangentWeight];
};