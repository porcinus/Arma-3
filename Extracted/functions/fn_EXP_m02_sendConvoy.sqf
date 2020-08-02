private _count = count ([] call BIS_fnc_listPlayers);

if (_count < 3) then {
	// Remove one car if necessary
	{
		if (_x isKindOf "Man") then {
			// Remove from array of units
			BIS_convoyUnits = BIS_convoyUnits - [_x];
		} else {
			// Remove from array of vehicles
			BIS_convoyVehicles = BIS_convoyVehicles - [_x];
		};
		
		// Delete the entity
		deleteVehicle _x;
	} forEach (crew BIS_convoyTruck3 + [BIS_convoyTruck3]);
};

// Unhide the convoy
{
	if (!(_x isKindOf "Man")) then {
		// Reposition vehicles
		[_x, _x getVariable "BIS_alt"] call BIS_fnc_setHeight;
	};
	
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;
	_x setCaptive false;
} forEach (BIS_convoyUnits + BIS_convoyVehicles);

// Handle the convoy and task
[] spawn BIS_fnc_EXP_m02_handleConvoy;
[] spawn BIS_fnc_EXP_m02_handleTask;

true