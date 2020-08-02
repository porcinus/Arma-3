_respawnTemplates = getMissionConfigValue "respawnTemplates";
_sideTemplates = getMissionConfigValue ("respawnTemplates" + str (side group player));	//check side specific templates as well
if ((!isNil "_sideTemplates") && {(count _sideTemplates) > 0}) then {_respawnTemplates = _sideTemplates};
if ((isNil "_respawnTemplates") || {(typeName []) != (typeName _respawnTemplates)}) then {_respawnTemplates = []}; 

if ("MenuInventory" in _respawnTemplates) then {
	disableSerialization;
	
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleList} else {BIS_RscRespawnControlsMap_ctrlRoleList};
	_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlComboLoadout} else {BIS_RscRespawnControlsMap_ctrlComboLoadout};
	lbClear _list;		//clean list from old data
	BIS_RscRespawnControls_invMetadata = [];
	
	//--- Initial data processing and list filling
	_respawnInventories = player call bis_fnc_getRespawnInventories;
	if ((count _respawnInventories) == 0) then {	//if there is no inventory defined but the template was called, add player's current inventory as loadout
		[missionNamespace,typeOf player] call BIS_fnc_addRespawnInventory;
		_respawnInventories = player call bis_fnc_getRespawnInventories;
	};
	
	_list lbSetCurSel -1;	//removing selection, it would refresh combobox for given selection with every loadout added otherwise
	[true,_list,_respawnInventories] call BIS_fnc_showRespawnMenuInventoryList;
	_lastSelList = (uiNamespace getVariable "BIS_RscRespawnControls_selected") select 1;
	_list lbSetCurSel (if (_lastSelList >= 0) then {_lastSelList} else {0});	//set correct selection if switching between spectate/map happened, first item in case nothing was selected so far
	
	call BIS_fnc_showRespawnMenuInventoryLoadout;		//fill the loadout combobox
	_lastSelCombo = (uiNamespace getVariable "BIS_RscRespawnControls_selected") select 2;
	_combo lbSetCurSel (if (_lastSelCombo >= 0) then {_lastSelCombo} else {0});	//set correct selection if switching between spectate/map happened, first item in case nothing was selected so far
	
	[_list] call BIS_fnc_showRespawnMenuDisableItemDraw;	//check if anything is disabled and change color of item in that case
	[_combo] call BIS_fnc_showRespawnMenuDisableItemDraw;	//check if anything is disabled and change color of item in that case
	
	//--- Refresh loop function
	_fnc_refreshLoop = {
		//Added/removed positions handling
		_respawnInventoriesNew = player call bis_fnc_getRespawnInventories;
		if !(_respawnInventories isEqualTo _respawnInventoriesNew) then {	//process this only if any position was added/removed
			_addInventories = _respawnInventoriesNew - _respawnInventories;
			_deleteInventories = _respawnInventories - _respawnInventoriesNew;
			
			if ((count _addInventories) > 0) then {[true,_list,_addInventories] call BIS_fnc_showRespawnMenuInventoryList};
			if ((count _deleteInventories) > 0) then {[false,_list,_deleteInventories] call BIS_fnc_showRespawnMenuInventoryList};
			_respawnInventories = _respawnInventoriesNew;
		};
		call BIS_fnc_showRespawnMenuInventoryLimitRefresh;
	};
	
	//--- Refresh loop
	if (missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]) then {		//loop when in map
		while {missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 0.5;
		};
	} else {										//loop when in spectator
		while {missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]} do {
			call _fnc_refreshLoop;
			sleep 0.5;
		};
	};
} else {
	//inventory template is not used
	disableSerialization;
	
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleList} else {BIS_RscRespawnControlsMap_ctrlRoleList};
	_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlComboLoadout} else {BIS_RscRespawnControlsMap_ctrlComboLoadout};
	
	_buttonDetails = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlButtonDetails} else {BIS_RscRespawnControlsMap_ctrlButtonDetails};
	_picturePrimaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPicturePrimaryWeapon} else {BIS_RscRespawnControlsMap_ctrlPicturePrimaryWeapon};
	_pictureSecondaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureSecondaryWeapon} else {BIS_RscRespawnControlsMap_ctrlPictureSecondaryWeapon};
	_pictureOptics = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureOptics} else {BIS_RscRespawnControlsMap_ctrlPictureOptics};
	_pictureItem = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureItem} else {BIS_RscRespawnControlsMap_ctrlPictureItem};
	_bgPrimaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlBackgroundPrimaryWeapon} else {BIS_RscRespawnControlsMap_ctrlBackgroundPrimaryWeapon};
	_bgSecondaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlBackgroundSecondaryWeapon} else {BIS_RscRespawnControlsMap_ctrlBackgroundSecondaryWeapon};
	_bgOptics = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlBackgroundOptics} else {BIS_RscRespawnControlsMap_ctrlBackgroundOptics};
	_bgItem = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlBackgroundItem} else {BIS_RscRespawnControlsMap_ctrlBackgroundItem};
	_hideArray = [_list,_combo,_buttonDetails,_picturePrimaryWeapon,_pictureSecondaryWeapon,_pictureOptics,_pictureItem,_bgPrimaryWeapon,_bgSecondaryWeapon,_bgOptics,_bgItem];
	
	_roleDisabled = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleDisabled} else {BIS_RscRespawnControlsMap_ctrlRoleDisabled};
	_loadoutDisabled = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlLoadoutDisabled} else {BIS_RscRespawnControlsMap_ctrlLoadoutDisabled};
	
	lbClear _list;		//clean list from old data
	lbClear _combo;		//clean combo from old data
	_roleDisabled ctrlEnable true;
	_loadoutDisabled ctrlEnable true;
	_roleDisabled ctrlSetFade 0;
	_loadoutDisabled ctrlSetFade 0;
	_roleDisabled ctrlCommit 0;
	_loadoutDisabled ctrlCommit 0;
	
	{_x ctrlSetFade 1;_x ctrlCommit 0} forEach _hideArray;
	
	[missionNamespace,typeOf player] call BIS_fnc_addRespawnInventory;
	_respawnInventories = player call bis_fnc_getRespawnInventories;
	[true,_list,_respawnInventories] call BIS_fnc_showRespawnMenuInventoryList;
	_list lbSetCurSel 0;
	call BIS_fnc_showRespawnMenuInventoryLoadout;
	_combo lbSetCurSel 0;
	
	//<--- old code, will be partially used for situations when designer uses the inventory template but doesn't set any loadout
	/*_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleList} else {BIS_RscRespawnControlsMap_ctrlRoleList};
	_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlComboLoadout} else {BIS_RscRespawnControlsMap_ctrlComboLoadout};
	lbClear _list;		//clean list from old data
	BIS_RscRespawnControls_invMetadata = [];
	
	[true,_list,[(typeOf player)]] call BIS_fnc_showRespawnMenuInventoryList;
	_list lbSetCurSel 0;
	call BIS_fnc_showRespawnMenuInventoryLoadout;		//fill the loadout combobox
	_combo lbSetCurSel 0;*/
};