with uiNamespace do {
	_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlRoleList} else {BIS_RscRespawnControlsMap_ctrlRoleList};
	_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlComboLoadout} else {BIS_RscRespawnControlsMap_ctrlComboLoadout};
	_ctrlPrimaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPicturePrimaryWeapon} else {BIS_RscRespawnControlsMap_ctrlPicturePrimaryWeapon};
	_ctrlSecondaryWeapon = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureSecondaryWeapon} else {BIS_RscRespawnControlsMap_ctrlPictureSecondaryWeapon};
	_ctrlOptics = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureOptics} else {BIS_RscRespawnControlsMap_ctrlPictureOptics};
	_ctrlItem = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {BIS_RscRespawnControlsSpectate_ctrlPictureItem} else {BIS_RscRespawnControlsMap_ctrlPictureItem};
	
	_curSelList = lbCurSel _list;
	_curSelCombo = lbCurSel _combo;
	
	//--- Set all pictures and tooltips empty
	_ctrlPrimaryWeapon ctrlSetText "";
	_ctrlPrimaryWeapon ctrlSetTooltip "";
	_ctrlSecondaryWeapon ctrlSetText "";
	_ctrlSecondaryWeapon ctrlSetTooltip "";
	_ctrlOptics ctrlSetText "";
	_ctrlOptics ctrlSetTooltip "";
	_ctrlItem ctrlSetText "";
	_ctrlItem ctrlSetTooltip "";
	
	//--- Main processing
	if !(_curSelCombo < 0) then {	//there is something selected
		_metadata = ["get",_curSelList] call (missionNamespace getVariable "BIS_fnc_showRespawnMenuInventoryMetadata");
		if ((count _metadata) == 0) exitWith {debuglog "BIS_fnc_showRespawnMenuInventoryItems: Warning! Metadata function returned an empty array for currently selected loadout!"};
		_loadouts = _metadata select 1;
		_comboText = _combo lbText _curSelCombo;
		
		//--- Find correct item in metadata
		_loadoutArray = [];
		{
			if ((_x select 1) isEqualTo _comboText) exitWith {_loadoutArray = _x};
		} forEach _loadouts;
		
		//--- Metadata for item found, process it
		if ((count _loadoutArray) > 0) then {
			//Basic variables
			_loadoutCfg = _loadoutArray select 2;
			_weaponCfg = configFile >> "CfgWeapons";
			_primaryWeaponCfg = configFile >> "";		//empty config as placeholder
			_secondaryWeaponCfg = configFile >> "";		//empty config as placeholder
			_opticsCfg = configFile >> "";				//empty config as placeholder
			_itemCfg = configFile >> "";				//empty config as placeholder
			
			//Backpack items function
			_fnc_backpackItems = {
				_backpackItems = [];
				_transportCfg = configFile >> "CfgVehicles" >> _this >> "TransportItems";
				for "_i" from 0 to ((count _transportCfg) - 1) do {
					_backpackItemName = getText ((_transportCfg select _i) >> "Name");
					if (_backpackItemName != "") then {_backpackItems = _backpackItems + [_backpackItemName]};
				}; 
				_backpackItems
			};
			
			//Weapon/item processing
			_weaponArray = [];
			_itemArray = [];
			_backpack = "";
			_inventory = [];
			
			if ((typeName _loadoutCfg) == (typeName configfile)) then {	//---classic config lodaout
				_weaponArray = getArray (_loadoutCfg >> "Weapons");
				_itemArray = (getArray (_loadoutCfg >> "Items")) + (getArray (_loadoutCfg >> "respawnLinkedItems"));
				_backpack = getText (_loadoutCfg >> "Backpack");
			} else {	//---arsenal loadout
				_namespace = _loadoutCfg param [0,missionnamespace,[missionnamespace,grpnull,objnull]];
				_name = _loadoutCfg param [1,"",[""]];
				_data = _namespace getvariable ["bis_fnc_saveInventory_data",[]];
				_nameID = _data find _name;
				if (_nameID >= 0) then {
					_inventory = _data select (_nameID + 1);
				};
				if ((count _inventory) > 0) then {
					_weaponArray = [((_inventory select 6) select 0)] + [((_inventory select 7) select 0)] + [((_inventory select 8) select 0)];
					_itemArray = ((_inventory select 0) select 1) + [(_inventory select 5)] + (_inventory select 9);
					_backpack = ((_inventory select 2) select 0);
				};
			};
			
			if (_backpack != "") then {
				_itemArray = _itemArray + (_backpack call _fnc_backpackItems);
			};
			_itemInfo = [configFile >> "",-1];
			_priorityItems = [619,620,621];		//619 medikit, 620 toolkit, 621 uavTerminal
				// !! priority items with lower number are considered to be more important !!
			
			{	//--weapons
				switch (getNumber (_weaponCfg >> _x >> "Type")) do {
					case 1: {_primaryWeaponCfg = _weaponCfg >> _x};
					case 4: {_secondaryWeaponCfg = _weaponCfg >> _x};
				};
			} forEach _weaponArray;
			
			if ((typeName _loadoutCfg) == (typeName configfile)) then {	//---classic config lodaout
				if (isClass _primaryWeaponCfg) then {	//--optic
					_opticsClass = getText (_primaryWeaponCfg >> "LinkedItems" >> "LinkedItemsOptic" >> "Item");
					_opticsCfg = _weaponCfg >> _opticsClass;
				};
			} else {	//---arsenal loadout
				_opticsClass = (((_inventory select 6) select 1) select 2);
				_opticsCfg = _weaponCfg >> _opticsClass;
			};
			
			{	//--items
				if (getNumber (_weaponCfg >> _x >> "Type") isEqualTo 131072) then {
					_itemCfg = _weaponCfg >> _x;
					_itemInfoType = getNumber (_itemCfg >> "ItemInfo" >> "Type");
					if (_itemInfoType in _priorityItems) then {	//priority item!
						if (((_itemInfo select 1) < 0) || {((_itemInfo select 1) > _itemInfoType)}) then {		//no priority item in slot yet, or priority item with higher number (and therefore lower priority) in slot
							_itemInfo = [_itemCfg,_itemInfoType];
						};
					};
				};
			} forEach _itemArray;
			
			//Pictures and tooltips set
			_itemCfg = _itemInfo select 0;
			if (isClass _primaryWeaponCfg) then {
				_ctrlPrimaryWeapon ctrlSetText (getText (_primaryWeaponCfg >> "Picture"));
				_ctrlPrimaryWeapon ctrlSetTooltip (getText (_primaryWeaponCfg >> "DisplayName"));
			};
			if (isClass _secondaryWeaponCfg) then {
				_ctrlSecondaryWeapon ctrlSetText (getText (_secondaryWeaponCfg >> "Picture"));
				_ctrlSecondaryWeapon ctrlSetTooltip (getText (_secondaryWeaponCfg >> "DisplayName"));
			};
			if (isClass _opticsCfg) then {
				_ctrlOptics ctrlSetText (getText (_opticsCfg >> "Picture"));
				_ctrlOptics ctrlSetTooltip (getText (_opticsCfg >> "DisplayName"));
			};
			if (isClass _itemCfg) then {
				_ctrlItem ctrlSetText (getText (_itemCfg >> "Picture"));
				_ctrlItem ctrlSetTooltip (getText (_itemCfg >> "DisplayName"));
			};
			
		} else {		//missing metadata for item!
			["No metadata found for loadout %1 when processing item images.",_comboText] call (missionNamespace getVariable "BIS_fnc_error");
		};
	};
};