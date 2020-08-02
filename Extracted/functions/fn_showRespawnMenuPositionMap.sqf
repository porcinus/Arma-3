with uiNamespace do {
	disableSerialization;
	_map = _this;
	_posArray = [];
	_lbSize = lbSize BIS_RscRespawnControlsMap_ctrlLocList;
	_curSel = lbCurSel BIS_RscRespawnControlsMap_ctrlLocList;
	_focus = false;
	if ((BIS_RscRespawnControls_selected select 0) != _curSel) then {	//selection in list changed, set focus on new point
		if ((BIS_RscRespawnControls_selected select 0) >= 0) then {_focus = true};	//don't change focus if this is initial selection (not done by player)
		BIS_RscRespawnControls_selected set [0,_curSel];
	};
	
	//--- Icons processing
	for "_i" from 0 to (_lbSize - 1) do {		//process all items in the list
		_metadata = ["get",_i] call BIS_fnc_showRespawnMenuPositionMetadata;
		if (count _metadata > 0) then {		//if there are any metadata available
			//basic info - metadata
			_basicInfo = _metadata select 0;
			_identity = _basicInfo select 0;
			_name = _basicInfo select 1;
			_pic = _basicInfo select 2;
			_showName = _basicInfo select 3;
			_enemyState = (_metadata select 1) select 0;
			_aliveState = if ((_metadata select 2) select 0) then {(_metadata select 2) select 1} else {true};		//aliveStatus if it is enabled, true otherwise (if disabled, then icon should be active, so true)
			_selected = if (_curSel == _i) then {true} else {false};
			_cursor = if (!(isNil "BIS_RscRespawnControls_cursor") && {BIS_RscRespawnControls_cursor isEqualTo _identity}) then {true} else {false};
			
			//get current position
			_pos = [0,0,0];
			switch (typeName _identity) do {
				case (typeName ""): {_pos = getMarkerPos _identity};
				case (typeName grpNull): {_pos = getPos (leader _identity)};
				case (typeName objNull): {_pos = getPos _identity};
				case (typeName []): {_pos = _identity};
			};
			
			//init, store position for map (pos and zoom) computing
			if (missionNamespace getVariable ["BIS_RscRespawnControls_mapInit", false]) then {
				_posArray = _posArray + [_pos];
			};
			
			_mapInfo = [];
			_iconInfo = [_pos,_name,_pic,_showName,_enemyState,_aliveState,_selected];
			[_mapInfo,_iconInfo,_focus,_cursor] call BIS_fnc_showRespawnMenuPositionMapDraw;
			
		} else {
			debugLog "BIS_fnc_showRespawnMenuPositionMap: Warning! An item with no metadata in the position list UI control!";
		};
	};

	//--- Map position and zoom
	if (count _posArray > 0) then {	//respawn positions stored, compute and set map position and zoom
		//TODO: compute and set position and zoom!
		
		//Temporary solution start - zoom on first item in the list
		_map ctrlMapAnimAdd [0,ctrlMapScale _map,(_posArray select 0)];
		ctrlMapAnimCommit _map;
		//Temporary solution end
		
		missionNamespace setVariable ["BIS_RscRespawnControls_mapInit", false];		//init finished, disable it for any future processing
	};
};