/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sector voting termination subroutine.
*/

["Sector selection ended for %1", name player] call BIS_fnc_WLdebug;

if (BIS_WL_currentSelection in ["voting", "voted"]) then {
	BIS_WL_currentSelection = "";
	removeMissionEventHandler ["GroupIconClick", BIS_WL_sectorSelectionHandler];
};

(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", BIS_WL_drawEH];

if (isNull _this && BIS_WL_currentSelection == "" && BIS_WL_resetVoting) then {
	player setVariable ["BIS_WL_selectedSector", objNull, TRUE];
	[toUpper localize "STR_A3_WL_voting_reset"] spawn BIS_fnc_WLSmoothText;
	"Reset" call BIS_fnc_WLSoundMsg;
} else {
	[] spawn {
		_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
		waitUntil {!isNull (missionNamespace getVariable _currentSectorVarID)};
		player setVariable ["BIS_WL_selectedSector", objNull, TRUE];
	};
};

_null = [] spawn {
	waitUntil {!BIS_WL_CDShown};
	missionNamespace setVariable [format ["BIS_WL_leadingSector_%1", side group player], objNull];
	missionNamespace setVariable [format ["BIS_WL_selectionTime_%1", side group player], -1];
};