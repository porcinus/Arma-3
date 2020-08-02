/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns given key time in alpha

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Float - The time in alpha of given key (from 0 to 1)
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];
private _key	= _this param [1, objNull, [objNull]];

// Validate curve and key
if (isNull _curve || {isNull _key}) exitWith
{
	0.0;
};

// Whether we are dealing with alpha or seconds, if with seconds we convert to alpha
if ([_curve] call BIS_fnc_richCurve_isTimeInSeconds) then
{
	private _range 		= [_curve] call BIS_fnc_richCurve_getTimeRange;
	private _min		= _range select 0;
	private _max		= _range select 1;
	private _seconds	= [_key] call BIS_fnc_key_getConfigTime;

	[_min, _max, _seconds] call BIS_fnc_inverseLerp;
}
else
{
	[_key] call BIS_fnc_key_getTime;
};