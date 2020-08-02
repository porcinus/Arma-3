private _units = [BIS_attackB1, BIS_attackB2];
{if (isNull _x) then {_units = _units - [_x]}} forEach _units;

{
	private _unit = _x;
	
	// Crouch
	_unit setUnitPos "MIDDLE";
	
	// Improve their knowledge
	_unit spawn {
		scriptName format ["BIS_fnc_EXP_m04_attackB: attacker knowledge - %1", _this];
		
		while {alive _this} do {
			// Ensure they're at least looking at the fake target
			_this reveal BIS_attackTarget;
			_this doTarget BIS_attackTarget;
			
			// Give them full knowledge of the players
			{_this reveal _x} forEach ([] call BIS_fnc_listPlayers);
			
			sleep 1;
		};
	};
	
	// Handle if they die
	_unit addEventHandler ["Killed", {(_this select 0) setVariable ["BIS_ready", true]}];
	
	// Move to their first locations
	private _group = group _unit;
	private _pos = [3439.12,5914.46,0];
	if (_forEachIndex > 0) then {_pos = [3427.99,5909.75,0]};
	private _wp = _group addWaypoint [_pos, 0];
	_wp setWaypointPosition [_pos, 0];
	
	_wp setWaypointStatements [
		"true",
		"
			this setBehaviour 'COMBAT';
			this setVariable ['BIS_ready', true];
		"
	];
	
	_wp setWaypointType "MOVE";
	_group setCurrentWaypoint _wp;
} forEach _units;

waitUntil {{!(_x getVariable ["BIS_ready", false])} count _units == 0};
{if (alive _x) then {_x setVariable ["BIS_ready", false]}} forEach _units;

sleep (2 + random 2);

// Throw smoke
private _unit = BIS_attackB2;
if (isNull _unit || { !(alive _unit) }) then {_unit = BIS_attackB1};

if (!(isNull _unit)) then {
	_unit addMagazine "SmokeShell";
	_unit forceWeaponFire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
	
	sleep (5 + random 5);
};

// First unit moves up
if (!(isNull BIS_attackB1)) then {
	BIS_attackB1 setBehaviour "AWARE";
	sleep 2;
	
	private _group = group BIS_attackB1;
	private _pos = [3371.21,5903.72,0];
	private _wp = _group addWaypoint [_pos, 0];
	_wp setWaypointPosition [_pos, 0];
	
	_wp setWaypointStatements [
		"true",
		"
			this setBehaviour 'COMBAT';
			this setVariable ['BIS_ready', true];
		"
	];
	
	_wp setWaypointType "MOVE";
	_group setCurrentWaypoint _wp;
	
	waitUntil {BIS_attackB1 getVariable "BIS_ready"};
	if (alive BIS_attackB1) then {BIS_attackB1 setVariable ["BIS_ready", false]};
	
	sleep 1;
};

if (!(isNull BIS_attackB1) && { alive BIS_attackB1 }) then {
	// Throw chemlight if alive
	BIS_attackB1 addMagazine "Chemlight_red";
	BIS_attackB1 forceWeaponFire ["ChemlightRedMuzzle", "ChemlightRedMuzzle"];
	
	sleep (1 + random 2);
};

// Second unit moves up
if (!(isNull BIS_attackB2)) then {
	BIS_attackB2 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackB2 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackB2;
	
	for "_i" from 1 to 2 do {
		private _pos = [3352.07,5902.6,0];
		if (_i > 1) then {_pos = [3297.63,5905.34,0]};
		
		private _wp = _group addWaypoint [_pos, 0];
		_wp setWaypointPosition [_pos, 0];
		
		if (_i > 1) then {
			_wp setWaypointStatements [
				"true",
				"
					this setBehaviour 'COMBAT';
					this setVariable ['BIS_ready', true];
				"
			];
		};
		
		_wp setWaypointType "MOVE";
		if (_i == 1) then {_group setCurrentWaypoint _wp};
	};
	
	waitUntil {BIS_attackB2 getVariable "BIS_ready"};
};

// First unit joins him
if (!(isNull BIS_attackB1)) then {
	BIS_attackB1 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackB1 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackB1;
	private _pos = [3305.18,5894.05,0];
	private _wp = _group addWaypoint [_pos, 0];
	_wp setWaypointPosition [_pos, 0];
	
	_wp setWaypointStatements [
		"true",
		"
			this setBehaviour 'COMBAT';
			this setVariable ['BIS_ready', true];
		"
	];
	
	_wp setWaypointType "MOVE";
	_group setCurrentWaypoint _wp;
};

true