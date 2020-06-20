if !(["objective10"] call BIS_fnc_taskExists) then {
	task_completed_10 = false;
	
	_markerListHide = missionNamespace getVariable ["markerListHide",[]]; //checkpoint marker list
	
	_hostageBarnlist = [[5353,3692,0],[5771,3597,0],[6659,2713,0],[6833,2715,0]]; //barns around intel position
	_hostageBarn = selectRandom _hostageBarnlist; //select random barn
	
	_objects = [objective_10_intel_0, objective_10_intel_1, objective_10_intel_2, objective_10_intel_3, objective_10_intel_4];
	
	for "_i" from 0 to 3 do { //select 4 random object and 4 random marker to reveal
		_rndObject = _objects call BIS_fnc_selectRandom; //select random object
		_rndMarker = _markerListHide call BIS_fnc_selectRandom; //select random marker
		[_rndObject, [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["markeralpha",_rndMarker,1]]] remoteExec ["addAction", 0, true]; //add action
		_objects deleteAt (_objects find _rndObject); //remove from object array
		_markerListHide deleteAt (_markerListHide find _rndMarker); //remove from marker array
	};
	
	//Rescue CSAT squat, lead to CSAT sniper if success
	[(_objects select 0), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","scripts\RescueCSATsquad.sqf",[_hostageBarn,["rescueCSATsquad1","objEscape"],BIS_grpMain,["meetCSATsniper1","objEscape"]]]]] remoteExec ["addAction", 0, true]; //add action
	
	//[[(_objects select 0), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","TMP.sqf",["bla1","bla2","bla3","bla4"]]]], "addAction", true, true] call BIS_fnc_MP; //add action
	//[[(_objects select 1), [localize "STR_NNS_Escape_CollectIntel_name", "scripts\Intel.sqf", ["execvm","TMP.sqf",["bla1","bla2","bla3","bla4"],true]]], "addAction", true, true] call BIS_fnc_MP; //add action
	
	//Add drawable whiteboard
	_whiteboardObjects = missionNamespace getVariable ["NNS_WhiteboardDraw",[]];
	if (count _whiteboardObjects == 0) then {_whiteboardObjects = [objective10_whiteboard0];
	} else {_whiteboardObjects pushBack objective10_whiteboard0;};
	missionNamespace setVariable ["NNS_WhiteboardDraw",_whiteboardObjects,true];
	
	[BIS_grpMain,["objective10","objEscape"],[localize "STR_NNS_Escape_Objective_Intel_desc",localize "STR_NNS_Escape_Objective_Intel_title",""],getMarkerPos "objective_zone_10","ASSIGNED",1,true,"intel"] call BIS_fnc_taskCreate;

	[] spawn {
		while {!task_completed_10} do {
			sleep 5;
			if(count(actionIDs objective_10_intel_0) == 0 && {count(actionIDs objective_10_intel_1) == 0} && {count(actionIDs objective_10_intel_2) == 0} && {count(actionIDs objective_10_intel_3) == 0} && {count(actionIDs objective_10_intel_4) == 0}) then {
				task_completed_10 = true;
				["objective10", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			};
		};
	};
};