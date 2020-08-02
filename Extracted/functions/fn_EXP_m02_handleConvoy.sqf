private _entities = BIS_convoyVehicles + BIS_convoyUnits;

{
	// Detect if players damage enemy vehicles
	private _damageEH = _x addEventHandler [
		"HandleDamage",
		{
			private _unit = _this select 0;
			private _damage = _this select 2;
			private _source = _this select 3;

			if (isPlayer _source || { _source in BIS_supportUnits }) then {
				// Remove event handler
				private _damageEH = _unit getVariable "BIS_damageEH";

				if (!(isNil "_damageEH")) then {
					_unit removeEventHandler ["HandleDamage", _damageEH];
					_unit setVariable ["BIS_damageEH", nil];
				};

				// Register that the unit was damaged
				_unit setVariable ["BIS_damaged", true];
			};

			// Apply damage as usual
			_damage
		}
	];

	// Store event handler
	_x setVariable ["BIS_damageEH", _damageEH];
} forEach _entities;

[] spawn {
	scriptName "BIS_fnc_EXP_m02_handleConvoy: behavior control";

	while {!(BIS_ambushed)} do {
		waitUntil {
			// Convoy is ambushed
			BIS_ambushed
			||
			{
				private _players = allPlayers;

				(
					// Players are too close
					{(vehicle _x) distance BIS_convoyTruck1 <= 100} count _players > 0
					&&
					{
						// Convoy units know about players
						{
							private _unit = _x;
							{_unit knowsAbout _x >= 1.5} count _players > 0
						} count BIS_convoyUnits > 0
					}
				)
			}
		};

		if (!(BIS_ambushed)) then {
			// Switch convoy from careless to safe
			{_x setBehaviour "SAFE"} forEach BIS_convoyUnits;

			waitUntil {
				// Convoy is ambushed
				BIS_ambushed
				||
				// Players are far away
				{ {(vehicle _x) distance BIS_convoyTruck1 <= 100} count allPlayers == 0 }
			};

			if (!(BIS_ambushed)) then {
				// Switch convoy back to careless
				{_x setBehaviour "CARELESS"} forEach BIS_convoyUnits;
			};
		};
	};
};

waitUntil {
	{
		// Convoy was alerted
		behaviour _x == "COMBAT"
		||
		// Convoy was damaged
		_x getVariable ["BIS_damaged", false]
	} count _entities > 0
};

// Register that the convoy was ambushed
BIS_ambushed = true;

true