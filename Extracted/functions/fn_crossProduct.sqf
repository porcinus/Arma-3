
/************************************************************
	Cross Product
	Author: Andrew Barron, optimised by Killzone_Kid
	
Returns the cross product of two 3D vectors.
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_v1", "_v2"];

_v1 vectorCrossProduct _v2