/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Sets an item in pair array to given value.

	Remarks:
	Works similar to the BIS_fnc_addToPairs but it doesn't try to add values. It just overwrites the volue if the key already exists.

	Example:
	[["apple",3],["pear",10]] = [[["apple",3],["pear",2]],"pear",10] call BIS_fnc_setToPairs;
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_pairsArray", "_findKey", ["_newValue", 1]];

private _index = {if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_forEachIndex}} forEach _pairsArray;

if (isNil "_index") exitWith 
{
	_pairsArray pushBack [_findKey, _newValue];
	_pairsArray
};

_pairsArray set [_index, [_findKey, _newValue]];

_pairsArray