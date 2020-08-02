
/*
	File: fn_classMagazine.sqf
	
	Author: 
		Vilem, optimised by Killzone_Kid

	Description:
		Returns class of magazine given by string.
	
	Parameter(s):
		0: <string> magazine
	
	Returns:
		<config class> magazine class readed from config (test success with isClass)
*/

params ["_magazine"];

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck([_magazine],isEqualTypeArray,[""])

private _class = configFile >> "CfgMagazines" >> _magazine;

if (isClass _class) then {_class} else {configNull};