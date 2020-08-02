private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

[_start, _end, _value * _value * (3.0 - 2.0 * _value)] call BIS_fnc_lerp;