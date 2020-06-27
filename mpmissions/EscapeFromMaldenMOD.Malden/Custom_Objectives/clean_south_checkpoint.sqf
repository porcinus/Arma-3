if !(["objective1"] call BIS_fnc_taskExists) then {
	task_completed_1 = false;
	checkpoint_01_cleared = false;
	[BIS_grpMain,["objective1","objEscape"],[localize "STR_NNS_Objective_Checkpoint_desc",localize "STR_NNS_Objective_SouthCheckpoint_title",""],getMarkerPos "NNS_checkpoint_marker_01","ASSIGNED",1,true,"attack"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_1} do {
			sleep 5;
			if (checkpoint_01_cleared) then {
				task_completed_1 = true;
				["objective1", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};