if !(["objective5"] call BIS_fnc_taskExists) then {
	task_completed_5 = false;
	checkpoint_03_cleared = false;
	[BIS_grpMain,["objective5","objEscape"],[localize "STR_NNS_Escape_Objective_Checkpoint_desc",localize "STR_NNS_Escape_Objective_WestCheckpoint_title",""],getMarkerPos "NNS_checkpoint_marker_03","ASSIGNED",1,true,"attack"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_5} do {
			sleep 5;
			if (checkpoint_03_cleared) then {
				task_completed_5 = true;
				["objective5", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};



