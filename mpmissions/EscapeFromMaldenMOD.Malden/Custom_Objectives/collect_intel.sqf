if !(["objective7"] call BIS_fnc_taskExists) then {
	task_completed_7 = false;
	
	_markerListHide = missionNamespace getVariable ["markerListHide",[]]; //checkpoint marker list
	
	_hostageBarnlist = [[2674,5837,0],[3026,5904,0],[2426,5179,0],[2475,5083,0],[2243,3248,0]]; //barns around intel position
	_hostageBarn = selectRandom _hostageBarnlist; //select random barn
	
	_objects = [objective_7_intel_0, objective_7_intel_1, objective_7_intel_2, objective_7_intel_3, objective_7_intel_4];
	
	for "_i" from 0 to 3 do { //select 4 random object and 4 random marker to reveal
		_rndObject = _objects call BIS_fnc_selectRandom; //select random object
		_rndMarker = _markerListHide call BIS_fnc_selectRandom; //select random marker
		[_rndObject, [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["markeralpha",_rndMarker,1]]] remoteExec ["addAction", 0, true];
		_objects deleteAt (_objects find _rndObject); //remove from object array
		_markerListHide deleteAt (_markerListHide find _rndMarker); //remove from marker array
	};
	
	//Rescue CSAT squat, lead to CSAT sniper if success
	[(_objects select 0), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","scripts\RescueCSATsquad.sqf",[_hostageBarn,["rescueCSATsquad0","objEscape"],BIS_grpMain,["meetCSATsniper0","objEscape"]]]]] remoteExec ["addAction", 0, true];
	
	//[[(_objects select 0), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","TMP.sqf",["bla1","bla2","bla3","bla4"]]]], "addAction", true, true] call BIS_fnc_MP; //add action
	//[[(_objects select 1), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","TMP.sqf",["bla1","bla2","bla3","bla4"],true]]], "addAction", true, true] call BIS_fnc_MP; //add action
	
	//Add drawable whiteboard
	_whiteboardObjects = missionNamespace getVariable ["NNS_WhiteboardDraw",[]];
	if (count _whiteboardObjects == 0) then {_whiteboardObjects = [objective7_whiteboard0];
	} else {_whiteboardObjects pushBack objective7_whiteboard0;};
	missionNamespace setVariable ["NNS_WhiteboardDraw",_whiteboardObjects,true];
		
	[BIS_grpMain,["objective7","objEscape"],[localize "STR_NNS_Escape_Objective_Intel_desc",localize "STR_NNS_Escape_Objective_Intel_title",""],getMarkerPos "objective_zone_7","ASSIGNED",1,true,"intel"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_7} do {
			sleep 5;
			if(count(actionIDs objective_7_intel_0) == 0 && {count(actionIDs objective_7_intel_1) == 0} && {count(actionIDs objective_7_intel_2) == 0} && {count(actionIDs objective_7_intel_3) == 0} && {count(actionIDs objective_7_intel_4) == 0}) then {
			//if((BIS_grpMain getVariable "objective_7_intel_0_found") && (BIS_grpMain getVariable "objective_7_intel_1_found") && (BIS_grpMain getVariable "objective_7_intel_2_found") && (BIS_grpMain getVariable "objective_7_intel_3_found") && (BIS_grpMain getVariable "objective_7_intel_4_found")) then {
				task_completed_7 = true;
				["objective7", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};