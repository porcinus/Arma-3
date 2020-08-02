
/************************************************************
	Vector Add
	Author: From VBS1 Core, modified by Vilem (arbitrary no of dimensions dimensions), optimised by Killzone_Kid

<difference> = [<vector1>,<vector2>] call BIS_fnc_vectorAdd

Operand types:
<difference>: array
<vector1>: array
<vector2>: array

Returns a vector that is the sum of <vector1> and <vector2>.

************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_v1", "_v2"];

if (count _v1 isEqualTo 3) exitWith {_v1 vectorAdd _v2};

private _ret = []; 
{_ret pushBack (_x + (_v2 select _forEachIndex))} forEach _v1;

_ret