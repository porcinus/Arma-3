/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Searches the associative array for the 1st occurance of the key string and returns the value associated with it.

	Syntax:
	_value = [_associativeArray:array,_key:string,_defaultValue] call BIS_fnc_getFromPairs;

	Example:
	2 = [[["apple",3],["pear",2]],"pear"] call BIS_fnc_getFromPairs;

	Returns:
	* if found: value stored under the key
	* if not found: nil or _defaultValue
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_pairsArray", "_findKey", "_defaultValue"];

{if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_defaultValue = _x select 1}} forEach _pairsArray;

if (isNil "_defaultValue") exitWith {nil};

_defaultValue