/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns side type based on side ID

	Parameter(s):
		0: NUMBER

	Returns:
		SIDE
*/

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]

private _sideID = param [0, 4];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_sideID,isEqualType,0)

SIDES_ENUM param [_sideID, sideUnknown]