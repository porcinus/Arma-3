/*
	Author: 
		Killzone_Kid
	
	Description:
		Returns vectorDirAndUp of object 1 relative to object 2
	
	Parameter(s):
		0: [Object] - object 1
		1: [Object] - object 2
		2: [Boolean] - (Optional) if true - result is in render scope, false - simulation scope. Default: true
	
	Returns:
		[Array] in format [vectorDir, vectorUp]
	
	Example:
		_vectorDirAndUp = [tank, car] call BIS_fnc_vectorDirAndUpRelative;
*/


/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,objNull]
paramsCheck(_this,isEqualTypeParams,arr)

params ["_obj1", "_obj2", ["_visual", true]];

if (_visual isEqualTo true) exitWith
{
	[
		_obj2 vectorWorldToModelVisual vectorDirVisual _obj1,
		_obj2 vectorWorldToModelVisual vectorUpVisual _obj1
	]
};

[
	_obj2 vectorWorldToModel vectorDir _obj1,
	_obj2 vectorWorldToModel vectorUp _obj1
]