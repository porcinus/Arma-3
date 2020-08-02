/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Searches the associative array for the 1st occurance of the key string and returns it's index.

	Syntax:
	_index:number = [_associativeArray:array,_key:string] call BIS_fnc_findInPairs;

	Example:
	0 = [[["apple",3],["pear",2]],"apple"] call BIS_fnc_findInPairs;

	Returns:
	* if found: index (starting from 0)
	* if not found: -1
*/


/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_pairsArray", "_findKey"];

private _index = {if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_forEachIndex}} forEach _pairsArray;

if (isNil "_index") exitWith {-1};

_index