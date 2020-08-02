/*
	Author: 
		Killzone_Kid

	Description:
		Determines if side B is enemy to side A the way game the engine does it.
		The relationship table can be found here:  https://community.bistudio.com/wiki/Side_relations. 

	Parameter(s):
		0: SIDE - side A
		1: SIDE - side B

	Returns:
		BOOLEAN
*/


/// --- validate input
#include "..\paramsCheck.inc"
#define arr [sideUnknown,sideUnknown]
paramsCheck(_this,isEqualTypeParams,arr)

/// --- engine constants
#define SIDES_ENUM [east, west, independent, civilian, sideUnknown, sideEnemy, sideFriendly, sideLogic, sideEmpty, sideAmbientLife]
#define FRIENDSHIP_CONST 0.6

params ["_center", "_side"];

private _index = SIDES_ENUM find _side;

if (_index isEqualTo 6) exitWith {false};
if (_index isEqualTo 5) exitWith {true};

if (_index < 0 || _index >= 4) exitWith {false};

_center getFriend _side < FRIENDSHIP_CONST	