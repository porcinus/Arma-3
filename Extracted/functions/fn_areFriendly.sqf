/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Compares two sides and returns if they are allies

	Parameter(s):
		0: SIDE
		1: SIDE

	Returns:
		BOOLEAN - true if allies
*/

#define FRIENDSHIP_CONST 0.6

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [sideUnknown,sideUnknown]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_sideA", "_sideB"];

if (_sideA in [civilian, sidelogic] || _sideB in [civilian, sidelogic]) exitWith {true}; /// --- BFF with civilians

_sideA getFriend _sideB >= FRIENDSHIP_CONST && _sideB getFriend _sideA >= FRIENDSHIP_CONST