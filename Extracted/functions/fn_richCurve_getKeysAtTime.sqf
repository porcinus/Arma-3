/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's keys (prev / next) at given time

	Parameter(s):
	_this select 0: Object 	- The curve
	_this select 1: Float	- The time

	Returns:
	Array - Previous and next keys
*/

// Parameters
private _curve	= _this param [0, objNull, [objNull]];
private _time	= _this param [1, 0.0, [0.0]];

// Validate curve
if (isNull _curve) exitWith
{
	[];
};

// The keys
private _keys 		= [_curve] call BIS_fnc_richCurve_getKeys;
private _numKeys 	= count _keys;

// Validate keys
if (_numKeys < 1) exitWith
{
	[];
};

// If less then two keys we know which one to return
if (_numKeys < 2) exitWith
{
	if ([_keys select 0] call BIS_fnc_key_getTime <= _time) then
	{
		[_keys select 0, objNull];
	}
	else
	{
		[objNull, _keys select 0];
	};
};

// The out keys
private _prevKey = objNull;
private _nextKey = objNull;

// Sort keys by prev / next
private _prevKeys = [];
private _nextKeys = [];

// Prev / next keys error
private _prevKeysError = 10e10;
private _nextKeysError = 10e10;

// Iterate keys and sort them by prev / next
{
	if ([_keys select _forEachIndex] call BIS_fnc_key_getTime <= _time) then
	{
		_prevKeys pushBackUnique (_keys select _forEachIndex);
	}
	else
	{
		_nextKeys pushBackUnique (_keys select _forEachIndex);
	};
}
forEach _keys;

// From all prev keys, choose the closest one
{
	private _error = abs (([_x] call BIS_fnc_key_getTime) - _time);

	if (_error < _prevKeysError) then
	{
		_prevKeysError = _error;
		_prevKey = _x;
	};
}
forEach _prevKeys;

// From all next keys, choose the closest one
{
	private _error = abs (([_x] call BIS_fnc_key_getTime) - _time);

	if (_error < _nextKeysError) then
	{
		_nextKeysError = _error;
		_nextKey = _x;
	};
}
forEach _nextKeys;

// Result
[_prevKey, _nextKey];