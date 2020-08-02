/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Return addon from CfgPatches to which a given object belongs to
	
	Parameter(s):
		0: OBJECT
	
	Returns:
		STRING - addon class
*/

params ["_object"];

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck([_object],isEqualTypeArray,[objNull])

unitAddons typeOf _object params [["_addon", ""]];

_addon
