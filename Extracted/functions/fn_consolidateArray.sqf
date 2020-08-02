/*
	Author: 
		Jiri Wainar, optimised by Killzone_Kid

	Description:
		Finds duplicities in the given array of anything and consolidates them into an array of sub-arrays
	
	Syntax:
		array call BIS_fnc_consolidateArray;
		
	Parameter(s):
		array: ARRAY - array of anything
		
	Return:
		ARRAY - array of sub-arrays in format [[value, count],...], where:
			value: ANYTHING - consolidated element
			count: NUMBER - occurence count

	Example 1:
		["apple","apple","pear","pear","apple"] call BIS_fnc_consolidateArray;
		// Return: [["apple",3],["pear",2]]
	
	Example 2:
		["apple","apple",1,1,nil,nil] call BIS_fnc_consolidateArray;
		// Return: [["apple",2],[1,2],[any,2]]
*/

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])

private _cnt = count _this;
private _cntNil = count (_this - _this);
private _ret = [];

{_ret append [[_x, _cnt - count (_this - [_x])]]} count (_this arrayIntersect _this);

if (_cntNil > 0) then {_ret pushBack [nil, _cntNil]};

_ret