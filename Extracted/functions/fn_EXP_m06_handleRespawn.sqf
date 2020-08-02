params ["_dest", "_dist", "_marker", "_name", "_var"];
_dest = markerPos _dest;

waitUntil {
	// Variable was triggered
	missionNamespace getVariable [_var, false]
	||
	// Players are close enough
	{(vehicle _x) distance _dest <= _dist} count allPlayers > 0
};

// Add respawn
private _respawn = [
	WEST,
	markerPos _marker,
	_name
] call BIS_fnc_addRespawnPosition;

BIS_respawns = BIS_respawns + [_respawn];

true