/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Spawns and manages response teams.
*/

if (_this in (BIS_WL_conqueredSectors_WEST + BIS_WL_conqueredSectors_EAST)) exitWith {};

_neigbours = _this getVariable "BIS_WL_connectedSectors";

{if (count (_x getVariable "BIS_WL_responseArr") == 0 || (_x in [BIS_WL_currentSector_WEST, BIS_WL_currentSector_EAST])) then {_neigbours = _neigbours - [_x]}} forEach _neigbours;

if (count _neigbours == 0) exitWith {};

_nearest = _neigbours # 0;

{if ((_x distance _this) < (_nearest distance _this)) then {_nearest = _x}} forEach _neigbours;

_responsesAvail = _nearest getVariable "BIS_WL_responseArr";
_response = _responsesAvail # floor random count _responsesAvail;
_responseType = _response getVariable "Group";

_nearest setVariable ["BIS_WL_responseArr", (_nearest getVariable "BIS_WL_responseArr") - [_response]];

_responseGrpArr = switch (_responseType) do {
	case 0: {
			BIS_WL_grpPool_infantry +
			BIS_WL_grpPool_motorized +
			BIS_WL_grpPool_mechanized +
			BIS_WL_grpPool_armored
		};
	case 1: {[]};
	case 2: {BIS_WL_grpPool_infantry};
	case 3: {BIS_WL_grpPool_mechanized};
	case 4: {BIS_WL_grpPool_motorized};
	case 5: {BIS_WL_grpPool_armored};
	default {[]};
};

_responseGrp = grpNull;
_heliGrp = grpNull;

if (count _responseGrpArr > 0) then {
	_responseGrp = [position _response, INDEPENDENT, _responseGrpArr # floor random count _responseGrpArr] call BIS_fnc_spawnGroup;
	_responseGrp spawn {
		sleep 3;
		{if ((typeOf _x) in BIS_WL_mortarUnits) then {if (vehicle _x == _x) then {deleteVehicle _x} else {(vehicle _x) deleteVehicleCrew _x}}} forEach units _this;
	};
} else {
	_responseVehs = _response getVariable "BIS_WL_responseVehs";
	if (_responseType == 1) then {
		{
			_veh = createVehicle [_x, position _response, [], 0, "FLY"];
			createVehicleCrew _veh;
			_veh allowCrewInImmobile TRUE;
			if (isNull _responseGrp) then {
				_responseGrp = group effectiveCommander _veh;
			} else {
				_grp = group effectiveCommander _veh;
				(crew _veh) joinSilent _responseGrp;
				deleteGroup _grp;
			};
		} forEach _responseVehs;
	} else {
		_veh = createVehicle [selectRandom _responseVehs, position _response, [], 0, "FLY"];
		_veh flyInHeight 100;
		createVehicleCrew _veh;
		_heliGrp = group effectiveCommander _veh;
		(waypoints _heliGrp) # 0 setWaypointPosition [position _response, 0];
		_largeGroups = BIS_WL_grpPool_infantry select {count ('TRUE' configClasses _x) > 4};
		_responseGrp = [position _response, INDEPENDENT, selectRandom _largeGroups] call BIS_fnc_spawnGroup;
		_responseGrp spawn {
			sleep 3;
			{if ((typeOf _x) in BIS_WL_mortarUnits) then {if (vehicle _x == _x) then {deleteVehicle _x} else {(vehicle _x) deleteVehicleCrew _x}}} forEach units _this;
		};
		{_x addBackpack "B_Parachute"; _x assignAsCargo _veh; _x moveInCargo _veh} forEach units _responseGrp;
		{if (vehicle _x == _x) then {deleteVehicle _x}} forEach units _responseGrp;
	};
};

(waypoints _responseGrp) # 0 setWaypointPosition [position _response, 0];

_responseGrp setVariable ["BIS_WL_groupVehs", []];
["Response team sent to %1 from %2", _this getVariable "Name", _nearest getVariable "Name"] call BIS_fnc_WLdebug;
[_responseGrp, _this] call BIS_fnc_WLGarrisonRetreat;
_grpVehs = [];
{
	_grpVehs pushBackUnique vehicle _x;
	_x addEventHandler ["Killed", {_null = (_this # 0) spawn {_grp = group _this; sleep BIS_WL_spawnedRemovalTime; if !(isNull _this) then {["Deleting dead response %1", _this] call BIS_fnc_WLdebug; if (vehicle _this == _this) then {deleteVehicle _this} else {(vehicle _this) deleteVehicleCrew _this}}; if (count units _grp == 0) then {deleteGroup _grp}}}];
} forEach units _responseGrp;
{
	[_x, -1, TRUE] spawn BIS_fnc_WLvehicleHandle;
	_x spawn {
		scriptName "WLSendResponseTeam (stuck check)";
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
} forEach _grpVehs;
[_responseGrp, _this, _responseType] spawn {
	scriptName "WLSendResponseTeam (path segmentation)";
	if ((_this # 2) != 6) then {
		_wp = (_this # 0) addWaypoint [position leader (_this # 0), 10, currentWaypoint (_this # 0)];
	};
	sleep 10;
	{if (vehicle _x == _x) then {_x assignAsCargo vehicle leader _x; [_x] orderGetIn TRUE}} forEach units (_this # 0);
	_SADWP = (_this # 0) addWaypoint [position (_this # 1), 100];
	_SADWP setWaypointType "SAD";
	_SADWP = (_this # 0) addWaypoint [position (_this # 1), 100];
	_SADWP setWaypointType "SAD";
	_cycleWP = (_this # 0) addWaypoint [position (_this # 1), 100];
	_cycleWP setWaypointType "CYCLE";
};
if (_responseType == 6) then {
	_wpPos = [_response, (_response distance _this) + 500, _response getDir _this] call BIS_fnc_relPos;
	_wp = _heliGrp addWaypoint [_wpPos, 0];
	_wp = _heliGrp addWaypoint [position _response, 0];
	[_heliGrp, _responseGrp, _wpPos, waypointPosition _wp] spawn {
		_heliGrp = _this # 0;
		_responseGrp = _this # 1;
		_wpPos = _this # 2;
		_endPos = _this # 3;
		waitUntil {((leader _heliGrp) distance2D _wpPos) < 1000};
		_tmout = random 5;
		sleep _tmout;
		{
			_x leaveVehicle vehicle _x;
			unassignVehicle _x;
			[_x] orderGetIn FALSE;
			_x action ["Eject", vehicle _x];
			sleep 0.5;
		} forEach units _responseGrp;
		
		// --- the pilot just stopped moving after the paradrop, so I've decided to simply replace him
		
		_heli = vehicle leader _heliGrp;
		_oldPilot = effectiveCommander _heli;
		_newPilot = group _oldPilot createUnit [typeOf _oldPilot, position _heli, [], 0, "NONE"];
		_oldPilot setPos position _heli;
		deleteVehicle _oldPilot;
		group _newPilot selectLeader _newPilot;
		_newPilot assignAsDriver _heli;
		_newPilot moveInDriver _heli;
		_newPilot action ["EngineOn", _heli];
		waitUntil {unitReady leader _heliGrp && _heli distance2D _endPos < 500};
		_heli = vehicle leader _heliGrp;
		_heli land "LAND";
		waitUntil {(position _heli) select 2 < 5};
		{_heli deleteVehicleCrew _x} forEach crew _heli;
		deleteVehicle _heli;
		deleteGroup _heliGrp;
	};
};