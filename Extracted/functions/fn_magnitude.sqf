
/************************************************************
	Magnitude
	Author: Andrew Barron, optimised by Killzone_Kid

Returns the magnitude of an array of numbers (a vector).
The vector can have any number of elements (2, 3, etc).
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

if (count _this isEqualTo 3) exitWith {vectorMagnitude _this};

private _ret = 0;
{_ret = _ret + _x ^ 2} count _this;

sqrt _ret