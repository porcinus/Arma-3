_state = _this select 0;
_params = _this select 1;

with uiNamespace do {
	switch _state do {
		case "moving": {
			_ctrlMap = _params select 0;
			_mX = _params select 1;
			_mY = _params select 2;
			_dis = 0.039;
			_selected = nil;
			{
				_identity = (_x select 0) select 0;
				_pos = [0,0,0];
				switch (typeName _identity) do {
					case (typeName ""): {_pos = getMarkerPos _identity};
					case (typeName grpNull): {_pos = getPos (leader _identity)};
					case (typeName objNull): {_pos = getPos _identity};
					case (typeName []): {_pos = _identity};
				};
				_mPos = _ctrlMap ctrlmapworldtoscreen _pos;
				if (_mPos distance [_mX,_mY] < _dis) then {
					_selected = _identity;
				};
			} foreach BIS_RscRespawnControls_posMetadata;
			BIS_RscRespawnControls_cursor = if (isNil "_selected") then {nil} else {_selected};
		};

		case "click": {
			_selected = BIS_RscRespawnControls_cursor;
			if !(isNil "_selected") then {
				_list = BIS_RscRespawnControlsMap_ctrlLocList;
				_size = lbSize _list;

				for "_i" from 0 to (_size - 1) do {
					_metadata = ["get",_i] call BIS_fnc_showRespawnMenuPositionMetadata;
					if ((count _metadata > 0) && {((_metadata select 0) select 0) isEqualTo _selected}) then {
						_list lbSetCurSel _i;
						BIS_RscRespawnControls_selected set [0,_i];
					};
				};
			};
		};
	};
};