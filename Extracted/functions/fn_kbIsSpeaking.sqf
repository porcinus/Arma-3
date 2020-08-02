/*
	Author: Karel Moricky

	Description:
	Check if speaker is locked for different conversation

	Parameter(s):
	_this: OBJECT

	Returns:
	BOOL - true if locked
*/

_unit = _this param [0,objnull,[objnull]];
!isnil {_unit getvariable "bis_fnc_kbTell"}