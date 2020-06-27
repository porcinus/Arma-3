if !(["objective0"] call BIS_fnc_taskExists) then {
	task_completed_0 = false;

	[BIS_grpMain,["objective0","objEscape"],[localize "STR_NNS_Objective_JTAGofficer_desc",localize "STR_NNS_Objective_JTAGofficer_title",""],getMarkerPos "objective_zone_0","ASSIGNED",1,true,"kill"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_0} do {
			sleep 5;
			if (!alive (objective_target_0)) then {
				task_completed_0 = true;
				["objective0", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};
