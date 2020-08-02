private _mode 		= _this param [0, false, [false]];
private _list 		= _this param [1, controlNull, [controlNull]];
private _itemArray 	= _this param [2, [], [[]]];

if (_mode) then
{
	//=== Add items ===
	_name = "";
	_pic = "";
	_metadata = [];
	_enemyPic = "\a3\ui_f\data\map\respawn\icon_enemy_ca.paa";	//enemy nearby icon

	{
		switch (typeName _x) do {
			case (typeName ""): {	//--- marker respawn point
				_pos = getMarkerPos _x;
				if !(_pos isEqualTo [0,0,0]) then {
					_nameArray = _x call BIS_fnc_showRespawnMenuPositionName;
					_name = _nameArray select 0;
					_pic = _nameArray select 1;
					_showName = _nameArray select 2;
					_metadata = [[_x,_name,_pic,_showName],[100],[false,false],[false,objNull]];
				} else {
					//error message - marker of this name doesn't exist!
					["Wrong marker respawn point - marker '_x' doesn't exist!",_x] call BIS_fnc_error;
					_name = "";
				};
			};
			case (typeName grpNull): {	//--- group respawn point
				_leader = leader _x;
				_nameArray = _x call BIS_fnc_showRespawnMenuPositionName;
				_name = _nameArray select 0;
				_pic = _nameArray select 1;
				_showName = _nameArray select 2;
				_alive = alive _leader;
				if (_alive && {!simulationEnabled _leader}) then {_alive = false};
				_metadata = [[_x,_name,_pic,_showName],[100],[true,true],[true,_leader]];
			};
			case (typeName objNull): {	//--- object respawn point
				if !(isNull _x) then {
					_nameArray = _x call BIS_fnc_showRespawnMenuPositionName;
					_name = _nameArray select 0;
					_pic = _nameArray select 1;
					_showName = _nameArray select 2;
					_alive = alive _x;
					if (_alive && {!simulationEnabled _x}) then {_alive = false};
					_metadata = [[_x,_name,_pic,_showName],[100],[true,true],[false,objNull]];
				} else {
					//error message - object is null
					["Wrong object respawn point - item '_x' is null!",_x] call BIS_fnc_error;
					_name = "";
				};
			};
			case (typeName []): {	//--- position array respawn point
				if ((count _x) in [2,3]) then {
					_nameArray = _x call BIS_fnc_showRespawnMenuPositionName;
					_name = _nameArray select 0;
					_pic = _nameArray select 1;
					_showName = _nameArray select 2;
					_metadata = [[_x,_name,_pic,_showName],[100],[false,false],[false,objNull]];
				} else {
					//error message - wrong number of elements in array
					["Wrong position array respawn point - item '_x' has wrong number of elements!",_x] call BIS_fnc_error;
					_name = "";
				};
			};
		};

		if (_name != "") then {
			_id = _list lbAdd _name;
			_list lbSetPicture [_id,_pic];

			_list lbSetPictureRight [_id,_enemyPic];
			_list lbSetPictureRightColor [_id,[0.5,0.5,0.5,0]];
			_list lbSetPictureRightColorSelected [_id,[0.5,0.5,0.5,0]];

			["set",_id,_metadata] call BIS_fnc_showRespawnMenuPositionMetadata;
		} else {
			//error message - empty element after processing
			["Item '_x' was not added to list of available respawn points!",_x] call BIS_fnc_error;
		};
	} forEach _itemArray;
	lbSort _list;
} else {
	//=== Remove items ===
	{
		_remove = _x;
		_size = lbSize _list;

		for "_i" from 0 to (_size - 1) do {
			_metadata = ["get",_i] call BIS_fnc_showRespawnMenuPositionMetadata;
			if (count _metadata > 0) then {	//there is at least something in metadata
				_identity = (_metadata select 0) select 0;
				if (_identity isEqualTo _remove) then {	//we found the right item to remove
					_disableState = "";
					_disableTime = time + 0.5;
					_idd = if (_identity isEqualType objNull) then {[_identity] call BIS_fnc_objectVar} else {_identity};
					_disableState = ["enable",_list,_i, _idd] call BIS_fnc_showRespawnMenuDisableItem;
					["delete",_i] call BIS_fnc_showRespawnMenuPositionMetadata;
					waitUntil {(_disableState != "") || {_disableTime > time}};
					_list lbDelete _i;
				};
			};
		};

	} forEach _itemArray;
};