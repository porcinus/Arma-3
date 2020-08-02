/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Returns true if given year is a leap year, otherwise false.

	Parameter(s):
	_this: SCALAR - year; a non-decimal number

	Example:
	_isLeapYear = 2035 call BIS_fnc_isLeapYear;

	Returns:
	BOOL - is given year a leap year or not?
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,0)

dateToNumber [_this, 12, 31, 23, 59] > 1