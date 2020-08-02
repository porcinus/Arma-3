/*
	File: fn_findExtreme.sqf
	Author: Joris-Jan van 't Land, optimised by Killzone_Kid

	Description:
	Returns the minimum or maximum value in an Array.

	Parameter(s):
	_this select 0: Array (array)
	_this select 1: Scalar (mode)
		0: minimum
		1: maximum
	
	Returns:
	Scalar (extreme)
*/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr", "_mode"];

if (_mode > 0) exitWith {selectMax _arr};

selectMin _arr 