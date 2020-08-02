_null = [] spawn {
	[BIS_CP_grpMain, "BIS_CP_taskSurvive", ["STR_A3_combatpatrol_mission_14", "STR_A3_combatpatrol_mission_15", ""], nil, FALSE, nil, FALSE, "Heal", FALSE] call BIS_fnc_taskCreate;
	[BIS_CP_grpMain, "BIS_CP_taskMain", ["STR_A3_combatpatrol_mission_67", "STR_A3_combatpatrol_mission_66", ""], nil, TRUE, nil, TRUE, "Attack"] call BIS_fnc_taskCreate;
	sleep 0.5;
	[BIS_CP_grpMain, "BIS_CP_taskExfil", ["STR_A3_combatpatrol_mission_16", "STR_A3_combatpatrol_mission_17", ""], BIS_CP_exfilPos, FALSE, 1, FALSE, "Exit", TRUE] call BIS_fnc_taskCreate;
};