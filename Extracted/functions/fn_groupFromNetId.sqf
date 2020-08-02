/*
	File: 
		fn_groupFromNetId.sqf
		
	Author: 
		Killzone_Kid

	Description:
		Extends MP-only groupFromNetId functionality to SP

	Parameter(s):
		_this: STRING - netId

	Returns:
		GROUP - group from netId
*/

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,"")

if (isMultiplayer) exitWith {groupFromNetId _this};

private _ids = BIS_functions_mainScope getVariable "BIS_fnc_netId_globIDs_SP";
private _id = _ids find _this;

// group doesn't exist
if (_id < 0) exitWith {grpNull};

// return group
private _grp = _ids select (_id + 1);
if (_grp isEqualType grpNull) exitWith {_grp};

grpNull