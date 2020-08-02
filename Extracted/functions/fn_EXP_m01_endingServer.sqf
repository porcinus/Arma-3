sleep 5;

// Add Tickets
1 call BIS_fnc_EXP_camp_addTickets;

// Play conversation
"b01_Move_In_A" call BIS_fnc_missionConversations;

sleep 1;

waitUntil {
	{
		// Player is in the trigger
		(vehicle _x) in (list BIS_endingTrig)
		&&
		{
			// Player is alive
			alive _x
			&&
			// Player is not incapacitated
			{ lifeState _x != "INCAPACITATED" }
		}
	} count allPlayers > 0
};

// Play conversation
"b01_Move_In_B" spawn BIS_fnc_missionConversations;

// Succeed task
["BIS_final", "SUCCEEDED"] call BIS_fnc_missionTasks;

// Reveal marker
"BIS_final" setMarkerAlpha 1;

// Disable respawns
BIS_respawnEnabled = false;
{_x call BIS_fnc_removeRespawnPosition} forEach BIS_respawns;

// Build list of players
addMissionEventHandler ["HandleDisconnect", {if (!(isNil {BIS_fnc_EXP_m01_endingServer_players})) then {BIS_fnc_EXP_m01_endingServer_players = BIS_fnc_EXP_m01_endingServer_players - [_this select 0]}}];
BIS_fnc_EXP_m01_endingServer_players = call BIS_fnc_listPlayers;

// Exclude host from BIS_fnc_MP call
private _clients = +BIS_fnc_EXP_m01_endingServer_players;
if (!(isDedicated)) then {_clients = _clients - [player]};

// Execute ending
[] spawn BIS_fnc_EXP_m01_endingClient;
[[], "BIS_fnc_EXP_m01_endingClient", _clients] call BIS_fnc_MP;

true