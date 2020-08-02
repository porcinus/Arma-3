/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns side ID (as used in config).

	Parameter(s):
		0: SIDE

	Returns:
		NUMBER
*/

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]

private _side = param [0, sideLogic];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_side,isEqualType,sideUnknown)

SIDES_ENUM find _side