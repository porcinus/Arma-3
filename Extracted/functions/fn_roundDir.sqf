/*
	Author: Karel Moricky, optimised by Killzone_Kid

	Description:
	Round direction to nearest limit
	(used for determining cardinal direction)

	Parameter(s):
	_this select 0: NUMBER - direction
	_this select 1 (Optional): NUMBER - limit direction (default: 90)

	Returns:
	NUMBER - rounded direction
*/

params ["_dir",["_section",90]];

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr1 [_dir,_section]
#define arr2 [0,0]
paramsCheck(arr1,isEqualTypeParams,arr2)

if (_section isEqualTo 0) exitWith {_dir};

round (_dir / _section) * _section