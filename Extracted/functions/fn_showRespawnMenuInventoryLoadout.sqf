with uiNamespace do
{
	private _list = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_ctrlRoleList", controlNull]} else {uiNamespace getVariable ["BIS_RscRespawnControlsMap_ctrlRoleList", controlNull]};
	private _combo = if (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]) then {uiNamespace getVariable ["BIS_RscRespawnControlsSpectate_ctrlComboLoadout", controlNull]} else {uiNamespace getVariable ["BIS_RscRespawnControlsMap_ctrlComboLoadout", controlNull]};
	private _curSelList = lbCurSel _list;
	lbClear _combo;

	if !(_curSelList < 0) then
	{
		private _metadata = ["get",_curSelList] call BIS_fnc_showRespawnMenuInventoryMetadata;
		private _loadouts = _metadata param [1, [], [[]]];

		{
			private _identity = _x select 0;
			private _name = _x select 1;
			private _id = _combo lbAdd _name;

			_combo lbSetData [_id,_identity];
		}
		forEach _loadouts;

		lbSort _combo;

		private _curSelCombo = lbCurSel _combo;
		if ((_curSelCombo < 0) || {_curSelCombo > ((lbSize _combo) - 1)}) then {_combo lbSetCurSel 0};

		// Refresh of loadout preview
		call BIS_fnc_showRespawnMenuInventoryItems;
	};
};