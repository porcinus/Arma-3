params ["_dest", "_dist", "_pos", "_name"];
if (typeName _dest == typeName "") then {_center = markerPos _dest};

waitUntil {
	// Wait for players to approach the location
	{(vehicle _x) distance _dest <= _dist} count allPlayers > 0
	||
	// Defense started
	BIS_atDevice
};

if (!(BIS_atDevice)) then {
	// Add and store respawn
	private _respawn = [WEST, _pos, _name] call BIS_fnc_addRespawnPosition;
	BIS_respawnsApproach = BIS_respawnsApproach + [_respawn];
};

true