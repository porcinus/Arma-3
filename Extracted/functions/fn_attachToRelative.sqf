/*
	Author: 
		Killzone_Kid
	
	Description:
		Attaches object 1 to object 2 preserving object 1 position 
		and orientation against object 2
	
	Parameter(s):
		0: [Object] - object 1
		1: [Object] - object 2
		2: [Boolean] - (Optional) if true - render scope is used, false - simulation scope. Default: true
	
	Returns:
		[Nothing]
	
	Example:
		[tank, car] call BIS_fnc_attachToRelative;
*/


/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_obj1", "_obj2", ["_visual", true]];

private _orient = _this call (missionNamespace getVariable "BIS_fnc_vectorDirAndUpRelative");

_obj1 attachTo [_obj2];
_obj1 setVectorDirAndUp _orient;