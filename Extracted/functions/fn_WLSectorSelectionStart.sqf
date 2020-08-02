/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Initializes sector voting.
*/

_currentSectorVarID = format ["BIS_WL_currentSector_%1", side group player];
_selectionTimeVarID = format ["BIS_WL_selectionTime_%1", side group player];
_leadingSectorVarID = format ["BIS_WL_leadingSector_%1", side group player];

if (count _this > 0) exitWith {
	BIS_WL_CDShown = TRUE;
	while {isNull (missionNamespace getVariable _currentSectorVarID) && !BIS_WL_resetVoting} do {
		missionNamespace setVariable [_leadingSectorVarID, (side group player) call BIS_fnc_WLmostVotedSector];
		_tmout = ceil ((missionNamespace getVariable _selectionTimeVarID) - (call BIS_fnc_WLSyncedTime));
		if (_tmout > 0) then {"progress" call BIS_fnc_WLVotingBarHandle};
		_t = time + 0.25;
		waitUntil {time > _t || BIS_WL_resetVoting || !isNull (missionNamespace getVariable _currentSectorVarID)};
	};
	"hide" call BIS_fnc_WLVotingBarHandle;
	BIS_WL_CDShown = FALSE;
};

"close" call BIS_fnc_WLPurchaseMenu;

BIS_WL_currentSelection = "voting";
sleep 1;

"close" call BIS_fnc_WLPurchaseMenu;
call BIS_fnc_WLrecalculateServices;

["Sector selection started for %1", name player] call BIS_fnc_WLdebug;

_sectorsListed = BIS_WL_sectorsArrayFriendly;
_linked = _sectorsListed # 2;
_available = (_sectorsListed # 1) select {(_x getVariable "BIS_WL_sectorSide") != side group player};
_iconGrpPool = [];

{
	_pointerGrp = group (_x getVariable "BIS_WL_pointer");
	_pointerGrp setVariable ["BIS_WL_available", TRUE];
	_iconGrpPool pushBack _pointerGrp;
} forEach _available;

_iconGrpPool spawn BIS_fnc_WLOutlineIcons;

{
	removeMissionEventHandler ["GroupIconClick", missionNamespace getVariable [_x, -1]];
} forEach ["BIS_WL_dropPosSelectionHandler", "BIS_WL_fastTravelPosSelectionHandler", "BIS_WL_ScanPosSelectionHandler", "BIS_WL_sectorSelectionHandler"];
BIS_WL_sectorSelectionHandler = addMissionEventHandler ["GroupIconClick", {
	if ((_this # 1) getVariable "BIS_WL_available") then {
		playSound "AddItemOK";
		player setVariable ["BIS_WL_selectedSector", (_this # 1) getVariable "BIS_WL_sector", TRUE];
		BIS_WL_currentSelection = "voted";
	};
}];

player setVariable ["BIS_WL_toDraw", [BIS_WL_sectors, _linked] call BIS_fnc_WLcalculateSectorConnections];

BIS_WL_drawEH = (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw","
	{
		_start = _x # 0;
		_end = _x # 1;
		_color = _x # 2;
		(_this # 0) drawLine [_start, _end, if ([_start, _end] findIf {_x == (player getVariable 'BIS_WL_selectedSector')} == -1) then {_color} else {[0.8,0.5,0,1]}];
	} forEach (player getVariable 'BIS_WL_toDraw');
"];

_currentSectorVarID spawn {
	waitUntil {visibleMap || !isNull (missionNamespace getVariable _this)};
	if (isNull (missionNamespace getVariable _this)) then {
		[toUpper localize "STR_A3_WL_info_voting_click"] spawn BIS_fnc_WLSmoothText;
		"Sector" call BIS_fnc_WLSoundMsg;
	};
};

waitUntil {(missionNamespace getVariable _selectionTimeVarID) != -1 || !(BIS_WL_currentSelection in ["voting", "voted"])};

while {isNull (missionNamespace getVariable _currentSectorVarID) && !BIS_WL_resetVoting && (BIS_WL_currentSelection in ["voting", "voted"])} do {
	missionNamespace setVariable [_leadingSectorVarID, (side group player) call BIS_fnc_WLmostVotedSector];
	_tmout = ceil ((missionNamespace getVariable _selectionTimeVarID) - (call BIS_fnc_WLSyncedTime));
	if !(BIS_WL_CDShown) then {
		BIS_WL_CDShown = TRUE;
	};
	_t = time + 0.25;

	waitUntil {time > _t || BIS_WL_resetVoting || !isNull (missionNamespace getVariable _currentSectorVarID) || !(BIS_WL_currentSelection in ["voting", "voted"])};
};

BIS_WL_CDShown = FALSE;

(missionNamespace getVariable _currentSectorVarID) call BIS_fnc_WLsectorSelectionEnd;

{
	[_x, "reset_shape"] call BIS_fnc_WLSectorIconUpdate;
	_pointerGrp = group (_x getVariable "BIS_WL_pointer");
	_pointerGrp setVariable ["BIS_WL_available", FALSE];
} forEach _available;