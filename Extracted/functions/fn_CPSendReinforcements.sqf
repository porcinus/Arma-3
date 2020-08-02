/*
	Author: Josef Zemanek

	Description:
	Combat Patrol reinforcements handle
*/

params [
	"_reinfType",
	["_cnt", 1],
	["_roadSegment", objNull]
];

if (isNull _roadSegment) then {
	_roadSegment = selectRandom BIS_CP_reinf_approach_roads;
};
_connected = roadsConnectedTo _roadSegment;
_nearestToTarget = objNull;
{if ((_x distance BIS_CP_targetLocationPos) < (_nearestToTarget distance BIS_CP_targetLocationPos)) then {_nearestToTarget = _x}} forEach _connected;
_dir = _nearestToTarget getDir BIS_CP_targetLocationPos;

_reinfGrp = grpNull;
_grpVeh = objNull;
_vehType = "";

_sleep = TRUE;

_startingPos = position _roadSegment;

if (typeName _reinfType == typeName "") then {
	_vehType = toLower getText (configFile >> "CfgVehicles" >> _reinfType >> "vehicleClass");
	_veh = createVehicle [_reinfType, position _roadSegment, [], 0, if (_vehType in ["air", "autonomous"]) then {"FLY"} else {"NONE"}];
	if (toLower missionName == "mp_combatpatrol_03" && toLower worldName == "tanoa" && toLower _reinfType == "o_heli_transport_04_covered_f") then {
		[_veh, "Black"] call BIS_fnc_initVehicle;
	};
	if (_vehType in ["air", "autonomous"]) then {
		_sleep = FALSE;
		_newPos = [BIS_CP_targetLocationPos, BIS_CP_radius_reinforcements * 3, random 360] call BIS_fnc_relPos;
		_startingPos = _newPos;
		if (_vehType == "autonomous" && toLower getText (configFile >> "CfgVehicles" >> _reinfType >> "simulation") == "airplanex") then {
			_newPos set [2, 300];
			_veh flyInHeight 250;
		} else {
			_newPos set [2, 75];
		};
		_veh setPos _newPos;
		_veh setDir (_veh getDir BIS_CP_targetLocationPos);
	} else {
		_veh setDir _dir;
	};
	if (_vehType == "car") then {
		_reinfGrp = [[_veh, 15, random 360] call BIS_fnc_relPos, BIS_CP_enemySide, BIS_CP_enemyGrp_fireTeam] call BIS_fnc_spawnGroup;
		_grpVeh = _veh;
		{unassignVehicle _x; [_x] orderGetIn FALSE} forEach units _reinfGrp;
		_reinfGrp addVehicle _grpVeh;
	} else {
		createVehicleCrew _veh;
		_reinfGrp = group effectiveCommander _veh;
		_grpVeh = vehicle leader _reinfGrp;
	};
} else {
	_reinfGrp = [position _roadSegment, BIS_CP_enemySide, _reinfType] call BIS_fnc_spawnGroup;
	_grpVeh = (position leader _reinfGrp) nearestObject "Car";
	_vehType = "car";
	{unassignVehicle _x; [_x] orderGetIn FALSE} forEach units _reinfGrp;
	_reinfGrp addVehicle _grpVeh;
};

if (_vehType != "air") then {
	for [{_i = 0}, {_i < 1}, {_i = _i + 1}] do {
		_newWP = _reinfGrp addWaypoint [BIS_CP_targetLocationPos, BIS_CP_radius_core];
		_newWP setWaypointType "SAD";
	};
	_newWP = _reinfGrp addWaypoint [BIS_CP_targetLocationPos, BIS_CP_radius_core];
	_newWP setWaypointType "GUARD";
	if (_vehType == "car") then {
		_null = [_reinfGrp, _startingPos, _grpVeh] spawn {
			_reinfGrp = _this select 0;
			_startingPos = _this select 1;
			_grpVeh = _this select 2;
			
			_leader = leader _reinfGrp;
			[{_leader distance2D BIS_CP_targetLocationPos < BIS_CP_radius_insertion || !alive _leader || !canMove _grpVeh}, 10 + random 5] call BIS_fnc_CPWaitUntil;
			if (!alive _leader || !canMove _grpVeh) exitWith {};
			[_leader] joinSilent grpNull;
			_newGrp = group _leader;
			_reinfGrp leaveVehicle _grpVeh;
			{unassignVehicle _x; [_x] orderGetIn FALSE; _x allowFleeing 0} forEach units _reinfGrp;
			[{{vehicle _x == _grpVeh} count units _reinfGrp == 0 || !alive _leader || !canMove _grpVeh}, 1] call BIS_fnc_CPWaitUntil;
			if (!alive _leader || !canMove _grpVeh) exitWith {};
			_leader assignAsDriver _grpVeh;
			[_leader] orderGetIn TRUE;
			if (vehicle _leader == _grpVeh) then {
				_leader setPos position _grpVeh;
				_leader moveInDriver _grpVeh;
			};
			sleep 20;
			_newWP = _newGrp addWaypoint [_startingPos, 0];
			[{_grpVeh distance2D _startingPos < 50 || !alive _leader || !canMove _grpVeh}, 0.5] call BIS_fnc_CPWaitUntil;
			if (!alive _leader || !canMove _grpVeh) exitWith {};
			_grpVeh deleteVehicleCrew driver _grpVeh;
			deleteGroup _newGrp;
			deleteVehicle _grpVeh;
		};
	};
} else {
	_reinfGrp setBehaviour "CARELESS";
	_paraUnit = [[_grpVeh, 15, random 360] call BIS_fnc_relPos, BIS_CP_enemySide, BIS_CP_enemyGrp_rifleSquad] call BIS_fnc_spawnGroup;
	{
		_x assignAsCargo _grpVeh;
		[_x] orderGetIn TRUE;
		_x moveInCargo _grpVeh;
		_x allowFleeing 0;
	} forEach units _paraUnit;
	_unloadWP = _reinfGrp addWaypoint [BIS_CP_exfilPos, 100];
	_unloadWP setWaypointStatements ["TRUE", "(vehicle this) land 'GET OUT'; {unassignVehicle _x; [_x] orderGetIn FALSE} forEach ((crew vehicle this) select {group _x != group this})"];
	_newWP = _reinfGrp addWaypoint [waypointPosition _unloadWP, 0];
	_newWP setWaypointStatements ["{group _x != group this} count crew vehicle this == 0", ""];
	_newWP = _reinfGrp addWaypoint [_startingPos, 0];
	_null = [_reinfGrp, _startingPos] spawn {
		_reinfGrp = _this select 0;
		_startingPos = _this select 1;
		_heli = vehicle leader _reinfGrp;
		[{(leader _reinfGrp) distance2D _startingPos > 200 || !alive (leader _reinfGrp) || !canMove _heli}, 5] call BIS_fnc_CPWaitUntil;
		[{(leader _reinfGrp) distance2D _startingPos < 200 || !alive (leader _reinfGrp) || !canMove _heli}, 0.5] call BIS_fnc_CPWaitUntil;
		if (!alive (leader _reinfGrp) || !canMove _heli) exitWith {};
		{_heli deleteVehicleCrew _x} forEach crew _heli;
		deleteGroup _reinfGrp;
		deleteVehicle _heli;
	};
	for [{_i = 0}, {_i < 3}, {_i = _i + 1}] do {
		_newWP = _paraUnit addWaypoint [BIS_CP_exfilPos, 100];
		_newWP setWaypointType "SAD";
	};
	_newWP = _paraUnit addWaypoint [BIS_CP_exfilPos, 100];
	_newWP setWaypointType "CYCLE";
};

_cnt = _cnt - 1;

if (_cnt > 0) then {
	_null = [_reinfType, _cnt, _roadSegment, _grpVeh] spawn {
		waitUntil {(_this select 3) distance (_this select 2) > 20};
		_this call BIS_fnc_CPSendReinforcements;
	};
};

if (_sleep) then {
	sleep 30;
};