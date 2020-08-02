/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sector scan routine (selection part).
*/

_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
_conqueredSectorsVarID = format ["BIS_WL_conqueredSectors_%1", side group player];

if (typeName _this == typeName FALSE) exitWith {
	player setVariable ["BIS_WL_scanPos", group player];
};

"close" call BIS_fnc_WLPurchaseMenu;

BIS_WL_currentSelection = "scan";
[toUpper localize "STR_A3_WL_popup_scan"] spawn BIS_fnc_WLSmoothText;
"Sector" call BIS_fnc_WLSoundMsg;
processDiaryLink createDiaryLink ["Map", player, ""];

_iconGrpPool = [];
player setVariable ["BIS_WL_scanPos", objNull];

{
	_icon = _x getVariable "BIS_WL_pointer";
	_iconGrp = group _icon;
	_iconGrp setVariable ["BIS_WL_available", TRUE];
	_iconGrpPool pushBack _iconGrp;
	_iconGrp setVariable ["BIS_WL_scanPos", _x];
} forEach (missionNamespace getVariable _conqueredSectorsVarID) + (if (isNull (missionNamespace getVariable _currentSectorVarID)) then {[]} else {[missionNamespace getVariable _currentSectorVarID]});

_iconGrpPool spawn BIS_fnc_WLOutlineIcons;
{
	removeMissionEventHandler ["GroupIconClick", missionNamespace getVariable [_x, -1]];
} forEach ["BIS_WL_dropPosSelectionHandler", "BIS_WL_fastTravelPosSelectionHandler", "BIS_WL_ScanPosSelectionHandler", "BIS_WL_sectorSelectionHandler"];
BIS_WL_ScanPosSelectionHandler = addMissionEventHandler ["GroupIconClick", {if ((_this # 1) getVariable "BIS_WL_available") then {removeMissionEventHandler ["GroupIconClick", BIS_WL_ScanPosSelectionHandler]; player setVariable ["BIS_WL_scanPos", (_this # 1) getVariable "BIS_WL_scanPos"]}}];

waitUntil {!isNull (player getVariable "BIS_WL_scanPos") || !visibleMap || !alive player || lifeState player == "INCAPACITATED"};

{[_x getVariable "BIS_WL_sector", "reset_shape"] call BIS_fnc_WLSectorIconUpdate; _x setVariable ["BIS_WL_available", FALSE]} forEach _iconGrpPool;
BIS_WL_currentSelection = "";

if (!visibleMap || !alive player || lifeState player == "INCAPACITATED" || typeName (player getVariable "BIS_WL_scanPos") == typeName grpNull) exitWith {
	[toUpper localize "STR_A3_WL_scan_canceled"] spawn BIS_fnc_WLSmoothText;
	playSound "AddItemFailed";
	"Canceled" call BIS_fnc_WLSoundMsg;
};

_sector = player getVariable "BIS_WL_scanPos";
_varActiveSinceID = format ["BIS_WL_sectorScanActiveSince_%1", side group player];
_varLastRequestID = format ["BIS_WL_sectorScanLastRequest_%1", side group player];

if ((_sector getVariable _varActiveSinceID) > 0) exitWith {playSound "AddItemFailed"; [toUpper localize "STR_A3_WL_scan_restr1"] spawn BIS_fnc_WLSmoothText};
if ((_sector getVariable _varLastRequestID) > ((call BIS_fnc_WLSyncedTime) - BIS_WL_scanDuration - BIS_WL_scanCooldown - 5)) exitWith {playSound "AddItemFailed"; [toUpper localize "STR_A3_WL_menu_resetvoting_restr1"] spawn BIS_fnc_WLSmoothText};

_sector setVariable [_varActiveSinceID, (call BIS_fnc_WLSyncedTime), TRUE];
_sector setVariable [_varLastRequestID, (call BIS_fnc_WLSyncedTime), TRUE];
playSound "AddItemOK";

player setVariable ["BIS_WL_funds", (player getVariable "BIS_WL_funds") - BIS_WL_scanCost, TRUE];