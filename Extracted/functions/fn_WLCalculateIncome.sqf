/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Recalculate CP income for a specific side.
*/

private ["_income"];

_income = 0;

{
	if ((_x getVariable "BIS_WL_sectorSide") == _this) then {_income = _income + ((_x getVariable "BIS_WL_value") * BIS_WL_CPIncomeMult)};
} forEach BIS_WL_sectors;

_income