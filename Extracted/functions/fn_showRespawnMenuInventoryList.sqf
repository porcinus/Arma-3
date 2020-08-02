params
[
	["_mode", false, [false]],
	["_list", controlNull, [controlNull]],
	["_itemArray", [], [[]]]
];

// Function definitions start
private _fnc_loadoutCfg =
{
	_cfg = missionconfigfile >> "cfgrespawninventory" >> (_this select 0);
	if !(isclass _cfg) then {_cfg = configfile >> "cfgvehicles" >> (_this select 0);};
	if !(isclass _cfg) then
	{
		// Arsenal loadout
		_xSplit = [(_this select 0),":"] call bis_fnc_splitstring;

		if (count _xSplit == 2) then
		{
			_namespace = _xSplit select 0;
			_name = _xSplit select 1;
			_cfg = switch (tolower _namespace) do
			{
				case "missionnamespace": 	{[missionnamespace,_name]};
				case "profilenamespace": 	{[profilenamespace,_name]};
				case "player": 				{[player,_name]};
				default 					{[]};
			};
		};
	}
	else
	{
		// Config loadout
		_vehicle = gettext (_cfg >> "vehicle");
		if (_vehicle != "") then {_cfg = configFile >> "CfgVehicles" >> _vehicle;};
	};

	_cfg
};

private _fnc_roleCfg =
{
	_role = getText ((_this select 0) >> "Role");
	_cfg = configFile;

	// Role parameter found, check the configs
	if (_role != "") then
	{
		_cfg = configFile >> "CfgRoles" >> _role;
		if !(isClass _cfg) then {_cfg = missionConfigFile >> "CfgRoles" >> _role;};
		if !(isClass _cfg) then
		{
			// Error message - role config not found, set to default
			["Correct role config for item '%1' was not found, class default used instead!",_x] call BIS_fnc_error;
			_cfg = configFile >> "CfgRoles" >> "Default";
		};
	}
	// Undefined role parameter
	else
	{
		_cfg = configFile >> "CfgRoles" >> "Default";
	};

	_cfg
};

private _inventoryIdentityList 	= player call bis_fnc_getRespawnInventories;
private _inventoryDataList 		= [player,false,true] call bis_fnc_getRespawnInventories;

if (_mode) then
{
	// Add items
	{
		_identity = _x;
		_loadoutCfg = [_x] call _fnc_loadoutCfg;

		// Correct config loaded
		if (((typeName _loadoutCfg) == (typeName configfile)) && {isClass _loadoutCfg}) then
		{
			// Loadout params
			_loadoutName = getText (_loadoutCfg >> "displayName");
			if (_loadoutName == "") then {_identity};

			// Role params
			_roleCfg = [_loadoutCfg] call _fnc_roleCfg;
			_roleName = getText (_roleCfg >> "displayName");
			_rolePic = getText (_roleCfg >> "icon");

			// Metadata (and list - done in metadata fnc) handling
			_metadata = [[_roleName,_roleCfg,_rolePic],[_identity,_loadoutName,_loadoutCfg]];
			["set",_metadata] call BIS_fnc_showRespawnMenuInventoryMetadata;

			// Limits
			_pos = _inventoryIdentityList find _identity;
			_limitArray = _inventoryDataList select _pos;

			// At least on of the limits is not set to -1 and therefore limit should be applied
			if (((count _limitArray) == 3) && {((_limitArray select 1) + (_limitArray select 2)) > -2}) then
			{
				_namespace = _limitArray select 0;
				_inventoryLimit = _limitArray select 1;
				_roleLimit = _limitArray select 2;
				["set",[_namespace,_roleName,_identity,_roleLimit,_inventoryLimit]] call BIS_fnc_showRespawnMenuInventoryLimit;
			};
		}
		else
		{
			if (((typeName _loadoutCfg) == (typeName [])) && {(count _loadoutCfg) != 0}) then
			{
				_loadoutName = _loadoutCfg select 1;

				// Role params
				_roleCfg = configFile >> "CfgRoles" >> "Default";
				_roleName = getText (_roleCfg >> "displayName");
				_rolePic = getText (_roleCfg >> "icon");

				// Metadata (and list - done in metadata fnc) handling
				_metadata = [[_roleName,_roleCfg,_rolePic],[_identity,_loadoutName,_loadoutCfg]];
				["set",_metadata] call BIS_fnc_showRespawnMenuInventoryMetadata;

				// Limits
				_pos = _inventoryIdentityList find _identity;
				_limitArray = _inventoryDataList select _pos;

				// At least on of the limits is not set to -1 and therefore limit should be applied
				if (((count _limitArray) == 3) && {((_limitArray select 1) + (_limitArray select 2)) > -2}) then
				{
					_namespace = _limitArray select 0;
					_inventoryLimit = _limitArray select 1;
					_roleLimit = _limitArray select 2;
					["set",[_namespace,_roleName,_identity,_roleLimit,_inventoryLimit]] call BIS_fnc_showRespawnMenuInventoryLimit;
				};
			}
			else
			{
				// Error message - correct config wasn't found
				["Correct config for item '%1' was not found!",_x] call BIS_fnc_error;
			};
		};
	}
	forEach _itemArray;
}
else
{
	// Remove items
	{
		_remove = _x;
		_loadoutCfg = [_x] call _fnc_loadoutCfg;

		// Correct config loaded
		if (isClass _loadoutCfg) then
		{
			_roleCfg = [_loadoutCfg] call _fnc_roleCfg;
			_roleName = getText (_roleCfg >> "displayName");
			_size = lbSize _list;

			for "_i" from 0 to (_size - 1) do
			{
				_metadata = ["get", _i] call BIS_fnc_showRespawnMenuInventoryMetadata;

				// There is at least something in metadata and the role name is the same as role of item for removal
				if ((count _metadata > 0) && {((_metadata select 0) select 0) isEqualTo _roleName}) then
				{
					{
						_identity = _x select 0;

						// We found the right item to remove
						if (_identity isEqualTo _remove) exitWith
						{
							private _selectedIndex = lbCurSel _list;

							["delete", _i] call BIS_fnc_showRespawnMenuInventoryMetadata;
							[] call BIS_fnc_showRespawnMenuInventory;

							if (lbSize _list > _selectedIndex) then
							{
								_list lbSetCurSel _selectedIndex;
							};
						};
					}
					forEach (_metadata select 1);
				};
			};
		}
		else
		{
			// Error message - correct config wasn't found
			["Correct config for item '%1' was not found!",_x] call BIS_fnc_error;
		};
	}
	forEach _itemArray;
};