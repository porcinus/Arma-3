
/************************************************************
	Geometric Mean
	Author: Andrew Barron, optimised by Killzone_Kid

Returns the geometric mean (weighted average) of an array of numbers

Example: [1,2,3,5,6] call BIS_fnc_geometricMean; //2.82523

************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])
paramsCheck(_this,isEqualTypeAll,0)

private _ret = 1;
{_ret = _ret * _x} count _this;

abs _ret ^ (1 / count _this)
