private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

private _f = (_value - 1);

[_start, _end, _f * _f * _f * _f * _f + 1] call BIS_fnc_lerp;