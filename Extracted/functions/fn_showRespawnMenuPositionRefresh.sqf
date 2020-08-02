private _list = _this param [0, controlNull, [controlNull]];
private _size = lbSize _list;

for "_i" from 0 to (_size - 1) do
{
	_metadata = ["get",_i] call BIS_fnc_showRespawnMenuPositionMetadata;
	if (count _metadata > 0) then {
		_identity = (_metadata select 0) select 0;
		_enemyState = (_metadata select 1) select 0;
		_aliveArray = _metadata select 2;
		_aliveCheck = _aliveArray select 0;
		_aliveState = _aliveArray select 1;
		_change = false;

		//--- enemies around check
		_pos = [0,0,0];
		_radius = 100;	//radius where enemies are checked
		_enemyStateNew = _radius;
		switch (typeName _identity) do {
			case (typeName ""): {_pos = getMarkerPos _identity};
			case (typeName grpNull): {_pos = getPos (leader _identity)};
			case (typeName objNull): {_pos = getPos _identity};
			case (typeName []): {_pos = _identity};
		};
		if !(_pos isEqualTo [0,0,0]) then {
			_dist = _radius;
			{
				if (alive _x && {side group _x != side group player} && {_x distance _pos < _dist} && {side group _x != civilian}) then {
					_dist = _x distance _pos;
				};
			} forEach allUnits;
			if (_dist < 100) then {_enemyStateNew = _dist};	//someone is closer than limit, store that info

			if (_enemyState != _enemyStateNew) then {	//something has changed, store it to metadata
				_metadata set [1,[_enemyStateNew]];
				if ((!_aliveCheck) || {_aliveState}) then {	//work with icon only if object is alive or there is no live check applied
					if (_enemyStateNew < 100) then {	//setting proper info icon in the list (icon in the map is handled by map script)
						_list lbSetPictureRightColor [_i,[1,1,1,1]];
						_list lbSetPictureRightColorSelected [_i,[1,1,1,1]];
					} else {
						_list lbSetPictureRightColor [_i,[1,1,1,0]];
						_list lbSetPictureRightColorSelected [_i,[1,1,1,0]];
					};
				};
				_change = true;
			};
		};

		//--- alive & leader check (only for group and object respawn points)
		if (_aliveCheck) then {
			_obj = objNull;

			//leader check (only for group respawn points)
			_leaderArray = _metadata select 3;
			_leaderCheck = _leaderArray select 0;
			if (_leaderCheck) then {
				_leader = _leaderArray select 1;
				_leaderNew = leader _identity;
				if (_leader != _leaderNew) then {
					_leaderArray set [1,_leaderNew];
					_metadata set [3,_leaderArray];
					_change = true;
					_leader = _leaderNew;
				};

				_obj = _leader;	//obj for alive testing is leader (group respawn)
			} else {
				_obj = (_metadata select 0) select 0;	//obj for alive testing is the identity (object respawn)
			};

			//alive check
			_aliveStateNew = alive _obj;
			if (_aliveStateNew && {!simulationEnabled _obj}) then {_aliveStateNew = false};
			if !(_aliveState isEqualTo _aliveStateNew) then {
				_aliveArray set [1,_aliveStateNew];
				_metadata set [2,_aliveArray];
				_change = true;

				_deadPic = "\a3\ui_f\data\map\respawn\icon_dead_ca.paa";	//dead marking
				_enemyPic = "\a3\ui_f\data\map\respawn\icon_enemy_ca.paa";	//enemy nearby icon
				if (_aliveStateNew) then {	//disabling/enabling position based on the alive check result + icon marking
					["enable",_list,_i,"",[_obj] call BIS_fnc_objectVar] call BIS_fnc_showRespawnMenuDisableItem;
					_list lbSetPictureRight [_i,_enemyPic];
					_list lbSetPictureRightColor [_i,[1,1,1,0]];
					_list lbSetPictureRightColorSelected [_i,[1,1,1,0]];
				} else {
					_message = "";
					if ((_obj isKindOf "LandVehicle") || {_obj isKindOf "Air"} || {_obj isKindOf "Ship"}) then {_message = localize "STR_A3_RscRespawnControls_VehicleUnavailable"};
					if (_obj isKindOf "Man") then {_message = localize "STR_A3_RscRespawnControls_UnitUnavailable"};
					["disable",_list,_i,_message,[_obj] call BIS_fnc_objectVar] call BIS_fnc_showRespawnMenuDisableItem;
					_list lbSetPictureRight [_i,_deadPic];
					_list lbSetPictureRightColor [_i,[1,1,1,1]];
					_list lbSetPictureRightColorSelected [_i,[1,1,1,1]];
				};
			};
		};

		//--- metadata changed, store the new version in the list item
		if (_change) then {
			["update",_i,_metadata] call BIS_fnc_showRespawnMenuPositionMetadata;
		};

	} else {
		debugLog "BIS_fnc_showRespawnMenuPositionRefresh: Warning! An item with no metadata in the position list UI control!";
	};
};