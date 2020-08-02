/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns localized side name

	Parameter(s):
		0: NUMBER or SIDE - either side ID or side type

	Returns:
		STRING
*/

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]
#define SIDES_NAMES ["STR_EAST", "STR_WEST", "STR_GUERRILA", "STR_CIVILIAN", "STR_DN_UNKNOWN", "STR_DISP_CAMPAIGN_ENEMY", "STR_DISP_CAMPAIGN_FRIENDLY", "STR_LOGIC", "STR_EMPTY", "STR_AMBIENT_LIFE"]

private _side = param [0, sideLogic];

if (_side isEqualType sideUnknown) then {_side = SIDES_ENUM find _side};
if (_side isEqualType 0) exitWith {localize (SIDES_NAMES param [_side, ""])};

/// --- invalid input
#include "..\paramsCheck.inc"
#define arr [0,sideUnknown]
paramsCheck(_side,isEqualTypeAny,arr)
