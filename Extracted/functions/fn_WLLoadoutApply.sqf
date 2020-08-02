/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Reapply a saved loadout.
*/

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - BIS_WL_lastLoadoutCost, TRUE];

BIS_WL_loadoutApplied = TRUE;
_this setUnitLoadout BIS_WL_lastLoadout;

[toUpper localize "STR_A3_WL_loadout_applied"] spawn BIS_fnc_WLSmoothText;
playSound "AddItemOK";