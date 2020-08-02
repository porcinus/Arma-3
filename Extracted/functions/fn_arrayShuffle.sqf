/*
	Author:
		Nelson Duarte, optimised by Killzone_Kid

	Description:
		This returns a new array with randomized order of elements from input array

	Parameters:
		_this: ARRAY

	Returns:
		ARRAY

	Example:
	[1, 2, 3] call BIS_fnc_arrayShuffle
	Returns: [2, 3, 1] (For example)
*/
 
/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,[])
 
_this = +_this;
 
private _res = [];
       
for "_i" from count _this to 1 step -1 do
{
	_res pushBack (_this deleteAt floor random _i);
};
 
_res append _this;
 
_res