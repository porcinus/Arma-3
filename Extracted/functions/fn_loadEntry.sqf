/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Searches for config entry in mission, campaign and then in global config file.
	
	Parameter(s):
		0: ARRAY of STRINGs - path
		1: CONFIG - default path used in case when the original one is not found
	
	Returns:
		CONFIG entry
*/

params [["_path", []], ["_default", configFile], "_core"];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_path,_default]
#define arr2 [[],configNull]
paramsCheck(arr1,isEqualTypeArray,arr2)

if !(_path isEqualTypeAll "") exitWith {["Error: Path must be ARRAY of STRINGs in %1 on index 0", _this] call BIS_fnc_error; _default};
_path = format ['>> "%1"', _path joinString '" >> "'];

_core = call compile ("missionConfigFile" + _path);
if (!isNull _core && !isClass _core) exitWith {_core};

_core = call compile ("campaignConfigFile" + _path);
if (!isNull _core && !isClass _core) exitWith {_core};

_core = call compile ("configFile" + _path);
if (!isNull _core && !isClass _core) exitWith {_core};

_default
