
/*
	File: fn_boundingCircle.sqf
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Returns size of bounding circle (calculated from X and Y coordinates)

	Parameter(s):
	_this: Object

	Returns:
	Number
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,objNull)

(boundingBox _this select 0) distance2D (boundingBox _this select 1)
