/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's the interpolation mode of the timeline

	Parameter(s):
	_this select 0: Object	- The timeline
	_this select 1: Integer	- The new timeline interp mode

	Returns:
	Nothing
*/

// Parameters
private _timeline	= _this param [0, objNull, [objNull]];
private _interpMode = _this param [1, 0, [0]];

// Set the new interp mode of the timeline
if (is3DEN) then
{
	_timeline set3DENAttribute ["InterpMode", _interpMode];
}
else
{
	_timeline setVariable ["InterpMode", _interpMode];
};