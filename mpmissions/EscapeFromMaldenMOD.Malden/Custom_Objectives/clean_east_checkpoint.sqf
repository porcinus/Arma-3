if !(["objective2"] call BIS_fnc_taskExists) then {
	task_completed_2 = false;
	checkpoint_02_cleared = false;
	[BIS_grpMain,["objective2","objEscape"],[localize "STR_NNS_Objective_Checkpoint_desc",localize "STR_NNS_Objective_EastCheckpoint_title",""],getMarkerPos "NNS_checkpoint_marker_02","ASSIGNED",1,true,"attack"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_2} do {
			sleep 5;
			if (checkpoint_02_cleared) then {
				task_completed_2 = true;
				["objective2", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};