private _units = [BIS_attackA1, BIS_attackA2];
{if (isNull _x) then {_units = _units - [_x]}} forEach _units;

{
	private _unit = _x;
	
	// Crouch
	_unit setUnitPos "MIDDLE";
	
	// Improve their knowledge
	_unit spawn {
		scriptName format ["BIS_fnc_EXP_m04_attackA: attacker knowledge - %1", _this];
		
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
	
	private _group = group _unit;
	private _pos = [3339.78,5800.76,0];
	if (_forEachIndex > 0) then {_pos = [3342.87,5802.89,0]};
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

// Wait for units to get into position
waitUntil {{!(_x getVariable ["BIS_ready", false])} count _units == 0};
{if (alive _x) then {_x setVariable ["BIS_ready", false]}} forEach _units;

sleep (5 + random 5);

// Second unit moves first
if (!(isNull BIS_attackA2)) then {
	BIS_attackA2 setBehaviour "AWARE";
	sleep 2;
	private _group = group BIS_attackA2;
	private _pos = [3320.09,5825.66,0];
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
	
	waitUntil {BIS_attackA2 getVariable "BIS_ready"};
	if (alive BIS_attackA2) then {BIS_attackA2 setVariable ["BIS_ready", false]};
	
	sleep (1 + random 2);
};

// First unit joins him
if (!(isNull BIS_attackA1)) then {
	BIS_attackA1 setBehaviour "AWARE";
	sleep 2;
	private _group = group BIS_attackA1;
	private _pos = [3324.43,5833.85,0];
	private _wp = _group addWaypoint [_pos, 0];
	_wp setWaypointPosition [_pos, 0];
	
	_wp setWaypointStatements [
		"true",
		"
			this setUnitPos 'DOWN';
			this setVariable ['BIS_ready', true];
		"
	];
	
	_wp setWaypointType "MOVE";
	_group setCurrentWaypoint _wp;
	
	waitUntil {BIS_attackA1 getVariable "BIS_ready"};
	if (alive BIS_attackA1) then {BIS_attackA1 setVariable ["BIS_ready", false]};
	
	sleep (1 + random 2);
};

// Throw smoke if possible
private _unit = BIS_attackA2;
if (isNull _unit || { !(alive _unit) }) then {_unit = BIS_attackA1};

if (!(isNull _unit)) then {
	_unit addMagazine "SmokeShell";
	_unit forceWeaponFire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
	
	sleep (5 + random 5);
};

// Second unit moves to target area
if (!(isNull BIS_attackA2)) then {
	BIS_attackA2 setBehaviour "AWARE";
	BIS_attackA2 enableAI "AUTOCOMBAT";
	sleep 2;
	private _group = group BIS_attackA2;
	private _pos = [3289.39,5873.82,0];
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
	
	waitUntil {BIS_attackA2 getVariable "BIS_ready"};
	if (alive BIS_attackA2) then {BIS_attackA2 setVariable ["BIS_ready", false]};
	
	sleep 1;
};

// First unit moves to target area
if (!(isNull BIS_attackA1)) then {
	BIS_attackA1 enableAI "AUTOCOMBAT";
	BIS_attackA1 setUnitPos "MIDDLE";
	private _group = group BIS_attackA1;
	private _pos = [3307.62,5881.68,0];
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