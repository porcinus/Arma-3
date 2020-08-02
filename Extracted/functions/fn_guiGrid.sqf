/*
	Author: 
		Karel Moricky, tweaked by Killzone_Kid

	Description:
		Returns grid params stored in profile

	Parameter(s):
		0: STRING - category name
		1: STRING - grid name

	Returns:
		ARRAY - format [x,y,w,h]
*/

params 
[
	["_tagName", "GUI", [""]],
	["_gridName", "GRID", [""]]
];

private _varBase = format ["%1_%2_", _tagName, _gridName];
private _values = [-1,-1,-1,-1];
private _error = false;

{
	private _value = profileNamespace getVariable [_varBase + _x, -1];
	if !(_value isEqualType 0) exitWith { _error = true };
	_values set [_forEachIndex, _value];
} 
forEach ["X","Y","W","H"];

if (_error) then { ["Profile variable '%1' doesn't exist or contains wrong data", _varBase] call BIS_fnc_error };

_values 