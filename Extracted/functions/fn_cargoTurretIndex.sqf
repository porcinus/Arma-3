/*
	Author: Karel Moricky, modified by Killzone_Kid

	Description:
	Return cargo index of a person turret and the other way around

	Parameter(s):
		0: OBJECT
		1: NUMBER (cargo index) or ARRAY (turret path)

	Returns:
	NUMBER (cargo index) or ARRAY (turret path)
*/

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualTypeParams,[objNull])

params ["_veh", ["_index", ""]];

if (_index isEqualType []) exitWith
{
	private _ret = -1;
	
	{
		if (_x select 4 && {_x select 3 isEqualTo _index}) exitWith {_ret = _x select 2};
	} 
	count fullCrew [_veh, "", true];
	
	_ret
};

if (_index isEqualType 0) exitWith
{
	private _ret = [];
	
	{
		if (_x select 4 && {_x select 2 isEqualTo _index}) exitWith {_ret = _x select 3};
	} 
	count fullCrew [_veh, "", true];
	
	_ret
};

// wrong index type
#define arr [objNull,0]
paramsCheck(_this,isEqualTypeParams,arr)