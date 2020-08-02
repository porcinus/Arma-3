/************************************************************
	Dot Product
	Author: Andrew Barron, optimised by Killzone_Kid
	
Returns the dot product of two vectors.
The vectors can have any number of elements (2, 3, etc), but
they must have the same number.
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_v1", "_v2"];

if (count _v1 isEqualTo 3) exitWith {_v1 vectorDotProduct _v2};

private _ret = 0;
{_ret = _ret + _x * (_v2 select _forEachIndex)} forEach _v1;

_ret

