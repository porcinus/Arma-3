
/************************************************************
	cut Decimals
	Author: Markus Kurzawa, optimised by Killzone_Kid

rounds a number to the given amount of decimal places

Example: [123.4567, 2] call BIS_fnc_cutDecimals; //123.45

************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [0,0]
paramsCheck(_this,isEqualTypeParams,arr)

parseNumber (_this select 0 toFixed (_this select 1))