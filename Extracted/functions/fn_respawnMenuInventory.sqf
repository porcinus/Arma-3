_unit = _this param [0,objnull,[objnull]];
_respawnDelay = _this param [3,0,[0]];
_revive = _this param [4, false, [false]];

// Originally meant to let handling of the respawn on revive scripts, currently for back compatibility reasons
if (_unit getVariable ["BIS_fnc_showRespawnMenu_disable",false]) exitWith {};

disableserialization;

if !(alive player) then {		//player dead, show respawn menu
	[1] call BIS_fnc_showRespawnMenuInventoryLimitRespawn;	//add 1 to limit if limited loadout was used
	["open"] call BIS_fnc_showRespawnMenu;
} else {					//player alive, hide respawn menu
	//--- Player - assign selected inventory
	_respawnInventories = (player call bis_fnc_getRespawnInventories);
	_list = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlRoleList";
	_combo = uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlComboLoadout";
	if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {
		_list = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlRoleList";
		_combo = uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlComboLoadout";
	};
	
	_selected = "";
	if !(isNil {uiNamespace getVariable "BIS_RscRespawnControls_invMetadata"} || {isNull _list}) then {
		_metadata = ["get",lbCurSel _list] call BIS_fnc_showRespawnMenuInventoryMetadata;	//get metadata for given role
		_loadoutArray = if ((count _metadata) != 0) then {_metadata select 1} else {[]};	//safecheck preventing occasional script error with empty array in _metadata
		_curSelComboName = _combo lbText (lbCurSel _combo);
		{		//find currently selected loadout and store it in _selected variable
			if (_curSelComboName isEqualTo (_x select 1)) exitWith {_selected = _x select 0};
		} forEach _loadoutArray;
	};

	//--- Selected loadout is empty or no longer available - pick a random one
	if (_selected == "" || !(_selected in _respawnInventories)) then {
		_selected = if (count _respawnInventories > 0) then {
			_respawnInventories call bis_fnc_selectrandom
		} else {
			["No respawn inventories found"] call bis_fnc_error;
			""
		};
	};

	_cfg = missionconfigfile >> "cfgrespawninventory" >> _selected;
	if !(isclass _cfg) then {_cfg = configfile >> "cfgvehicles" >> _selected;};
	if !(isclass _cfg) then {
		//--- Arsenal loadout
		_xSplit = [_selected,":"] call bis_fnc_splitstring;
		if (count _xSplit == 2) then {
			_namespace = _xSplit select 0;
			_name = _xSplit select 1;
			_cfg = switch (tolower _namespace) do {
				case "missionnamespace": {[missionnamespace,_name]};
				case "profilenamespace": {[profilenamespace,_name]};
				case "player": {[player,_name]};
				default {[]};
			};
			[player,_cfg] call bis_fnc_loadInventory;
		};
	} else {
		//--- Config loadout
		_vehicle = gettext (_cfg >> "vehicle");
		[player,_cfg] call bis_fnc_loadInventory;
		if (_vehicle != "") then {[player,_vehicle,getarray (_cfg >> "vehicleIgnore")] call bis_fnc_loadInventory;};
	};
	if (vehicle player == player) then {player switchmove "";};
	
	//Limit handling
	[-1] call BIS_fnc_showRespawnMenuInventoryLimitRespawn;		//add -1 to limit if limited loadout was used

	//Some variables set to nil to prevent errors after current mission ends (and next mission begins)
	uiNamespace setVariable ["BIS_RscRespawnControls_invMetadata",nil];
	
	//When position template not used, the variable in player namespace should be defined for the first respawn so he doesn't end up in the sea, but on his original position set in the editor instead
	if !(isNil {player getVariable "BIS_fnc_selectRespawnTemplate_initPos"}) then {player setPos (player getVariable "BIS_fnc_selectRespawnTemplate_initPos");player setVariable ["BIS_fnc_selectRespawnTemplate_initPos",nil]};
	
	["close"] spawn BIS_fnc_showRespawnMenuInventoryDetails;	//closes details control if force respawned with it opened, do nothing otherwise
	["close"] call BIS_fnc_showRespawnMenu;
	setplayerrespawntime _respawnDelay;
};