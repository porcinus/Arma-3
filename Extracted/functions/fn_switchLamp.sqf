/*
	Author: Karel Moricky

	Description:
	Switch streetlamp on/off

	Parameter(s):
		0: OBJECT
		1: BOOL - true to turn the light on

	Returns:
	NOTHING
*/

params [
	["_lamp",objnull,[objnull]],
	["_state",true,[true]]
];
_lamp switchlight (["off","on"] select _state);