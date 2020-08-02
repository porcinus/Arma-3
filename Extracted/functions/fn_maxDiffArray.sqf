
/*
	File: maxDifArray.sqf
	Author: Joris-Jan van 't Land, optimised by Killzone_Kid

	Description:
	Function to return the maximum difference between all values in an array.

	Parameter(s):
	_this select 0: Array of Numbers
	
	Returns:
	Biggest difference - Number
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualTypeParams,[[]])

params ["_arr"];
paramsCheck(_arr,isEqualTypeAll,0)

_arr = +_arr;

_arr sort false;

(_arr select 0) - (_arr select count _arr - 1)