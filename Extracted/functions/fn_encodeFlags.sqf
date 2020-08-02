/*

	Encodes array of unique binary flags with indexes between 0-15 into a single scalar.

	Syntax:
	-------
	_encodedFlags:scalar = _flags:array call bis_fnc_encodeFlags;

	Example:
	--------
	13 = [0,2,3] call bis_fnc_encodeFlags;

*/

#define ERROR	{_encoded = 0;["[x] Input parameter must be an array of non-decimal numbers between 0 and 15!"] call bis_fnc_error;}

private["_flags","_encoded"];

_flags = _this;

if (typeName _flags != typeName []) exitWith ERROR;

_encoded = 0;

{
	if (typeName _x != typeName 1 || {_x < 0 || _x > 15 || {_x % 1 > 0}}) exitWith ERROR;

	_encoded = _encoded + (2 ^ _x);
}
forEach _flags;

_encoded