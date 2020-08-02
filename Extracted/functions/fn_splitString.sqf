/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Split string according to given separator(s)

	Parameter(s):
		0: STRING - source string
		1: STRING - separator(s) string
		2: BOOLEAN (Optional) - split method
			false or omitted: split using every individual character as separator (Example 1)
			true: split by string - separators are treated as one word (Example 2)

	Returns:
		ARRAY of STRINGs
		
	Example 1:
		["https","www","arma3","com"] = ["https://www.arma3.com", ":/."] call BIS_fnc_splitString;
		
	Example 2:
		["line1","line2","line3"] = ["line1\nline2\nline3", "\n", true] call BIS_fnc_splitString;
		
	Example 3:
		["s","p","l","i","t"] = ["split", "", true] call BIS_fnc_splitString;
*/

params ["_str", ["_sep", ""], ["_byStr", false]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_str,_sep,_byStr]
#define arr2 ["","",false]
paramsCheck(arr1,isEqualTypeParams,arr2)

//--- split by string
if (_byStr) exitWith 
{
	if (_sep isEqualTo "") exitWith {_str splitString ""};
	
	private "_pos";
	private _res = [];
	private _len = count _sep;

	while {_pos = _str find _sep; _pos > -1} do 
	{
		_res pushBack (_str select [0, _pos]);
		_str = _str select [_pos + _len];
	};

	_res pushBack _str;
	_res
};

//--- split by individual characters
if (_sep isEqualTo "") exitWith {[_str]};

_str splitString _sep