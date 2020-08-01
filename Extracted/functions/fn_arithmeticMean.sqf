
/************************************************************
	Arithmetic Mean
	Author: Andrew Barron, optimised by Killzone_Kid

Returns the arithmetic mean (average) of an array of numbers

Example: [1,2,3,4,5,6,7,8,9] call BIS_fnc_arithmeticMean; //5

************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])
paramsCheck(_this,isEqualTypeAll,0)

private _ret = 0;
{_ret = _ret + _x} count _this;

_ret / count _this