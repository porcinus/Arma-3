if !("BIS_CP_taskMain" call BIS_fnc_taskCompleted) then {
	missionNamespace setVariable ["BIS_CP_objectiveFailed", TRUE, TRUE];
	["BIS_CP_taskMain", "Canceled"] call BIS_fnc_taskSetState;
};