// Disable everything other than dialogues
enableSentences false;

if (!(isDedicated)) then {
	if (alive player) then {
		// Disable & reset damage, move out of incapacitated state
		player setCaptive true;
		player allowDamage false;
		player setDamage 0;
		player setUnconscious false;
	};
};

if (isServer) then {
	// Succeed task
	["BIS_RV", "SUCCEEDED"] call BIS_fnc_missionTasks;

	// Let Miller move, play conversation
	BIS_miller enableSimulationGlobal true;
	"95_Apex" spawn BIS_fnc_missionConversations;
};

// Wait for mission to end
waitUntil {missionNamespace getVariable ["BIS_endMission", false]};

if (!(isDedicated)) then {
	// Fade out
	8 fadeSound 0;
	titleCut ["", "BLACK OUT", 5];
};

sleep 9;

if (isServer) then {
	// End mission
	[["END1", true, 0, false, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
};

true