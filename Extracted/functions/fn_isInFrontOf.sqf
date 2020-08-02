/*
	File: 
		fn_isInFrontOf.sqf
		
	Author: 
		Philipp Pilhofer (raedor), optimised by Killzone_Kid

	Description:
		This function checks, if object2 is in front of object1

	Parameter(s):
		_this: ARRAY in format:
			0: OBJECT - object1
			1: OBJECT - object2
			2: NUMBER (optional) - virtual offset (>0 move object1 forward, <0 move object1 back). Default: 0
			
	Returns:
		BOOLEAN - true means in front
		
	Example:
		_carIsInFrontOfPlayer = [player, car, 1] call BIS_fnc_isInFrontOf
*/

params ["_obj1", "_obj2", ["_offset", 0]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_obj1,_obj2,_offset]
#define arr2 [objNull,objNull,0]
paramsCheck(arr1,isEqualTypeArray,arr2)

((_obj1 worldToModel getPos _obj2) select 1) - _offset > 0