/*
	Encodes array of unique 4-state flags (0,1,2,3) into a single number.

	Syntax:
	-------
	_encodedFlags:scalar = _flags:array call bis_fnc_encodeFlags4;

	Example:
	--------
	225 = [1,0,2,3] call bis_fnc_encodeFlags4;

	Explanation:
	------------
	[1,0,2,3] -> 11 10 00 01 -> 225
	[0,0,0,0,0,0,0,1] -> 01 00 00 00 00 00 00 00 -> 0100 0000 0000 0000 -> 16384
*/

#define ERROR	{_encoded = 0;["[x] Input parameter must be an array of zeroes or ones of max size of 12!"] call bis_fnc_error;_encoded}

if (!(_this isEqualType []) || {count _this > 12}) exitWith ERROR;

private _encoded = 0;

{
	if !(_x in [0,1,2,3]) exitWith ERROR;

	if (_x != 0) then
	{
		_encoded = _encoded + _x * (2 ^ (2 * _forEachIndex));
	};
}
forEach _this;

_encoded