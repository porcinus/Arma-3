/*
	Author:
	Nelson Duarte

	Description:
	CLerp - Circular Lerp - is like lerp but handles the wraparound from 0 to 360
	This is useful when interpolating eulerAngles and the object crosses the 0/360 boundary
	The standard Lerp function causes the object to rotate in the wrong direction, clerp fixes that

	Parameters:
	_this: ARRAY
		0: Float - The current value
		1: Float - The target value
		2: Float - The alpha

	Returns:
	Float
*/
params [["_start", 0.0, [0.0]], ["_end", 0.0, [0.0]], ["_value", 0.0, [0.0]]];

private _min = 0.0;
private _max = 360.0;
private _half = Abs((_max - _min) / 2.0);
private _retval = 0.0;
private _diff = 0.0;

if ((_end - _start) < -_half) then
{
    _diff = ((_max - _start) + _end) * _value;
    _retval = _start + _diff;
}
else
{
	if ((_end - _start) > _half) then
	{
	    _diff = -((_max - _end) + _start) * _value;
	    _retval = _start + _diff;
	}
	else
	{
		_retval = _start + (_end - _start) * _value;
	};
};

_retval;