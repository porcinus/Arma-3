/*

	Encodes array of unique binary flags (zeroes or ones) into a single scalar.

	Syntax:
	-------
	_encodedFlags:scalar = _flags:array call bis_fnc_encodeFlags2;

	Example:
	--------
	13 = [1,0,1,1] call bis_fnc_encodeFlags2;

	//0.136
*/

#define ERROR	{_encoded = 0;["[x] Input parameter must be an array of zeroes or ones of max size of 24!"] call bis_fnc_error;_encoded}

if (!(_this isEqualType []) || {count _this > 24}) exitWith ERROR;

private _encoded = 0;

{
	if !(_x in [0,1]) exitWith ERROR;

	if (_x == 1) then
	{
		_encoded = _encoded + (2 ^ _forEachIndex);
	};
}
forEach _this;

_encoded