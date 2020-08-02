private _dif 	= _this param [0, 0, [0]];
private _entity	= _this param [1, player, [objNull]];

with uiNamespace do {
	if (_dif < 0) then {
		//--- Unit respawned, inventory applied
		_list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlRoleList"} else {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlRoleList"};
		_combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlComboLoadout"} else {uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlComboLoadout"};

		_curSelListRight = _list lbTextRight (lbCurSel _list);
		_curSelComboRight = _combo lbTextRight (lbCurSel _combo);

		if ((_curSelListRight != "") || {_curSelComboRight != ""}) then {	//limit applied to loadout or role
			_inventoryIdentityList = _entity call bis_fnc_getRespawnInventories;
			_inventoryDataList = [_entity,false,true] call bis_fnc_getRespawnInventories;

			_roleName = _list lbText (lbCurSel _list);
			_invIdentity = _combo lbData (lbCurSel _combo);
			_dataArray = _inventoryDataList select (_inventoryIdentityList find _invIdentity);
			_namespace = _dataArray select 0;
			_fncData = [_namespace,_roleName,_invIdentity];

			_entity setVariable ["BIS_RscRespawnControls_inventory", _fncData, true];
			["change",_fncData + [_dif]] call BIS_fnc_showRespawnMenuInventoryLimit;
		};
	} else {
		//--- Unit died, inventory available
		_fncData = _entity getVariable ["BIS_RscRespawnControls_inventory",[]];
		if ((count _fncData) == 3) then {	//loadout was saved, there is some limitation
			_entity setVariable ["BIS_RscRespawnControls_inventory", [], true];
			["change",_fncData + [_dif]] call BIS_fnc_showRespawnMenuInventoryLimit;
		};
	};
};