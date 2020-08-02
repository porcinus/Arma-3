private _a 		= _this param [0, 0.0, [0.0]];
private _b 		= _this param [1, 0.0, [0.0]];
private _alpha 	= _this param [2, 0.0, [0.0]];
private _exp 	= _this param [3, 2.0, [0.0]];

if (_alpha < 0.5) then
{
	[_a, _b, ([0.0, 1.0, _alpha * 2.0, _exp] call BIS_fnc_easeIn) * 0.5] call BIS_fnc_lerp;
}
else
{
	[_a, _b, ([0.0, 1.0, _alpha * 2.0 - 1.0, _exp] call BIS_fnc_easeOut) * 0.5 + 0.5] call BIS_fnc_lerp;
};