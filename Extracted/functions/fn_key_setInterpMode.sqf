/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the interpolation mode of the key

	Parameter(s):
	_this select 0: Object	- The key
	_this select 1: Integer	- The new key interp mode

	Returns:
	Nothing
*/

// Parameters
private _key 		= _this param [0, objNull, [objNull]];
private _interpMode = _this param [1, 0, [0]];

// Set the new interp mode of the key
if (is3DEN) then
{
	_key set3DENAttribute ["InterpMode", _interpMode];
}
else
{
	_key setVariable ["InterpMode", _interpMode];
};