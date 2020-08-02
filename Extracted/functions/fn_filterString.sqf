/*
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Removes characters from a string based on the list of allowed characters.

	Parameter(s):
		0: STRING - Filtered text
		1: (Optional) STRING - Filter (default: A-Z, a-z, 0-9 and "_")

	Returns:
		STRING
*/

params ["_string", ["_filter", "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr [_string,_filter]
paramsCheck(arr,isEqualTypeAll,"")

_string = toArray _string;

toString (_string - (_string - toArray _filter))