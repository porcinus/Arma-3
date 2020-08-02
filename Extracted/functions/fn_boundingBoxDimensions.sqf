
/*
	File: fn_boundingBoxDimensions.sqf
	Author: Joris-Jan van 't Land, optimised by Killzone_Kid

	Description:
	Returns the sizes of the three dimension of an object's bounding box.

	Parameter(s):
	_this: Object (object)
	
	Returns:
	Array (dimensions)
		0: x
		1: y
		2: z
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,objNull)

private _diff = (boundingBox _this select 1) vectorDiff (boundingBox _this select 0);

[_diff vectorDotProduct [1,0,0], _diff vectorDotProduct [0,1,0], _diff vectorDotProduct [0,0,1]]
