/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Spawns sector garrison.
*/

_sector = _this # 0;
_center = position (_this # 0);
_radX = _this # 1;
_radY = _this # 2;
_side = _this # 3;

_trgSizeIndex = (_radX * _radY) / 25e4;
_garrisonTotal = 0;
_sentriesTotal = 60 * _trgSizeIndex;
_vehArray = _sector getVariable "BIS_WL_vehicles";
_spawnPosArr = _sector getVariable "BIS_WL_spawnPosArr";
_spawnPosArrCnt = count _spawnPosArr;
_spawnPos = [];

{
	if (side (_x # 3) == _side) then {
		_veh = (_x # 0) createVehicle (_x # 1);
		_veh setPos (_x # 1);
		_veh setDir (_x # 2);
		createVehicleCrew _veh;
		_veh allowCrewInImmobile TRUE;
		_grp = group effectiveCommander _veh;
		_grp setFormDir (_x # 2);
		if ((count waypoints (_x # 3)) > 1) then {
			_grp copyWaypoints (_x # 3);
		} else {
			_SADWP = _grp addWaypoint [position _sector, 100];
			_SADWP setWaypointType "SAD";
			_SADWP = _grp addWaypoint [position _sector, 100];
			_SADWP setWaypointType "SAD";
			_cycleWP = _grp addWaypoint [position _sector, 100];
			_cycleWP setWaypointType "CYCLE";
		};
		deleteGroup (_x # 3);
		[_veh, _sector] call BIS_fnc_WLremovalHandle;
		_veh spawn {
			scriptName "WLSectorPopulate (stuck check)";
			while {!isNull _this} do {
				_pos = position _this;
				sleep 180;
				if ((crew _this) findIf {alive _x} >= 0 && (crew _this) findIf {isPlayer _x} == -1 && (position _this) distance _pos < 0.5) then {
					["%1 is stuck with %2, trying to unstuck", effectiveCommander _this, getText (BIS_WL_cfgVehs >> typeOf _this >> "displayName")] call BIS_fnc_WLdebug;
					_this setPos ([_this, 2, random 360] call BIS_fnc_relPos);
					effectiveCommander _this move position _this;
				};
			};
		};
		[_grp, _sector] call BIS_fnc_WLGarrisonRetreat;
	};
} forEach _vehArray;
_sector setVariable ["BIS_WL_vehiclesSpawned", TRUE];
	
if (_side == RESISTANCE) then {
	_sector spawn {
		_trg = _this getVariable "BIS_WL_sectorSeizeTrgGuer";
		while {(_this getVariable "BIS_WL_sectorSide") == RESISTANCE} do {
			if ((list _trg) findIf {behaviour _x == "COMBAT"} >= 0) exitWith {_this call BIS_fnc_WLSendResponseTeam};
			sleep 5;
		};
	};
};

_j = 0;
_unitArr = BIS_WL_unitsPool # (BIS_WL_sidesPool find _side);
_unitArrCnt = count _unitArr;

for [{_i = 0}, {_i < _garrisonTotal}, {_i = _i + 1}] do {
	if (_i < _spawnPosArrCnt) then {
		_spawnPos = _spawnPosArr # floor random _spawnPosArrCnt;
		_j = _j + 1;
	} else {
		_spawnPos = [_center, random 50, random 360] call BIS_fnc_relPos;
	};
	_newGrp = createGroup [_side, TRUE];
	while {count units _newGrp < 8} do {
		_newUnit = _newGrp createUnit [_unitArr # floor random _unitArrCnt, _spawnPos, [], 10, "FORM"];
		_newUnit setSkill (0.2 + random 0.3);
	};
	deleteWaypoint [_newGrp, 0];
	_wp = _newGrp addWaypoint [position leader _newGrp, 0];
	_wp setWaypointType "HOLD";
	{[_x, _sector] call BIS_fnc_WLremovalHandle; _x allowFleeing 0} forEach units _newGrp;
	[_newGrp, _sector] call BIS_fnc_WLGarrisonRetreat;
	sleep 1;
};

for [{_i = 0}, {_i < _sentriesTotal}, {_i = _i + 1}] do {
	_newGrp = grpNull;
	if (_i + _j < _spawnPosArrCnt) then {
		_spawnPos = _spawnPosArr # floor random _spawnPosArrCnt;
	} else {
		_spawnPos = [];
		_cycles = 0;
		while {_spawnPos isEqualTo [] && _cycles < 200} do {
			_cycles = _cycles + 1;
			_posStart = [_center, random (if (random 1 < 0.75) then {_radX / 3} else {_radX * 0.75}), random 360] call BIS_fnc_relPos;
			_spawnPos = _posStart isFlatEmpty [3, -1, 0.2, 5, 0, FALSE, player];
			if !(_spawnPos isEqualTo []) then {
				_spawnPos = ASLToATL _spawnPos;
				_nearObjs = _spawnPos nearObjects ["All", 10];
				if (count _nearObjs > 0) then {
					_spawnPos = [];
				};
			};
		};
	};
	if (count _spawnPos > 0) then {
		_newGrp = createGroup [_side, TRUE];
		while {count units _newGrp < 3} do {
			_newUnit = _newGrp createUnit [_unitArr # floor random _unitArrCnt, _spawnPos, [], 10, "FORM"];
			_newUnit setSkill (0.2 + random 0.3);
		};
		{[_x, _sector] call BIS_fnc_WLremovalHandle; _x allowFleeing 0} forEach units _newGrp;
		[_newGrp, _sector] call BIS_fnc_WLGarrisonRetreat;
		deleteWaypoint [_newGrp, 0];
		for [{_i2 = 1}, {_i2 <= 5}, {_i2 = _i2 + 1}] do {
			_wp = _newGrp addWaypoint [[_center, _radX, _radY] call BIS_fnc_WLrandomPosRect, 0];
			_wp setWaypointType "MOVE";
			_wp setWaypointSpeed "LIMITED";
			_wp setWaypointBehaviour "SAFE";
		};
		_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
		_wp setWaypointType "CYCLE";
		sleep 1;
	};
};