/*
	Author: 
		Killzone_Kid

	Description:
		Returns unlocalized side name

	Parameter(s):
		0: NUMBER or SIDE - either side ID or side type

	Returns:
		STRING
*/

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]

private _side = param [0, sideLogic];

if (_side isEqualType 0) exitWith {format ["%1", SIDES_ENUM param [_side, ""]]};
if (_side isEqualType sideUnknown) exitWith {str _side};

/// --- invalid input
#include "..\paramsCheck.inc"
#define arr [0,sideUnknown]
paramsCheck(_side,isEqualTypeAny,arr)