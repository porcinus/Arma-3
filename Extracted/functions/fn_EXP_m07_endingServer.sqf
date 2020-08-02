waitUntil {
	{
		// Player is alive
		alive _x
		&&
		// Player is not incapacitated
		{ lifeState _x != "INCAPACITATED" }
	} count allPlayers > 0
};

// Grab list of players at the time this is executed
addMissionEventHandler ["HandleDisconnect", {if (!(isNil {BIS_fnc_EXP_m07_endingServer_players})) then {BIS_fnc_EXP_m07_endingServer_players = BIS_fnc_EXP_m07_endingServer_players - [_this select 0]}}];
BIS_fnc_EXP_m07_endingServer_players = call BIS_fnc_listPlayers;

// Exclude host from BIS_fnc_MP call
private _clients = +BIS_fnc_EXP_m07_endingServer_players;
if (!(isDedicated)) then {_clients = _clients - [player]};

// Execute ending
[] spawn BIS_fnc_EXP_m07_endingClient;
[[], "BIS_fnc_EXP_m07_endingClient", _clients] call BIS_fnc_MP;

true