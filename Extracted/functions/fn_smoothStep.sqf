/*
	Author: Karel Moricky

	Description:
	Interpolates between 0 and 1 with smoothing at the limits.

	Parameter(s):
		0: NUMBER in range <0,1>

	Returns:
	NUMBER
*/

params [["_value",0,[0]]];
_value = _value max 0 min 1;
_value * _value * (3 - 2 * _value)