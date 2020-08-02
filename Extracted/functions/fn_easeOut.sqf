private _a 		= _this param [0, 0.0, [0.0]];
private _b 		= _this param [1, 0.0, [0.0]];
private _alpha 	= _this param [2, 0.0, [0.0]];
private _exp 	= _this param [3, 2.0, [0.0]];

private _modifiedAlpha = 1.0 - ((1.0 - _alpha) ^ _exp);

[_a, _b, _modifiedAlpha] call BIS_fnc_lerp;