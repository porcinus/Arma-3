
/*
	File: fn_classWeapon.sqf
	
	Author: 
		Vilem, optimised by Killzone_Kid

	Description:
		Returns class of weapon given by string.
	
	Parameter(s):
		0: <string> weapon
	
	Returns:
		<config class> weapon class read from config (test success with isClass)
*/

params ["_weapon"];

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck([_weapon],isEqualTypeArray,[""])

private _class = configFile >> "CfgWeapons" >> _weapon;

if (isClass _class) then {_class} else {configNull};
