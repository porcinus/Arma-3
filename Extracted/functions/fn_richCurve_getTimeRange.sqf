/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Returns min / max time range of given curve

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Array - Min / Max time range
*/

// Parameters
private _curve 	= _this param [0, objNull, [objNull]];

// Validate curve
if (isNull _curve) exitWith
{
	[0.0, 0.0];
};

// The min and max values
private _min = 0.0;
private _max = 0.0;

// The keys
private _keys 		= [_curve] call BIS_fnc_richCurve_computeKeys;
private _numKeys 	= count _keys;

if (_numKeys > 0) then
{
	for "_i" from 0 to _numKeys - 1 do
	{
		private _key = _keys select _i;

		_min = _min min ([_key] call BIS_fnc_key_getConfigTime);
		_max = _max max ([_key] call BIS_fnc_key_getConfigTime);
	};
};

// Return the time range
[_min, _max];