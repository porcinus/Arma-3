
if !(["objective6"] call BIS_fnc_taskExists) then {
	task_completed_6 = false;
	destroyed_camp_01_cleared = false; //may be deleted in the future
	destroyed_camp_01_discovered = false;
	[BIS_grpMain,["objective6","objEscape"],[localize "STR_NNS_Objective_ExploreOldCSATbase_desc",localize "STR_NNS_Objective_ExploreOldSouthCSATbase_title",""],getMarkerPos "objective_zone_6","ASSIGNED",1,true,"scout"] call BIS_fnc_taskCreate;

	[] spawn {
		{ // set random damage and fuel to tanks/truck
			_x enableDynamicSimulation true;
			_x setFuel (0.2 + (random 0.2));
			[_x,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
		} forEach [destroyed_camp_01_veh_0,destroyed_camp_01_veh_1,destroyed_camp_01_veh_2];
		
		while {!task_completed_6} do {
			sleep 5;
			if (destroyed_camp_01_discovered) then {
				task_completed_6 = true;
				["objective6", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};
