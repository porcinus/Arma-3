/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Opens Arsenal interface.
*/

_funds = player getVariable "BIS_WL_funds";

"close" call BIS_fnc_WLPurchaseMenu;

_null = ["Open", TRUE] spawn BIS_fnc_arsenal;

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - BIS_WL_arsenalCost, TRUE];