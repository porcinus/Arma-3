/*
NNS
Not Mario Kart Knockoff
Replace string space with unbreakable space.
*/

params ["_str"];

private _returnStr = _str;
if !(count (str _str) == 0) then {
	private _tmpArr = _str splitString " ";
	_returnStr = _tmpArr joinString "&#160;";
};

_returnStr;