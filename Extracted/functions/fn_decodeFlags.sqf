/*

	Decodes a single scalar into array of unique binary flags with indexes between 0-15. Max. value of the scalar that can be decoded is 65535 (= 2^16 - 1).

	Syntax:
	-------
	_flags:array = _encodedFlags:scalar call bis_fnc_decodeFlags;

	Example:
	--------
	[0,2,3] = 13 call bis_fnc_decodeFlags;

*/

_flags = [];

if (typeName _this != typeName 1 || {_this < 0 || _this > 65535 || {_this % 1 > 0}}) exitWith
{
	["[x] Input parameter must be a single non-decimal number between 0 and 65535!"] call bis_fnc_error;
	_flags
};

{
	if (_this >= _x) then
	{
		_flags pushBack (15 - _forEachIndex);
		_this = _this - _x;
	};
}
forEach [32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1];

_flags