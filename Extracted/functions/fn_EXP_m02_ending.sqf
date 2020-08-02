if (isServer) then {
	// Disable respawn, remove positions
	BIS_respawnEnabled = false;
	{_x call BIS_fnc_removeRespawnPosition} forEach BIS_respawns;

	// Lock the helicopter
	BIS_heli1 lock true;

	// Register that everyone's on board
	BIS_extracted = true;
	publicVariable "BIS_extracted";

	// Succeed the task
	["BIS_exfil", "SUCCEEDED"] call BIS_fnc_missionTasks;

	// Make the helicopter fly away
	BIS_heli1 flyInHeight 30;

	private _group = group driver BIS_heli1;
	private _wp1 = _group addWaypoint [markerPos "BIS_heliWP1", 0];
	_wp1 setWaypointSpeed "LIMITED";
	_wp1 setWaypointType "MOVE";
	_group setCurrentWaypoint _wp1;

	private _wp2 = _group addWaypoint [markerPos "BIS_heliWP2", 0];
	_wp2 setWaypointType "MOVE";
};

sleep 4;

// UAV targeting
if (isServer) then {
	"115_UAV_Targeting" spawn BIS_fnc_missionConversations;
};


sleep 8;

// UAV fired
if (isServer) then {
	"120_UAV_Fired" spawn BIS_fnc_missionConversations;
};

sleep 7;

if (isServer) then {
	// Spawn explosion
	private _pos = markerPos "BIS_AA";
	_pos set [2, 1];
	private _bomb = createVehicle ["Bo_GBU12_LGB", _pos, [], 0, "NONE"];
	_bomb setVelocity [0,0,-1];
};

sleep 3;

// Target destroyed
if (isServer) then {
	"125_Weapons_Destroyed" spawn BIS_fnc_missionConversations;
};

sleep 8;

// Fade sound
8 fadeSound 0;
titleCut ["", "BLACK OUT", 5];

sleep 9;

if (isServer) then {
	// End the mission
	[["END1", true, 0, false, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
};

true