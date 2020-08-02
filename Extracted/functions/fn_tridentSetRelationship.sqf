/*
	Author: Karel Moricky

	Description:
	Set relationship of competing Trident sides.
	When the value reaches threshold, side relationship will change.
	The value slowly decreases towards 0.

	Parameter(s):
		0: SIDE
		1: SIDE
		2: NUMBER - changed value
		3: BOOL - true to add the value, false to set the value

	Returns:
	NUMBER - relationship value after change
*/

private ["_sideA","_sideB","_value","_isRelative","_sideIDA","_sideIDB","_sideID","_relationshipVariable"];

_sideA = _this param [0,sideUnknown,[sideUnknown]];
_sideB = _this param [1,sideUnknown,[sideUnknown]];
_value = _this param [2,0,[0]];
_isRelative = _this param [3,true,[true]];

if (_sideA == _sideB) exitwith {["Cannot set relationship of %1 towards itself. Use two different sides.",_sideA] call bis_fnc_error; 0};

_sideIDA = _sideA call bis_fnc_sideID;
_sideIDB = _sideB call bis_fnc_sideID;
_sideID = _sideIDA * 2 + _sideIDB * 2;

_relationshipVariable = "BIS_fnc_trident_" + str _sideID;
if (_isRelative) then {
	_value = _value + (missionnamespace getvariable [_relationshipVariable,0]);
};

missionnamespace setvariable [_relationshipVariable,_value];
publicvariable _relationshipVariable;

_value