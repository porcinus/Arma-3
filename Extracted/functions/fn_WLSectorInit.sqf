/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Spawns sector garrison based on its size, sends a patrolling vehicle if feasible.
*/

[_this, (_this getVariable "Size") / 2, (_this getVariable "Size") / 2, _this getVariable "BIS_WL_sectorSide"] spawn BIS_fnc_WLsectorPopulate;

_this spawn {
	if ((_this getVariable "BIS_WL_sectorSide") == RESISTANCE) then {
		_neighbors = (synchronizedObjects _this) select {typeOf _x == typeOf _this && (_x getVariable "BIS_WL_sectorSide") == RESISTANCE && !(_x in [BIS_WL_currentSector_WEST, BIS_WL_currentSector_EAST])};
		if (count _neighbors > 0) then {
			_roads = _this nearRoads ((_this getVariable "Size") / 2);
			{
				_neighbor = _x;
				if (random 1 >= 0.5) then {
					waitUntil {_this getVariable ["BIS_WL_vehiclesSpawned", FALSE]};
					_emptyRoads = _roads select {count (_x nearObjects ["LandVehicle", 20]) == 0 && count roadsConnectedTo _x > 0};
					if (count _emptyRoads > 0) then {
						_road = selectRandom _emptyRoads;
						_pos = position _road;
						_roadsConnected = roadsConnectedTo _road;
						_dir = random 360;
						if (count _roadsConnected > 0) then {
							_dir = _road getDir selectRandom _roadsConnected;
						};
						if (count BIS_WL_grpPool_patrols > 0) then {
							_grp = selectRandom BIS_WL_grpPool_patrols;
							["Sending patrol (%1) from %2 to %3", getText (_grp >> "name"), _this getVariable "Name", _x getVariable "Name"] call BIS_fnc_WLdebug;
							_grp = [_pos, RESISTANCE, _grp, nil, nil, nil, nil, nil, _dir] call BIS_fnc_spawnGroup;
							_grp spawn {
								sleep 3;
								{if ((typeOf _x) in BIS_WL_mortarUnits) then {if (vehicle _x == _x) then {deleteVehicle _x} else {(vehicle _x) deleteVehicleCrew _x}}} forEach units _this;
							};
							[_grp, 0] setWaypointPosition [_pos, 0];
							_grp setBehaviour "SAFE";
							_grp setSpeedMode "LIMITED";
							_veh = vehicle leader _grp;
							{
								if (vehicle _x == _x) then {
									_x assignAsCargo _veh;
									_x moveInCargo _veh;
								};
							} forEach units _grp;
							_wp1 = _grp addWaypoint [position _neighbor, (_neighbor getVariable "Size") / 2];
							_wp2 = _grp addWaypoint [position _this, (_this getVariable "Size") / 2];
							_wp2 setWaypointType "CYCLE";
							[_veh, -1, TRUE] spawn BIS_fnc_WLvehicleHandle;
							{
								_x addEventHandler ["Killed", {_null = (_this # 0) spawn {_grp = group _this; sleep BIS_WL_spawnedRemovalTime; if !(isNull _this) then {["Deleting dead patrol %1", _this] call BIS_fnc_WLdebug; if (vehicle _this == _this) then {deleteVehicle _this} else {(vehicle _this) deleteVehicleCrew _this}}; if (count units _grp == 0) then {deleteGroup _grp}}}];
								_x allowFleeing 0;
							} forEach units _grp;
						};
					};
				};
			} forEach _neighbors;
		};
	};
};