_null = [] spawn {
	_leaveTime = BIS_missionStartT + 1200;
	waitUntil {triggerActivated BIS_CP_detectedTrg || time > _leaveTime};
	while {count (waypoints group BIS_HVT) > 0} do {
		{deleteWaypoint _x} forEach waypoints group BIS_HVT;
	};
	_newWP = (group BIS_HVT) addWaypoint [position BIS_HVTVehicle, 0];
	_newWP setWaypointType "GETIN";
	_newWP waypointAttachVehicle BIS_HVTVehicle;
	_newWP = (group BIS_HVT) addWaypoint [BIS_escapeRoute, 50];
	_newWP setWaypointSpeed "NORMAL";
	sleep 2;
	{
		_x setBehaviour "AWARE";
		_x setSpeedMode "FULL";
		_x setCombatMode "GREEN";
	} forEach units group BIS_HVT;
};

_null = [] spawn {
	sleep 5;
	[{!alive BIS_HVT}, 1] call BIS_fnc_CPWaitUntil;
	sleep 0.5;
	if !(missionNamespace getVariable ["BIS_CP_objectiveFailed", FALSE]) then {
		missionNamespace setVariable ["BIS_CP_objectiveDone", TRUE, TRUE];
		sleep 0.5;
		["BIS_CP_taskMain", "Succeeded"] call BIS_fnc_taskSetState;
		sleep 0.5;
		"BIS_CP_taskExfil" call BIS_fnc_taskSetCurrent;
	};
};

_null = [] spawn {
	sleep 5;
	_failDistance = (BIS_CP_radius_reinforcements * 2) min ((BIS_escapeRoute distance BIS_CP_targetLocationPos) - 200);
	[{alive BIS_HVT && BIS_HVT distance2D BIS_CP_targetLocationPos > _failDistance}, 1] call BIS_fnc_CPWaitUntil;
	missionNamespace setVariable ["BIS_CP_objectiveFailed", TRUE, TRUE];
	missionNamespace setVariable ["BIS_CP_objectiveTimeout", TRUE, TRUE];
	["BIS_CP_taskMain", "Failed"] call BIS_fnc_taskSetState;
	sleep 0.5;
	"BIS_CP_taskExfil" call BIS_fnc_taskSetCurrent;
};