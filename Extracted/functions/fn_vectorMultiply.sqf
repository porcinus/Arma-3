
/************************************************************
	Vector Multiply
	Author: From VBS1 Core, optimised by Killzone_Kid

Operand types:
<vector1>: array
<scale>: number
<resultant vector>: array

Returns a unit vector that 'points' from <vector1> to <vector2>.
This is a very useful function, as it can be used with the velocity
command to move an object from one position to another.
(ie <vector1> to <vector2>) - ensure both positions are found using getposasl.

<resultant vector> = [<vector>,<scale>] call BIS_fnc_vectorMultiply
************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],0]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_vec", "_scale"];

if (count _vec isEqualTo 3) exitWith {_vec vectorMultiply _scale};

private _ret = []; 
{_ret append [_x * _scale]} count _vec;

_ret
