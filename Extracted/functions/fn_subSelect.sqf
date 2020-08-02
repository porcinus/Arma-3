
/************************************************************
	Subarray Select
	Author: Andrew Barron, optimised by Killzone_Kid

Returns a sub-selection of the passed array. There are various
methods the sub-array can be determined.

Parameters: [array, beg, <end>]
Returns: subarray

array - Array to select sub array from.
beg - Index of array to begin sub-array. If negative, index is
	counted from the end of array.
end - Optional. Index of array to end the sub-array. If ommitted,
	remainder of the array will be selected. If negative, it
	specifies the length of the sub-array (in absolute form).

Examples:

	_array = ["a","b",true,3,8];
	[_array, 2] call BIS_fnc_subSelect; //returns [true,3,8]
	[_array, -2] call BIS_fnc_subSelect; //returns [3,8]
	[_array, 1, 3] call BIS_fnc_subSelect; //returns ["b",true,3]
	[_array, 1, -2] call BIS_fnc_subSelect; //returns ["b",true]

************************************************************/

params ["_arr", "_beg", "_end"];

//alt syntax
if (_this isEqualTypeParams [[],0,0]) exitWith {

	private _len = count _arr - 1;
	if (_beg < 0) then {_beg = _len + _beg + 1};
	if (_end > _len) then {_end = _len};
	if (_end < 0) then {_end = _beg - _end - 1};
	
	_arr select [_beg, _end - _beg + 1]
};

//default syntax
if (_this isEqualTypeParams [[],0]) exitWith {

	private _len = count _arr - 1;
	if (_beg < 0) then {_beg = _len + _beg + 1};
	
	_arr select [_beg, _len - _beg + 1]
};

// show error, suggest expected default input
[_this, "isEqualTypeParams", [[],0]] call BIS_fnc_errorParamsType;