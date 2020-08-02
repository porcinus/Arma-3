private _units = [BIS_attackD1, BIS_attackD2];
{if (isNull _x) then {_units = _units - [_x]}} forEach _units;

{
	private _unit = _x;
	
	// Crouch
	_unit setUnitPos "MIDDLE";
	
	// Improve their knowledge
	_unit spawn {
		scriptName format ["BIS_fnc_EXP_m04_attackD: attacker knowledge - %1", _this];
		
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
	
	// Move to first positions
	private _group = group _unit;
	private _pos = [3186.29,5888.34,0];
	if (_forEachIndex > 0) then {_pos = [3182.2,5892.96,0]};
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

// Throw smoke if alive
private _unit = BIS_attackD1;
if (isNull _unit || { !(alive _unit) }) then {_unit = BIS_attackD2};

if (!(isNull _unit)) then {
	_unit addMagazine "SmokeShell";
	_unit forceWeaponFire ["SmokeShellMuzzle", "SmokeShellMuzzle"];
	
	sleep (5 + random 5);
};

// Second unit moves first
if (!(isNull BIS_attackD2)) then {
	BIS_attackD2 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackD2 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackD2;
	private _pos = [3268.25,5880.19,0];
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
	
	waitUntil {BIS_attackD2 getVariable "BIS_ready"};
	if (alive BIS_attackD2) then {BIS_attackD2 setVariable ["BIS_ready", false]};
	
	sleep 1;
};

// Second unit tries to throw a chemlight
private _thrown = false;
if (!(isNull BIS_attackD2) && { alive BIS_attackD2 }) then {
	BIS_attackD2 addMagazine "Chemlight_red";
	BIS_attackD2 forceWeaponFire ["ChemlightRedMuzzle", "ChemlightRedMuzzle"];
	_thrown = true;
	
	sleep (1 + random 2);
};

// First unit moves up to join him
if (!(isNull BIS_attackD1)) then {
	BIS_attackD1 setBehaviour "AWARE";
	sleep 2;
	
	BIS_attackD1 enableAI "AUTOCOMBAT";
	private _group = group BIS_attackD1;
	private _pos = [3262.87,5885.04,0];
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
	
	waitUntil {BIS_attackD1 getVariable "BIS_ready"};
};

// First unit throws the chemlight if necessary
if (!(_thrown)) then {
	if (!(isNull BIS_attackD1) && { alive BIS_attackD1 }) then {
		BIS_attackD1 addMagazine "Chemlight_red";
		BIS_attackD1 forceWeaponFire ["ChemlightRedMuzzle", "ChemlightRedMuzzle"];
	};
};

true