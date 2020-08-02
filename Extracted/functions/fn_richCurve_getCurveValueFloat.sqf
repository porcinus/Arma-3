/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Get's curve value at given time

	Parameter(s):
	_this select 0: Object 	- The curve
	_this select 1: Float 	- The time
	_this select 2: Integer	- Value type

	Returns:
	float - The value at given time
*/

#include "\A3\Modules_f\Animation\commonDefines.inc"

// Parameters
private _curve 		= _this param [0, objNull, [objNull]];
private _time 		= _this param [1, 0.0, [0.0]];
private _valueType	= _this param [2, 0, [0]];
private _keys		= [_curve] call BIS_fnc_richCurve_getKeys;
private _numKeys 	= count _keys;
private _return 	= 0.0;

// No keys, return default value
if (_numKeys < 1) exitWith
{
	_return;
};

// Only one key
if (_numKeys < 2) exitWith
{
	[_keys select 0, _valueType] call BIS_fnc_key_getValue;
};

private _first = 1;
private _last = _numKeys - 1;
private _count = _last - _first;

while {_count > 0} do
{
	private _step = floor (_count / 2);
	private _middle = _first + _step;

	if (_time >= ([_keys select _middle] call BIS_fnc_key_getTime)) then
	{
		_first = _middle + 1;
		_count = _count - (_step + 1);
	}
	else
	{
		_count = _step;
	};
};

private _InterpNode = _first;
private _Diff = ([_keys select _InterpNode] call BIS_fnc_key_getTime) - ([_keys select (_InterpNode - 1)] call BIS_fnc_key_getTime);

if (_Diff > 0.0) then
{
	private _Alpha = (_time - ([_keys select (_InterpNode - 1)] call BIS_fnc_key_getTime)) / _Diff;
	private _P0 = [_keys select (_InterpNode - 1), _valueType] call BIS_fnc_key_getValue;
	private _P3 = [_keys select _InterpNode, _valueType] call BIS_fnc_key_getValue;

	_return = switch ([_keys select (_InterpNode - 1)] call BIS_fnc_key_getInterpMode) do
	{
		case LINEAR : 			{[_P0, _P3, _Alpha] call BIS_fnc_lerp;};
		case CUBIC :			{[_P0, _P0, _P3, _P3, _Alpha] call BIS_fnc_bezierInterpolate;};
		case EASEIN : 			{[_P0, _P3, _Alpha] call BIS_fnc_easeIn;};
		case EASEOUT :			{[_P0, _P3, _Alpha] call BIS_fnc_easeOut;};
		case EASEINOUT :		{[_P0, _P3, _Alpha] call BIS_fnc_easeInOut;};
		case HERMITE :			{[_P0, _P3, _Alpha] call BIS_fnc_hermite;};
		case BERP :				{[_P0, _P3, _Alpha] call BIS_fnc_berp;};
		case BOUNCEIN :			{[_P0, _P3, _Alpha] call BIS_fnc_bounceIn;};
		case BOUNCEOUT :		{[_P0, _P3, _Alpha] call BIS_fnc_bounceOut;};
		case BOUNCEINOUT :		{[_P0, _P3, _Alpha] call BIS_fnc_bounceInOut;};
		case QUINTICIN :		{[_P0, _P3, _Alpha] call BIS_fnc_quinticIn;};
		case QUINTICOUT :		{[_P0, _P3, _Alpha] call BIS_fnc_quinticOut;};
		case QUINTICINOUT :		{[_P0, _P3, _Alpha] call BIS_fnc_quinticInOut;};
		case CONSTANT :			{_P0;};
	};
}
else
{
	_return = [_keys select (_InterpNode - 1), _valueType] call BIS_fnc_key_getValue;
};

_return;