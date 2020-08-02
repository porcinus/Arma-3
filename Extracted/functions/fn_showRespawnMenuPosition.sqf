private ["_list","_respawnPositions","_addPositions","_deletePositions","_respawnPositionsNew","_fnc_refreshLoop"];

_respawnTemplates = getMissionConfigValue "respawnTemplates";
_sideTemplates = getMissionConfigValue ("respawnTemplates" + str (side group player));	//check side specific templates as well
if ((!isNil "_sideTemplates") && {(count _sideTemplates) > 0}) then {_respawnTemplates = _sideTemplates};
if ((isNil "_respawnTemplates") || {(typeName []) != (typeName _respawnTemplates)}) then {_respawnTemplates = []}; 

disableSerialization;
if ("MenuPosition" in _respawnTemplates) then {	
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocList} else {BIS_RscRespawnControlsMap_ctrlLocList};
	lbClear _list;		//clean list from old data
	BIS_RscRespawnControls_posMetadata = [];
	
	//--- Initial data processing and list filling
	_respawnPositions = (player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers);
	if ((leader group player) == player) then {
		_respawnPositions = _respawnPositions - [player,group player];	//respawn point on player or player's group (in case player is leader and respawn would be on his dead body) removed
	} else {
		_respawnPositions = _respawnPositions - [player];	//respawn point on player removed
	};
	[true,_list,_respawnPositions] call BIS_fnc_showRespawnMenuPositionList;
	_lastSel = (BIS_RscRespawnControls_selected select 0);
	_list lbSetCurSel (if (_lastSel >= 0) then {_lastSel} else {0});	//set correct selection if switching between spectate/map happened, first item in case nothing was selected so far
	
	[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;	//check if anything is disabled and change color of item in that case
	
	//--- Refresh loop function
	_fnc_refreshLoop = {
		//Added/removed positions handling
		_respawnPositionsNew = (player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers);
		if !(_respawnPositions isEqualTo _respawnPositionsNew) then {	//process this only if any position was added/removed
			_addPositions = _respawnPositionsNew - _respawnPositions;
			_deletePositions = _respawnPositions - _respawnPositionsNew;
			
			if ((count _addPositions) > 0) then {[true,_list,_addPositions] call BIS_fnc_showRespawnMenuPositionList};
			if ((count _deletePositions) > 0) then {[false,_list,_deletePositions] call BIS_fnc_showRespawnMenuPositionList};
			_respawnPositions = _respawnPositionsNew;
		};
		
		//Refresh of existing items
		[_list] call BIS_fnc_showRespawnMenuPositionRefresh;
	};
	
	//--- Refresh loop
	if (missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]) then {		//loop when in map
		while {missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 1;
		};
	} else {										//loop when in spectator
		while {missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 1;
		};
	};
} else {
	//Template not used, disable position selection part
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocList} else {BIS_RscRespawnControlsMap_ctrlLocList};
	_locDisabled = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLocDisabled} else {BIS_RscRespawnControlsMap_ctrlLocDisabled};
	
	lbClear _list;		//clean list from old data
	
	_locDisabled ctrlEnable true;
	_locDisabled ctrlSetFade 0;
	_locDisabled ctrlCommit 0;
};