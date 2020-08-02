_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlRoleList"} else {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlRoleList"};
_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlComboLoadout"} else {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlComboLoadout"};

_disableRoleMessage = localize "STR_A3_RscRespawnControls_DisabledRoleMessage";
_disableInventoryMessage = localize "STR_A3_RscRespawnControls_DisabledInventoryMessage";
_inventoryIdentityList = player call bis_fnc_getRespawnInventories;
_inventoryDataList = [player,false,true] call bis_fnc_getRespawnInventories;
_namespaceList = [missionNamespace,side (group player),group player,player];
_limits = [-1,-1];

//--- List (role) limits
_sizeList = lbSize _list;
_disableArrayList = ["state",_list,"",_disableRoleMessage] call BIS_fnc_showRespawnMenuDisableItem;
for "_i" from 0 to (_sizeList - 1) do {
	_roleName = _list lbText _i;
	{
		_limits = ["get",[_x,_roleName,""]] call BIS_fnc_showRespawnMenuInventoryLimit;
		if ((_limits select 0) > -1) exitWith {};
	} forEach _namespaceList;	//check all namespaces, start from the most global one
	
	_roleLimit = _limits select 0;
	if (_roleLimit > -1) then {	//role (item) has defined limit, precess it
		_list lbSetTextRight [_i,str _roleLimit];	//write current limit state in the item
		if (_roleLimit > 0) then {	//there is at least one free slot in this role, it should be enabled
			if (_roleName in _disableArrayList) then {["enable",_combo,_i] call BIS_fnc_showRespawnMenuDisableItem};	//enable role
		} else {	//there is no free slot in this role, it should be disabled
			if !(_roleName in _disableArrayList) then {["disable",_list,_i,_disableRoleMessage] call BIS_fnc_showRespawnMenuDisableItem};	//disable role
		};
	};
};

//--- Combo (loadout/inventory) limits
_roleRightText = _list lbTextRight (lbCurSel _list);

if (_roleRightText == "") then {	//no limit applied to the currently selected role, check loadouts (they don't use limits if any limit is applied to the role)
	_roleName = _list lbText (lbCurSel _list);
	_sizeCombo = lbSize _combo;
	_disableArrayCombo = ["state",_combo,"",_disableInventoryMessage] call BIS_fnc_showRespawnMenuDisableItem;
	for "_i" from 0 to (_sizeCombo - 1) do {
		_invIdentity = _combo lbData _i;
		_itemDataId = _inventoryIdentityList find _invIdentity;
		if !(_itemDataId < 0) then {	//safecheck - identity wasn't found in the identity list
			_dataArray = _inventoryDataList select _itemDataId;
			_invLimit = _dataArray select 1;
			
			if (_invLimit > -1) then { //limit is applied
				_limits = ["get",[_dataArray select 0,_roleName,_invIdentity]] call BIS_fnc_showRespawnMenuInventoryLimit;
				_invLimit = _limits select 1;		
				if (_invLimit > -1) then {
					_combo lbSetTextRight [_i,str _invLimit];	//limit for inventory found, write it into the combobox
					_invName = _combo lbText _i;
					if (_invLimit > 0) then {
						if (_invName in _disableArrayCombo) then {["enable",_combo,_i] call BIS_fnc_showRespawnMenuDisableItem};
					} else {
						if !(_invName in _disableArrayCombo) then {["disable",_combo,_i,_disableInventoryMessage] call BIS_fnc_showRespawnMenuDisableItem};
					};
				};	
			};
		};
	};
};