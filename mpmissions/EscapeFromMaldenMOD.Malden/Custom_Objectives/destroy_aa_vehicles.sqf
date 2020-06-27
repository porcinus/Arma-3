if !(["objective9"] call BIS_fnc_taskExists) then {
	task_completed_9 = false;

	[BIS_grpMain,["objective9","objEscape"],[localize "STR_NNS_Objective_AAvehicles_desc",localize "STR_NNS_Objective_AAvehicles_title",""],getMarkerPos "objective_zone_9","ASSIGNED",1,true,"destroy"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_9} do {
			sleep 5;
			if (!alive (objective_9_group_0_vehi) && {!alive (objective_9_group_1_vehi)} && {!alive (objective_9_group_2_vehi)}) then {
				task_completed_9 = true;
				["objective9", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};