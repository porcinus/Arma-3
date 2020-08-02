/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Refreshes a side's available services.
*/

private ["_sector"];

BIS_WL_sectorsArrayWEST = [WEST] call BIS_fnc_WLSectorListing;
BIS_WL_sectorsArrayEAST = [EAST] call BIS_fnc_WLSectorListing;
BIS_WL_sectorsArrayFriendly = if (side group player == WEST) then {BIS_WL_sectorsArrayWEST} else {BIS_WL_sectorsArrayEAST};
BIS_WL_servicesAvailable = [];
{
	_sector = _x;
	{BIS_WL_servicesAvailable pushBackUnique _x} forEach (_sector getVariable "BIS_WL_sectorSpecial");
} forEach (BIS_WL_sectorsArrayFriendly # 0);