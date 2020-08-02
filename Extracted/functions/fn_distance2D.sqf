
/************************************************************
	Distance 2D
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [object or position 1, object or position 2]

Returns the distance between the two objects or positions
"as the crow flies" (ignoring elevation)
Example: [player, getpos dude] call BIS_fnc_distance2D
************************************************************/

params [["_pos1", -1], ["_pos2", -1]];

if (_pos1 isEqualTypeAny [objNull,[]] && _pos2 isEqualTypeAny [objNull,[]]) exitWith {_pos1 distance2D _pos2};

/// --- error, suggest one of the accepted formats
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)