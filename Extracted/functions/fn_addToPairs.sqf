/*
	Author: Jiri Wainar, optimised by Killzone_Kid

	Description:
	Adds given value to pair array, stored under unique key.

	If value is found:
	a) both values are scalars: values are added and stored as a single scalar
	b) one or both values are array: values are added and stored as a single array
	c) anything else: an array is created and both values are stored there

	Remarks:
	Function by default modifies the input array. This can be overrriden by setting '_copyArray' param to true.

	Syntax:
	_pairs:array = [_pairs:array,_key:string,_value:number,_copyArray:bool] call BIS_fnc_addToPairs;

	Example:
	[["apple",3],["pear",12]] = [[["apple",3],["pear",2]],"pear",10] call BIS_fnc_addToPairs;
	[["apple",1],["pear",2]] = [[["apple",3],["pear",2]],"apple",-2] call BIS_fnc_addToPairs;
	[["greetings",["Hello!","Hi!"]],["rudewords",""]] = [[["greetings","Hello!"],["rudewords",""]],"greetings","Hi!"] call BIS_fnc_addToPairs;
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],""]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_pairsArray", "_findKey", ["_addValue", 1], ["_makeCopy", false]];

if (_makeCopy isEqualTo true) then {_pairsArray =+ _pairsArray};

private _index = {if (_x isEqualTypeParams ["", nil] && {_x select 0 == _findKey && {count _x == 2}}) exitWith {_forEachIndex}} forEach _pairsArray;

if (isNil "_index") exitWith 
{
	_pairsArray pushBack [_findKey, _addValue];
	_pairsArray
};

private _currentValue = _pairsArray select _index select 1;

if !([_currentValue, _addValue] isEqualTypeAll 0) then 
{
	if !(_currentValue isEqualType []) then {_currentValue = [_currentValue]};
	if !(_addValue isEqualType []) then {_addValue = [_addValue]};
};

_pairsArray set [_index, [_findKey, _currentValue + _addValue]];
_pairsArray