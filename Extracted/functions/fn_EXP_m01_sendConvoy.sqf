// Unhide units
["BIS_convoy", 1] call BIS_fnc_EXP_m01_hideUnits;

// Move into vehicles
{
	if (isNull (driver BIS_convoyTruck1)) then {
		// Lead driver
		_x assignAsDriver BIS_convoyTruck1;
		_x moveInDriver BIS_convoyTruck1;
	} else {
		if (isNull (driver BIS_convoyTruck2)) then {
			// Second driver
			_x assignAsDriver BIS_convoyTruck2;
			_x moveInDriver BIS_convoyTruck2;
		} else {
			if ((BIS_convoyTruck1 emptyPositions "Cargo") > 0) then {
				// Lead cargo
				_x assignAsCargo BIS_convoyTruck1;
				_x moveInCargo BIS_convoyTruck1;
			} else {
				// Second cargo
				_x assignAsCargo BIS_convoyTruck2;
				_x moveInCargo BIS_convoyTruck2
			};
		};
	};
} forEach units BIS_convoyGroup;

true