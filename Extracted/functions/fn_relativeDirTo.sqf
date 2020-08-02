
/************************************************************
	Relative Direction To
	Author: Andrew Barron

Parameters: [object 1, object or position 2]

Returns the relative direction from object 1 to
object/position 2. Return is always 0-360.

A position to the right of unit would be at a relative direction of 90 degrees, for example.

Example: [player, getpos dude] call BIS_fnc_relativeDirTo
************************************************************/

params [["_obj", -1], ["_pos", -1]];

if (_obj isEqualType objNull && _pos isEqualTypeAny [objNull,[]]) exitWith {_obj getRelDir _pos};

/// --- error, suggest one of the accepted formats
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)