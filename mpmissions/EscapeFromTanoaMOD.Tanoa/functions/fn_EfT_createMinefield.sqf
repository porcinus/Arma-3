/*
Spawns minefield, which is revelaed to east and independent units, at a certain location.
Delete all the mines when all players are too far away.

Example: _createMinefield = [[6600,3600,0],250,50,25] spawn BIS_fnc_EfT_createMinefield;
*/

// Params
params
[
	["_pos",[10,10,10],[[],objNull]],	// position
	["_aRadius",250,[999]],			// activation radius
	["_sRadius",50,[999]],			// spawn radius
	["_quantity",10,[999]]			// number of mines
];

// Players close - spawn mines
waitUntil {sleep 2.5; {(_x distance2D _pos) < _aRadius} count allPlayers > 0};

private _mines = [];

for "_i" from 1 to _quantity do {

	_spawnPos = [_pos, random _sRadius, random 360] call BIS_fnc_relPos;

	_mine = createMine [selectRandom ["APERSMine","APERSBoundingMine"], _spawnPos, [], 0];
        if (typeOf _mine == "APERSBoundingMine_Range_Ammo") then {_mine setPosATL [_spawnPos select 0,_spawnPos select 1, -0.1]} else {_mine setPosATL [_spawnPos select 0,_spawnPos select 1, 0]};

	{_x revealMine _mine} forEach [east,resistance];

	_mines pushBack _mine;

	sleep 0.25;

};

// Players far - delete mines
waitUntil {sleep 2.5; {(_x distance2D _pos) < (_aRadius * 3)} count allPlayers == 0};

{deleteVehicle _x} forEach _mines;
