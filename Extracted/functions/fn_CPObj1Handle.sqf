_null = [] spawn {
	[{damage BIS_CP_objective_vehicle1 > 0.5 && !canMove BIS_CP_objective_vehicle1}, 1] call BIS_fnc_CPWaitUntil;
	if !(missionNamespace getVariable ["BIS_CP_objectiveFailed", FALSE]) then {
		["BIS_CP_task1", "Succeeded"] call BIS_fnc_taskSetState;
	};
	BIS_CP_alarm = TRUE;
};
_null = [] spawn {
	[{damage BIS_CP_objective_vehicle2 > 0.5 && !canMove BIS_CP_objective_vehicle2}, 1] call BIS_fnc_CPWaitUntil;
	if !(missionNamespace getVariable ["BIS_CP_objectiveFailed", FALSE]) then {
		["BIS_CP_task2", "Succeeded"] call BIS_fnc_taskSetState;
	};
	BIS_CP_alarm = TRUE;
};
_null = [] spawn {
	sleep 5;
	[{("BIS_CP_task1" call BIS_fnc_taskCompleted) && ("BIS_CP_task2" call BIS_fnc_taskCompleted)}, 1] call BIS_fnc_CPWaitUntil;
	sleep 0.5;
	if !(missionNamespace getVariable ["BIS_CP_objectiveFailed", FALSE]) then {
		missionNamespace setVariable ["BIS_CP_objectiveDone", TRUE, TRUE];
		["BIS_CP_taskMain", "Succeeded"] call BIS_fnc_taskSetState;
	};
};