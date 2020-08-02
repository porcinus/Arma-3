/*
	Decodes a single scalar into array of unique 4-state flags (values 0,1,2,3). Max. number that can be decoded is 16777215 (= 4^12 - 1). An optional parameter can by supplied to resize the output.

	Syntax:
	-------
	_flags:array = _encodedFlags:scalar call bis_fnc_decodeFlags4;
	_flags:array = [_encodedFlags:scalar,_size:scalar] call bis_fnc_decodeFlags4;

	Example:
	--------
	[1,0,2,3] = 225 call bis_fnc_decodeFlags4;
	[1,0,2,3,0,0,0,0] = [225,8] call bis_fnc_decodeFlags4;

	Explanation:
	------------
	225 -> 11 10 00 01 -> [1,0,2,3]
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
private _flag = 0;

{
	if (_value >= _x) then
	{
		_found = true;

		_flag = floor (_value/_x);

		_flags pushBack _flag;
		_value = _value - (_flag * _x);
	}
	else
	{
		if (_found) then
		{
			_flags pushBack 0;
		};
	};
}
forEach ([4194304,1048576,262144,65536,16384,4096,1024,256,64,16,4,1] select {_x <= _value});

reverse _flags;

if (_size != -1) then
{
	private _flagCount = count _flags;
	_flags resize _size;

	if (_size > _flagCount) then {_flags = _flags apply {if (isNil{_x}) then {0} else {_x}};};
};

_flags