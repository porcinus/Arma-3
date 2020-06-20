/*
NNS
Capitalize first char of a string, a bit overkill but didn't found equivalent into existing BIS functions.

Example: 
_null = ["blablabla"] call BIS_fnc_NNS_StringCapitalize;

*/

// Params
params
[
	["_string",""]
];

// Check for validity
if (_string == "") exitWith {[format["BIS_fnc_NNS_StringCapitalize : nothing to do",_lamp]] call BIS_fnc_NNS_debugOutput;};

_tmpArray = _string splitString ""; //split string in array
_tmpArray set [0, toUpper (_tmpArray select 0)]; //capitalize first char

_tmpArray joinString ""