/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Checks if the given unit is inside a specific sector.
*/

private ["_unit", "_sector", "_checkUnlocked", "_diffX", "_diffY", "_restrictedArea", "_pos"];

_unit = _this # 0;
_sector = _this # 1;

_checkUnlocked = FALSE;
_pos = [];
if (typeName _unit == typeName objNull) then {
	_pos = position _unit;
} else {
	_pos = _unit;
};

if (count _this > 2) then {_checkUnlocked = _this # 2};

_restrictedArea = (_sector getVariable "Size") / 2;
if !(_checkUnlocked) then {_restrictedArea = _restrictedArea + (_sector getVariable ["Border", 200])};

_diffX = abs ((_pos # 0) - ((position _sector) # 0));
_diffY = abs ((_pos # 1) - ((position _sector) # 1));

_diffX <= _restrictedArea && _diffY <= _restrictedArea && (if (typeName _unit == typeName objNull) then {alive _unit} else {TRUE})