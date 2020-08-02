/*
	Author: 
		Jiri Wainar, optimised by Killzone_Kid

	Description:
		Get a substring out of the string.

	Parameter(s):
		1: STRING - source string

		2: NUMBER (optional, default 0) - start index;
		   * indexing starts at 0

		3: NUMBER (optional, default end of string) - end index
		   * negative number means -X chars from the string end

	Returns:
		STRING
*/

params ["_str", ["_beg", 0], "_end"];

// alt syntax
if (_this isEqualTypeParams ["",0,0]) exitWith 
{

	private _len = count _str - 1;
	if (_end > _len) then {_end = _len};
	if (_end < 0) then {_end = (_len + _end) max 0};
	if (_beg < 0 || _beg > _end) then {_beg = 0};

	_str select [_beg, _end - _beg + 1]
};

// default syntax
if (_this isEqualTypeParams ["",0]) exitWith 
{

	private _len = count _str - 1;
	if (_beg < 0 || _beg > _len) then {_beg = 0};

	_str select [_beg, _len - _beg + 1]
};

/// --- error, suggest default format
#include "..\paramsCheck.inc"
#define arr ["",0]
paramsCheck(_this,isEqualTypeParams,arr)