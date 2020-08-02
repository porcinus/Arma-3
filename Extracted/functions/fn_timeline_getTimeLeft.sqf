/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	The time left of given timeline

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	The time left
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	0.0;
};

private _isReverse 	= [_timeline] call BIS_fnc_timeline_isReverse;
private _position	= [_timeline] call BIS_fnc_timeline_getPosition;
private _length 	= [_timeline] call BIS_fnc_timeline_getLength;

if (_isReverse) then
{
	abs (_position - _length);
}
else
{
	_length - _position;
};