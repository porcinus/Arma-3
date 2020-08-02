/*
	Author: 
		Killzone_Kid

	Description:
		Returns array of paths to all matching elements in deeply nested array

	Parameter(s):
		0: ARRAY - nested array
		1: ANYTHING (including nil) - element to find

	Returns:
		ARRAY
		
	Example 1:
		[[2,4,1],[2,7,0],[3]] = [[1,2,[1,2,3,4,[1,55,3,4,5,6],45,67,[55]],55],55] call BIS_fnc_findAllNestedElements;
	
	Example 2:
		[[2,2],[2,7,0]] = [[1,2,[1,2,nil,4,[1,55,3,4,5,6],45,67,[nil]],55],nil] call BIS_fnc_findAllNestedElements;
		
*/

	
/// --- validate input
#include "..\paramsCheck.inc"
#define arr [[],nil]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_arr", "_fnd", "_tmp", "_res", "_lvl", "_fnc", "_def"];

_fnc = 
{
	{
		if (isNil "_x") then 
		{
			if (!_def) then 
			{
				_tmp set [_lvl, _forEachIndex];
				_res pushBack +_tmp;
			};
		} 
		else 
		{
			if (_x isEqualType []) then 
			{
				_tmp set [_lvl, _forEachIndex];
				_lvl = _lvl + 1;
				_x call _fnc;
				_tmp resize _lvl;
				_lvl = _lvl - 1;
			} 
			else 
			{
				if (_def) then 
				{
					if (_x isEqualTo _fnd) then 
					{
						_tmp set [_lvl, _forEachIndex];
						_res pushBack +_tmp;
					};
				};
			};
		};
	} 
	forEach _this;
};

_tmp = []; _res = []; _lvl = 0;
_def = !isNil "_fnd";
_arr call _fnc;

_res
