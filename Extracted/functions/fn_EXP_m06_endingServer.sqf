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

// Add respawn position
private _respawn = [
	WEST,
	markerPos "BIS_viperRespawn",
	localize "STR_A3_EXP_m06_RP_ViperBase"	
] call BIS_fnc_addRespawnPosition;

BIS_respawns = BIS_respawns + [_respawn];

// Ensure all players are close enough
[
	nil,
	{(vehicle _player) distance BIS_miller <= 10},
	{BIS_startEnding = true}
] spawn BIS_fnc_EXP_camp_playerChecklist;

waitUntil {BIS_startEnding};

// Build list of players
BIS_fnc_EXP_m06_endingServer_players = call BIS_fnc_listPlayers;

// Exclude host from BIS_fnc_MP call
private _clients = +BIS_fnc_EXP_m06_endingServer_players;
if (!(isDedicated)) then {_clients = _clients - [player]};

// Execute ending
[] spawn BIS_fnc_EXP_m06_endingClient;
[[], "BIS_fnc_EXP_m06_endingClient", _clients] call BIS_fnc_MP;

true