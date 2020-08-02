
_identity = _this;
_name = "";
_pic = "";
_showName = true;
_respawnPositions = (player call bis_fnc_getRespawnPositions) + ((player call bis_fnc_objectSide) call bis_fnc_getRespawnMarkers);
_respawnPositionNames = [player,true] call bis_fnc_getRespawnPositions;
_respawnPositionNameShow = [player,2] call bis_fnc_getRespawnPositions;
_pos = _respawnPositions find _identity;

if (_pos < 0) exitWith {[_name,_pic,_showName]};	//if identity not found, exit with default values (positionList fnc which called this fnc will skip this result because name is an empty string)

switch (typeName _identity) do {
	case (typeName ""): {
		_name = if !(_pos > ((count _respawnPositionNames) - 1)) then {_respawnPositionNames select _pos} else {markertext _identity};
		_pic = if (markertype _identity == "empty") then {""} else {(markertype _identity) call bis_fnc_textureMarker};
		if !(_pos > ((count _respawnPositionNameShow) - 1)) then {_showName = _respawnPositionNameShow select _pos};
	};
	case (typeName grpNull);
	case (typeName objNull): {
		_name = if !(_pos > ((count _respawnPositionNames) - 1)) then {_respawnPositionNames select _pos};
		if !(_pos > ((count _respawnPositionNameShow) - 1)) then {_showName = _respawnPositionNameShow select _pos};
		if (typename _identity == typename grpnull) then {_identity = leader _identity};
		_xVeh = vehicle _identity;
		if (_xVeh iskindof "allvehicles") then {
			if (_name == "") then {
				_name = name _identity;
				if (isnull group _identity) then {
					_name = gettext (configfile >> "cfgvehicles" >> typeof _xVeh >> "displayName");
				} else {
					if !(isplayer _identity) then {
						_name = format ["%1: %2",localize "str_player_ai",_name]
					};
				};
			};
			_pic = gettext (configfile >> "cfgvehicles" >> typeof _xVeh >> "icon") call bis_fnc_textureVehicleIcon;
		};
	};
	case (typeName []): {
		_name = if !(_pos > ((count _respawnPositionNames) - 1)) then {_respawnPositionNames select _pos};
		if !(_pos > ((count _respawnPositionNameShow) - 1)) then {_showName = _respawnPositionNameShow select _pos};
	};
};

_xPos = _identity call bis_fnc_position;
if (_name == "") then {_name = _xPos call bis_fnc_locationdescription};
if (_pic == "") then {
	_pic = if ((_xPos select 2) > 20) then {"respawn_para" call bis_fnc_texturemarker} else {"respawn_inf" call bis_fnc_texturemarker};
};

[_name,_pic,_showName]