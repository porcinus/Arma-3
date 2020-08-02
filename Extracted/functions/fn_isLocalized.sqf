/*
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Checks if given key name exists in ingame localisation database.

	Parameter(s):
	_this: STRING

	Returns:
	BOOL
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,"")

isLocalized _this
