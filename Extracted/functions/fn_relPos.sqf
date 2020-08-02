
/************************************************************
	Relative Position
	Author: Andrew Barron, optimised by Killzone_Kid

Parameters: [object or position, distance, direction]

Returns a position that is a specified distance and compass
direction from the passed position or object.

Example: [player, 5, 100] call BIS_fnc_relPos
************************************************************/

params ["_pos", "_dist", "_dir"];

if (_this isEqualTypeParams [[],0,0]) exitWith {(_pos getPos [_dist, _dir] select [0, 2]) + ([[],[_pos select 2]] select (count _pos > 2))};

if (_this isEqualTypeParams [objNull,0,0]) exitWith {(_pos getPos [_dist, _dir] select [0, 2]) + [getPos _pos select 2]};

/// --- error, suggest one of the accepted formats
#include "..\paramsCheck.inc"
#define arr [objNull,0,0]
paramsCheck(_this,isEqualTypeParams,arr)