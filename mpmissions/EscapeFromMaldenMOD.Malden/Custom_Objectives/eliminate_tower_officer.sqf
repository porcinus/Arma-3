
if !(["objective3"] call BIS_fnc_taskExists) then {
	task_completed_3 = false;

	[BIS_grpMain,["objective3","objEscape"],[localize "STR_NNS_Objective_TowerOfficer_desc",localize "STR_NNS_Objective_TowerOfficer_title",""],getMarkerPos "objective_zone_3","ASSIGNED",1,true,"kill"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_3} do {
			sleep 5;
			if (!alive (objective_target_3)) then {
				task_completed_3 = true;
				["objective3", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};
