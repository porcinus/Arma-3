waitUntil {!isNull (missionNamespace getVariable ["BIS_CP_objective_vehicle1", objNull]) && !isNull (missionNamespace getVariable ["BIS_CP_objective_vehicle2", objNull])};

_null = [] spawn {
	if ({damage _x > 0.5 && !canMove _x} count [BIS_CP_objective_vehicle1, BIS_CP_objective_vehicle2] == 0) then {
		[{(damage BIS_CP_objective_vehicle1 > 0.5 && !canMove BIS_CP_objective_vehicle1) || (damage BIS_CP_objective_vehicle2 > 0.5 && !canMove BIS_CP_objective_vehicle2)}, 1] call BIS_fnc_CPWaitUntil;
		playSound ((selectRandom ["cp_partial_objective_accomplished_1", "cp_partial_objective_accomplished_2", "cp_partial_objective_accomplished_3"]) + BIS_CP_protocolSuffix);
	};
};