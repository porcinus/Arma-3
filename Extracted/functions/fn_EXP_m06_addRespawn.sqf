params ["_unit"];

// Ensure respawn is enabled
waitUntil {{isNil _x} count ["BIS_respawnEnabled", "BIS_respawns"] == 0};
waitUntil {BIS_respawnEnabled};

// Add respawn position
private _respawn = [WEST, _unit] call BIS_fnc_addRespawnPosition;
BIS_respawns = BIS_respawns + [_respawn];

true