[] spawn {
	waitUntil {missionNamespace getVariable ["BIS_CP_objectiveTimeout", FALSE]};
	playSound ((selectRandom ["cp_timeout_induced_exfil_1", "cp_timeout_induced_exfil_2", "cp_timeout_induced_exfil_3"]) + BIS_CP_protocolSuffix);
};