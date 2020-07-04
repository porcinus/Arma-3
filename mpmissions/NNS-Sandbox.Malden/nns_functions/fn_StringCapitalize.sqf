/*
NNS
Capitalize first char of a string, a bit overkill but didn't found equivalent into existing BIS functions.

Example: 
_null = ["blablabla"] call NNS_fnc_StringCapitalize;

*/

// Params
params
[
	["_string",""]
];

// Check for validity
if (_string == "") exitWith {[format["NNS_fnc_StringCapitalize : nothing to do",_lamp]] call NNS_fnc_debugOutput;};

_tmpArray = _string splitString ""; //split string in array
_tmpArray set [0, toUpper (_tmpArray select 0)]; //capitalize first char

_tmpArray joinString ""