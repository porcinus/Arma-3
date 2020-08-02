/*
	Decodes a single scalar into array of unique binary flags (zeroes or onces). Max. number that can be decoded is 16777215 (= 2^24 - 1). An optional parameter can by supplied to resize the binary flags output to set ammount of binary values/bits.

	Syntax:
	-------
	_flags:array = _encodedFlags:scalar call bis_fnc_decodeFlags2;
	_flags:array = [_encodedFlags:scalar,_size:scalar] call bis_fnc_decodeFlags2;

	Example:
	--------
	[1,0,1,1] = 13 call bis_fnc_decodeFlags2;
	[1,0,1,1,0,0,0,0] = [13,8] call bis_fnc_decodeFlags2;
*/

params
[
	["_value",0,[123]],
	["_size",-1,[123]]
];

if (_value < 0 || _value > 16777215 || {_value % 1 > 0}) exitWith
{
	["[x] Input parameter must be a single non-decimal number between 0 and 16777215!"] call bis_fnc_error;
	[]
};

private _flags = [];
private _found = false;

{
	if (_value >= _x) then
	{
		_found = true;

		_flags pushBack 1;
		_value = _value - _x;
	}
	else
	{
		if (_found) then
		{
			_flags pushBack 0;
		};
	};
}
forEach ([8388608,4194304,2097152,1048576,524288,262144,131072,65536,32768,16384,8192,4096,2048,1024,512,256,128,64,32,16,8,4,2,1] select {_x <= _value});

reverse _flags;

if (_size != -1) then
{
	private _flagCount = count _flags;
	_flags resize _size;

	if (_size > _flagCount) then {_flags = _flags apply {if (isNil{_x}) then {0} else {_x}};};
};

_flags