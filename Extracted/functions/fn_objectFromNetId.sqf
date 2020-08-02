/*
	File: 
		fn_objectFromNetId.sqf
		
	Author: 
		Killzone_Kid

	Description:
		Extends MP-only objectFromNetId functionality to SP

	Parameter(s):
		_this: STRING - netId

	Returns:
		OBJECT - object from netId
*/

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_this,isEqualType,"")

if (isMultiplayer) exitWith {objectFromNetId _this};

private _ids = BIS_functions_mainScope getVariable "BIS_fnc_netId_globIDs_SP";
private _id = _ids find _this;

// object doesn't exist
if (_id < 0) exitWith {objNull};

// return object
private _obj = _ids select (_id + 1);
if (_obj isEqualType objNull) exitWith {_obj};

objNull