params ["_heli"];

if (alive player) then {
	// Separate player from others to prevent giving disembark orders
	[player] joinSilent (createGroup WEST);
	player setGroupID [localize "STR_A3_EXP_m04_Raider2"];
	
	// Find correct seat for player
	private _index = switch (player call BIS_fnc_objectVar) do {
		case "BIS_player1": {2};
		case "BIS_player2": {3};
		case "BIS_player3": {4};
		case "BIS_player4": {5};
	};
	
	// Ensure player isn't in a vehicle
	private _pos = getPosATL (vehicle player);
	_pos set [2, 50];
	player setPos _pos;
	
	waitUntil {vehicle player == player || !(alive player)};
	
	if (alive player) then {
		// Move player into helicopter
		player assignAsCargoIndex [_heli, _index];
		player moveInCargo [_heli, _index];
	};
};

true