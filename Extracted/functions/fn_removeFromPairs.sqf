/*
	Author: Jiri Wainar, modified by Killzone_Kid

	Description:
	Removes an item from pair array modifying original array. This can be overriden by setting '_copyArray' param to true.
	
	Syntax:
	_value = [_associativeArray:array,_key:string,_copyArray:bool] call BIS_fnc_removeFromPairs;

	Example:
	[["apple",3]] = [[["apple",3],["pear",2]],"pear"] call BIS_fnc_removeFromPairs;

	Returns:
	* resulting modified array or a copy
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_pairsArray", "_findKey", ["_makeCopy", false]];

if (_makeCopy isEqualTo true) then {_pairsArray =+ _pairsArray};

{if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_pairsArray deleteAt _forEachIndex}} forEach _pairsArray;

_pairsArray