private _start 	= _this param [0, 0.0, [0.0]];
private _end 	= _this param [1, 0.0, [0.0]];
private _value 	= _this param [2, 0.0, [0.0]];

if (_value < 4 / 11.0) then
{
	_value = (121 * _value * _value) / 16.0;
}
else
{
	if (_value < 8/11.0) then
	{
		_value = (363/40.0 * _value * _value) - (99/10.0 * _value) + 17/5.0;
	}
	else
	{
		if (_value < 9/10.0) then
		{
			_value = (4356/361.0 * _value * _value) - (35442/1805.0 * _value) + 16061/1805.0;
		}
		else
		{
			_value = (54/5.0 * _value * _value) - (513/25.0 * _value) + 268/25.0;
		};
	};
};

[_start, _end, _value] call BIS_fnc_lerp;