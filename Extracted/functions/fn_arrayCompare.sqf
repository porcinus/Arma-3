//------------------
// Author: Philipp Pilhofer (raedor), optimised by Killzone_Kid
// Purpose: This function checks if two arrays are containing the same elements in the same order
// Arguments: [array1, array2]
// Return: boolean
// [array1, array2] call BIS_fnc_arrayCompare;
//------------------

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr [[],[]]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr1", "_arr2"];

_arr1 isEqualTo _arr2