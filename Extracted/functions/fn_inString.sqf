/*
	File: inString.sqf
	Author: Mika Hannola, optimised by Killzone_Kid
	
	Description:
	Find a string within a string.
	
	Parameter(s):
	_this select 0: <string> string to be found
	_this select 1: <string> string to search from
	_this select 2 (Optional): <boolean> search is case sensitive (default: false)
	
	Returns:
	Boolean (true when string is found).
	
	How to use:
	_found = ["string", "String", true] call BIS_fnc_inString;
*/

params ["_find", "_string", ["_matchcase", false]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [_find,_string]
paramsCheck(arr,isEqualTypeAll,"")
	
if (_matchcase isEqualTo true) exitWith {_string find _find > -1};

toLower _string find toLower _find > -1