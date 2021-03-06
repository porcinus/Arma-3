/*
	Author: Karel Moricky

	Description:
	Add virtual backpacks to an object (e.g., ammo box).
	Virtual items can be selected in the Arsenal.

	Parameter(s):
		0: OBJECT - objct to which backpacks will be added
		1: STRING or ARRAY of STRINGs - backpack class(es) to be added
		2 (Optional): BOOL - true to add backpacks globally (default: false)
		3 (Optional): BOOL - true to add Arsenal action (default: true)

	Returns:
	ARRAY of ARRAYs - all virtual items within the object's space in format [<items>,<weapons>,<magazines>,<backpacks>]
*/

private ["_object","_classes","_isGlobal","_initAction"];
_object = _this param [0,missionnamespace,[missionnamespace,objnull]];
_classes = _this param [1,[],["",true,[]]];
_isGlobal = _this param [2,false,[false]];
_initAction = _this param [3,true,[true]];
[_object,_classes,_isGlobal,_initAction,1,3] call bis_fnc_addVirtualItemCargo;