
if !(["objective8"] call BIS_fnc_taskExists) then {
	task_completed_8 = false;
	destroyed_camp_02_cleared = false; //may be deleted in the future
	destroyed_camp_02_discovered = false;
	[BIS_grpMain,["objective8","objEscape"],[localize "STR_NNS_Objective_ExploreOldCSATbase_desc",localize "STR_NNS_Objective_ExploreOldEastCSATbase_title",""],getMarkerPos "objective_zone_8","ASSIGNED",1,true,"scout"] call BIS_fnc_taskCreate;

	[] spawn {
		{ // set random damage and fuel to tanks/truck
			_x enableDynamicSimulation true;
			_x setFuel (0.2 + (random 0.2));
			[_x,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
		} forEach [destroyed_camp_02_veh_0,destroyed_camp_02_veh_1,destroyed_camp_02_veh_2];
		
		while {!task_completed_8} do {
			sleep 5;
			if (destroyed_camp_02_discovered) then {
				task_completed_8 = true;
				["objective8", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};
