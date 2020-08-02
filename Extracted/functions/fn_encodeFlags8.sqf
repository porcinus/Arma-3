/*
	Encodes array of unique 8-state flags (0,1,2,3,4,5,6,7) into a single number.

	Syntax:
	-------
	_encodedFlags:scalar = _flags:array call bis_fnc_encodeFlags8;

	Example:
	--------
	4311 = [7,2,3,0,1] call bis_fnc_encodeFlags8;

	Explanation:
	------------
	[7,2,3,0,1] -> 001 000 011 010 111 -> 0001 0000 1101 0111 -> 4311
*/

#define ERROR	{_encoded = 0;["[x] Input parameter must be an array of zeroes or ones of max size of 12!"] call bis_fnc_error;_encoded}

if (!(_this isEqualType []) || {count _this > 12}) exitWith ERROR;

private _encoded = 0;
private _mult = 1;

{
	if !(_x in [0,1,2,3,4,5,6,7]) exitWith ERROR;

	if (_x != 0) then
	{
		_encoded = _encoded + _x * _mult;
	};

	_mult = _mult * 8;
}
forEach _this;

_encoded