// Wait for the convoy to be spotted
waitUntil {BIS_convoySpotted};

// Grab the convoy units
private _units = +BIS_convoyUnits;

while {count _units > 0} do {
	// Remove dead units
	{if (!(alive _x)) then {_units = _units - [_x]}} forEach _units;
	
	if (count _units > 0) then {
		// Select the first alive unit it finds
		private _unit = objNull;
		{if (alive _x) exitWith {_unit = _x}} forEach _units;
		
		if (isNull _unit) then {
			// Ensure the loop terminates
			_units = [];
		} else {
			// Set the task destination
			["BIS_ambush", [vehicle _unit, true]] call BIS_fnc_taskSetDestination;
			
			// Wait for the unit to be killed
			waitUntil {!(alive _unit)};
		};
	};
};

// Move task back to the original location
["BIS_ambush", markerPos "BIS_ambush"] call BIS_fnc_taskSetDestination;

true