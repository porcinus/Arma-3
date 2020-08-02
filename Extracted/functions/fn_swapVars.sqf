
/************************************************************
	Swap Variables
	Author: Andrew Barron, modified by Killzone_Kid

Parameters: ["variable name 1", "variable name 2"]

Swaps the values of two variables, passed in quotes.

Nothing is returned, as this function modifies the variables
directly.

Example:

_a = 1;
_b = 2;
["_a","_b"] call BIS_fnc_swapVars
//_a now equals 2
//_b now equals 1

************************************************************/

/// --- validate general input
#include "..\paramsCheck.inc"
#define arr ["",""]
paramsCheck(_this,isEqualTypeParams,arr)

if ({
	_x isEqualTo (toArray _x call {
		toString (_this - (_this - [
			65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,
			83,84,85,86,87,88,89,90,97,98,99,100,101,102,103,104,
			105,106,107,108,109,110,111,112,113,114,115,116,117,
			118,119,120,121,122,48,49,50,51,52,53,54,55,56,57,95
		]))
	}) && "0123456789" find (_x select [0,1]) < 0
} count _this < 2) exitWith {
	["Invalid variable name in: %1", _this] call BIS_fnc_error; 
	nil
};

call compile format (["%1 = [%2, %1]; %2 = %1 select 1; %1 = %1 select 0"] + _this);

