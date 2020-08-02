
/************************************************************
	Remove Index
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [array, index, <end index>] OR [array, [indexes]]

Takes an array, and returns a new array with the specified index(es)
removed.

This takes the array passed in the first parameter, and returns
an array that has the index number in the second parameter removed.

If a third parameter is passed, then a range of indexes will be removed.

Alternatively, you can pass an array of indexes to remove in the
second parameter.

This function doesn't touch the original array (that is passed as a parameter).

	Examples:

_array = [1,["b"],"c",[4],"d"];

[_array, 2]       call BIS_fnc_removeIndex; //returns: [1,["b"],[4],"d"]
[_array, [0,1,3]] call BIS_fnc_removeIndex; //returns: ["c","d"]
[_array, 2, 3]    call BIS_fnc_removeIndex; //returns: [1,["b"],"d"]
************************************************************/

params ["_arr", "_beg", "_end"];

//alt syntax
if (_this isEqualTypeParams [[],0,0]) exitWith {
	_arr = +_arr;
	_arr deleteRange [_beg, _end - _beg + 1];
	_arr
};

//default syntax
if (_this isEqualTypeParams [[],0]) exitWith {
	_arr = +_arr;
	_arr deleteAt _beg;
	_arr
};

//alt syntax
if (_this isEqualTypeParams [[],[]]) exitWith {
	_arr = +_arr;
	_beg = +_beg;
	_beg sort false;
	{_arr deleteAt _x} forEach _beg;
	_arr
};

// show error for expected default input
[_this, "isEqualTypeParams", [[],0]] call BIS_fnc_errorParamsType;

