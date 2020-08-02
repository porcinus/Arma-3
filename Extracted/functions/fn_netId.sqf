/*
	File: 
		fn_netId.sqf
		
	Author: 
		Killzone_Kid

	Description:
		Extends MP-only netId functionality to SP

	Parameter(s):
		_this: OBJECT or GROUP

	Returns:
		STRING - netId in format "owner:id"
*/

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [objNull,grpNull]
paramsCheck(_this,isEqualTypeAny,arr)

if (isMultiplayer) exitWith {netId _this};
if (isNull _this) exitWith {""};

private _ids = BIS_functions_mainScope getVariable "BIS_fnc_netId_globIDs_SP";
private _id = _ids find _this;

// doesn't exist, add it
if (_id < 0) then
{
	_ids append ["", _this];
	_id = _ids find _this; // find it again to make it safe for scheduled environment
	_ids set [_id - 1, format ["0:%1", (_id + 1) / 2]];
};

// return netId
_ids select (_id - 1)