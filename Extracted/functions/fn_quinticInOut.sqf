private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

if (_value < 0.5) then
{
	[_start, _end, 16 * _value * _value * _value * _value * _value] call BIS_fnc_lerp;
}
else
{
	private _f = ((2 * _value) - 2);
	[_start, _end, 0.5 * _f * _f * _f * _f * _f + 1] call BIS_fnc_lerp;
};