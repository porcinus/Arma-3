
/************************************************************
	Rotate 2D Vector
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [[vector], angle]
Returns: [vector]

This function returns a 2D vector rotated a specified number
of degrees around the origin.
************************************************************/


/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[0,0],0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_v", "_d"];
_v params ["_x", "_y"];

_v = +_v;

_v set [0, _x * cos _d - _y * sin _d];
_v set [1, _x * sin _d + _y * cos _d];

_v
