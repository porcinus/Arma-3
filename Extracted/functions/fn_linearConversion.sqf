/*
	File: fn_linearConversion.sqf
	Author: Joris-Jan van 't Land, optimised by Killzone_Kid

	Description:
	Linear conversion of a value from one set to another.

	Parameter(s):
	_this select 0: Array (originalSet)
		Note: should be two elements [minimumValue, maximumValue]
	_this select 1: Scalar (originalValue)
	_this select 2: Array (newSet)
		Note: should be two elements [minimumValue, maximumValue]
	
	Returns:
	Scalar (newValue)
*/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],0,[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_orgSet", "_orgValue", "_newSet"];
private _params = _orgSet + [_orgValue] + _newSet;

/// --- validate command input
#define arr [0,0,0,0,0]
paramsCheck(_params,isEqualTypeArray,arr)

linearConversion _params