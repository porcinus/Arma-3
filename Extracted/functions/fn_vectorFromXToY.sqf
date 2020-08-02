
/************************************************************
	Vector From X to Y
	Author: From VBS1 Core, optimised by Killzone_Kid

<resultant vector> = [<vector1>,<vector2>] call BIS_fnc_vectorFromXToY

Operand types:
<vector1>: array
<vector2>: array
<resultant vector>: array

Returns a unit vector that 'points' from <vector1> to <vector2>.
This is a very useful function, as it can be used with the velocity
command to move an object from one position to another
(ie <vector1> to <vector2>) - ensure both positions are found using getposasl.
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_v1", "_v2"];

if (count _v1 isEqualTo 3) exitWith {_v1 vectorFromTo _v2};

_this call BIS_fnc_vectorDiff call BIS_fnc_unitVector