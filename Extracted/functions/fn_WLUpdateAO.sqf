/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Recalculates AO info (sector distribution).
*/

{
	missionNamespace setVariable [format ["BIS_WL_lastSectorCnt_%1", _x], count (([_x] call BIS_fnc_WLsectorListing) # 0)];
} forEach [WEST, EAST];