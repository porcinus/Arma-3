/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Return addon from CghPatches to which a given weapon class belongs to
	
	Parameter(s):
		0: STRING
	
	Returns:
		STRING - addon class
*/

params ["_weapon"];

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck([_weapon],isEqualTypeArray,[""])

format ["toLower (getArray (_x >> 'weapons') joinString ',') find '%1' > -1", toLower _weapon] configClasses (configFile >> "CfgPatches") params [["_addon", configNull]];

configName _addon