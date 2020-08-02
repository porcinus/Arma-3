params ["_drone"];

if (!(_drone isKindOf "Air")) then {
	// Ground drones self destruct
	private _pos = getPosATL _drone;
	_pos set [2, 1];
	private _bomb = createVehicle ["Bo_Mk82", _pos, [], 0, "NONE"];
	_bomb hideObjectGlobal true;
	_bomb setPosATL _pos;
};

// Ensure drone is destroyed
_drone setDamage 1;

true