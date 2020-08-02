/*
Find suitable roofs of Tanoan buildings in given vicinity

Example: _null = [this,150] spawn BIS_fnc_EfT_houseFind;
*/

// Params
params
[
	["_pos",objNull,[objNull]],    	// center position
	["_dist",200,[999]],     	// distance from center in which the function will detect suitable buildings and populate their roofs
	["_act",1250,[999]]     	// activation distance from all players
];

// Check for validity, not necessary
// if (_pos == objNull) exitWith {["POPULATE ROOFS: Invalid center object %1 used!",_pos] call BIS_fnc_logFormat};
// if (_dist < 5) exitWith {["POPULATE ROOFS: Too small radius %1 used!",_dist] call BIS_fnc_logFormat};
// if (_dist > 500) exitWith {["POPULATE ROOFS: Too large radius %1 used!",_dist] call BIS_fnc_logFormat};

// Wait for players to be close and then search for suitable houses
waitUntil {sleep 5; {(_x distance2d _pos) < (_act)} count allPlayers > 0};

// Check for suitable buildings in the radius
private _nearBuildings = [];
private _buildings = [];

_nearBuildings = nearestTerrainObjects [_pos, ["House"], _dist, false, true];

{if (typeOf _x in ["Land_Shop_City_07_F","Land_Shop_City_04_F","Land_Addon_04_F","Land_House_Big_03_F","Land_Hotel_01_F","Land_House_Big_04_F"]) then {_buildings pushBack _x}} forEach _nearBuildings;

// Delete the now useless logic
deleteVehicle _pos;

// Run population function on each suitable house
{_x call BIS_fnc_EfT_housePopulate} forEach _buildings;
