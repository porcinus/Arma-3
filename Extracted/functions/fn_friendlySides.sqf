/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns sides allied to the given side / object

	Parameter(s):
		0: SIDE or OBJECT

	Returns:
		ARRAY of SIDEs
*/

#define FRIENDSHIP_CONST 0.6

private _side = param [0, objNull];

if (_side isEqualType objNull) then {_side = side _side};

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_side,isEqualType,sideUnknown)

private _friendly = [sideFriendly];

{
	if (_side getFriend _x >= FRIENDSHIP_CONST) then 
	{
		_friendly append [_x];
	};
} 
count [east, west, resistance, civilian];

_friendly