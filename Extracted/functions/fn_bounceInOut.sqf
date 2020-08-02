private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

if (_value < 0.5) then
{
	_value = 0.5 * _value * 2;
	[_start, _end, _value] call BIS_fnc_bounceIn;
}
else
{
	_value = 0.5 * (_value * 2 - 1) + 0.5;
	[_start, _end, _value] call BIS_fnc_bounceOut;
};