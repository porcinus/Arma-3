
/************************************************************
	Direction To
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [object or position 1, object or position 2]

Returns the compass direction from object/position 1 to
object/position 2. Return is always >=0 <360.

Example: [player, getpos dude] call BIS_fnc_dirTo
************************************************************/

params [["_pos1", -1], ["_pos2", -1]];

if (_pos1 isEqualTypeAny [objNull,[]] && _pos2 isEqualTypeAny [objNull,[]]) exitWith {_pos1 getDir _pos2};

/// --- error, suggest one of the accepted formats
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)