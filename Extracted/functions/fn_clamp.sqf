/*
	Author:
	Nelson Duarte
	
	Description:
	Clamps scalar between min / max
	
	Parameters:
	_this: ARRAY
		0: SCALAR - The value to clamp
		1: SCALAR - Min value
		2: SCALAR - Max value
	
	Returns:
	SCALAR - Clamped value
*/
params [["_x", 0.0, [0.0]], ["_min", 0.0, [0.0]], ["_max", 0.0, [0.0]]];

if (_x < _min) then
{
	_min;
}
else
{
	if (_x < _max) then
	{
		_x;
	}
	else
	{
		_max;
	};
};