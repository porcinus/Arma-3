private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

_value = [_value, 0.0, 1.0] call BIS_fnc_clamp;

_value = (sin (_value * pi * (0.2 + 2.5 * _value * _value * _value)) * ([1.0 - _value, 2.2] call BIS_fnc_pow) + _value) * (1.0 + (1.2 * (1.0 - _value)));

_start + (_end - _start) * _value;