if !("BIS_CP_taskMain" call BIS_fnc_taskCompleted) then {
	missionNamespace setVariable ["BIS_CP_objectiveFailed", TRUE, TRUE];
	if !("BIS_CP_task1" call BIS_fnc_taskCompleted) then {
		["BIS_CP_task1", "Canceled", FALSE] call BIS_fnc_taskSetState;
	};
	if !("BIS_CP_task2" call BIS_fnc_taskCompleted) then {
		["BIS_CP_task2", "Canceled", FALSE] call BIS_fnc_taskSetState;
	};
	["BIS_CP_taskMain", "Canceled"] call BIS_fnc_taskSetState;
};