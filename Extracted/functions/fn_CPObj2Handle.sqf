_null = [] spawn {
	sleep 5;
	[{!alive BIS_comms}, 1] call BIS_fnc_CPWaitUntil;
	sleep 0.5;
	BIS_CP_alarm = TRUE;
	if !(missionNamespace getVariable ["BIS_CP_objectiveFailed", FALSE]) then {
		missionNamespace setVariable ["BIS_CP_objectiveDone", TRUE, TRUE];
		sleep 0.5;
		["BIS_CP_taskMain", "Succeeded"] call BIS_fnc_taskSetState;
	};
};