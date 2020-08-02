private _units = [BIS_attackC1, BIS_attackC2];
{if (isNull _x) then {_units = _units - [_x]}} forEach _units;

{
	private _unit = _x;
	
	// Crouch
	_unit setUnitPos "MIDDLE";
	
	// Improve their knowledge
	_unit spawn {
		scriptName format ["BIS_fnc_EXP_m04_attackC: attacker knowledge - %1", _this];
		
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
	private _pos = [3155.7,6039.74,0];
	if (_forEachIndex > 0) then {_pos = [3154.5,6026.76,0]};
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

// First unit moves up
private _thrown = false;

if (!(isNull BIS_attackC1)) then {
	BIS_attackC1 setBehaviour "AWARE";
	sleep 2;
	
	private _group = group BIS_attackC1;
	private _pos = [3193.75,6015.36,0];
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
	
	waitUntil {BIS_attackC1 getVariable "BIS_ready"};
	if (alive BIS_attackC1) then {BIS_attackC1 setVariable ["BIS_ready", false]};
	
	sleep (1 + random 2);
	
	// Throws smoke if alive
	if (alive BIS_attackC1) then {
		BIS_attackC1 addMagazine "SmokeShell";
		BIS_attackC1 forceWeaponFire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
		_thrown = true;
		
		sleep (5 + random 5);
	};
};

// Second unit moves up
if (!(isNull BIS_attackC2)) then {
	BIS_attackC2 setBehaviour "AWARE";
	sleep 2;
	
	private _group = group BIS_attackC2;
	private _pos = [3204.54,5979.92,0];
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
	
	waitUntil {BIS_attackC2 getVariable "BIS_ready"};
	if (alive BIS_attackC2) then {BIS_attackC2 setVariable ["BIS_ready", false]};
	
	sleep (1 + random 2);
	
	// Throw smoke if it wasn't thrown already
	if (!(_thrown) && { alive BIS_attackC2 }) then {
		BIS_attackC2 addMagazine "SmokeShell";
		BIS_attackC2 forceWeaponFire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
		
		sleep (5 + random 5);
	};
};

// First unit moves again
if (!(isNull BIS_attackC1)) then {
	BIS_attackC1 setBehaviour "AWARE";
	sleep 2;
	
	private _group = group BIS_attackC1;
	private _pos = [3239.98,5958.79,0];
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
	
	waitUntil {BIS_attackC1 getVariable "BIS_ready"};
	if (alive BIS_attackC1) then {BIS_attackC1 setVariable ["BIS_ready", false]};
	
	sleep (2 + random 2);
};

// Second unit moves to target area
if (!(isNull BIS_attackC2)) then {
	BIS_attackC2 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackC2 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackC2;
	private _pos = [3253.9,5920.05,0];
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
	
	waitUntil {BIS_attackC2 getVariable "BIS_ready"};
	if (alive BIS_attackC2) then {BIS_attackC2 setVariable ["BIS_ready", false]};
	
	sleep (2 + random 2);
};

// First unit joins him
if (!(isNull BIS_attackC1)) then {
	BIS_attackC1 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackC1 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackC1;
	private _pos = [3269.47,5912.94,0];
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
	
	waitUntil {BIS_attackC1 getVariable "BIS_ready"};
	if (alive BIS_attackC1) then {BIS_attackC1 setVariable ["BIS_ready", false]};
};

// Throw chemlight if possible
private _unit = BIS_attackC2;
if (isNull _unit || { !(alive _unit) }) then {_unit = BIS_attackC1};

if (!(isNull _unit)) then {
	_unit addMagazine "Chemlight_red";
	_unit forceWeaponFire ["ChemlightRedMuzzle", "ChemlightRedMuzzle"];
};

true