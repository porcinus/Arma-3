/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the time of given key

	Parameter(s):
	_this select 0: Object 	- The key
	_this select 1: Float	- The new time

	Returns:
	Nothing
*/

// Parameters
private _key 		= _this param [0, objNull, [objNull]];
private _time 		= _this param [1, 0.0, [0.0]];
private _isConfig 	= _this param [2, false, [false]];

// Set's the time of this key
if (is3DEN) then
{
	_key set3DENAttribute ["Time", _time];
}
else
{
	_key setVariable [if (_isConfig) then {"Time"} else {"KeyTime"}, _time];
};