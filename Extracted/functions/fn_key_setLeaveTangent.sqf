/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the key leave tangent

	Parameter(s):
	_this select 0: Object 	- The key
	_this select 1: Float 	- The new leave tangent

	Returns:
	Nothing
*/

// Parameters
private _key			= _this param [0, objNull, [objNull]];
private _leaveTangent	= _this param [1, 0.0, [0.0, []]];

// Set's this key's leave tangent
if (is3DEN) then
{
	_key set3DENAttribute ["LeaveTangent", _leaveTangent];
}
else
{
	_key setVariable ["LeaveTangent", _leaveTangent];
};