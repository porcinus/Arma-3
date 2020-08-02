params ["_unit"];

// Ensure respawn is enabled
waitUntil {{isNil _x} count ["BIS_respawnEnabled", "BIS_respawnsPlayers"] == 0};
waitUntil {BIS_respawnEnabled};

// Add respawn position on player
private _respawn = [WEST, _unit] call BIS_fnc_addRespawnPosition;
BIS_respawnsPlayers = BIS_respawnsPlayers + [_respawn];

true