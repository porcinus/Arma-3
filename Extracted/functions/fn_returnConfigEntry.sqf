/*
	Author: 
		Joris-Jan van 't Land, optimized by Karel Moricky, optimised by Killzone_Kid

	Description:
		Explores parent classes in the run-time config for the value of a config entry.
	
	Parameter(s):
		0: starting config class (Config)
		1: queried entry name (String)
		2: (Optional) default value returned in case the entry does not exist
	
	Returns:
		Number / String - value of the found entry
*/


params [["_config", configFile], ["_entryName", ""], "_defaultValue"];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_config,_entryName]
#define arr2 [configNull,""]
paramsCheck(arr1,isEqualTypeArray,arr2)

if !(_entryName isEqualTo "") then {_config = _config >> _entryName};

if (isNumber _config) exitWith {getNumber _config};
if (isText _config) exitWith {getText _config};
if (isArray _config) exitWith {getArray _config};

if (isNil "_defaultValue") exitWith {nil};

_defaultValue