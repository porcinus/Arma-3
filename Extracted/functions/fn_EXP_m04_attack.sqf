private _count = count ([] call BIS_fnc_listPlayers);

// Determine how many snipers to get rid of
private _delete = 2;

// Remove snipers at random
for "_i" from 1 to _delete do {
	// Choose random sniper
	private _sniper = BIS_snipers call BIS_fnc_selectRandom;

	// Delete units, remove from pool
	private _units = missionNamespace getVariable _sniper;
	{deleteVehicle _x} forEach _units;
	BIS_snipers = BIS_snipers - [_sniper];
};

private _snipers = [];

{
	private _pool = _x;

	// Register chosen attackers
	private _choice = switch (_pool) do {
		case "BIS_sniperA": {"A"};
		case "BIS_sniperB": {"B"};
		case "BIS_sniperC": {"C"};
		case "BIS_sniperD": {"D"};
	};

	BIS_chosenAttacks set [count BIS_chosenAttacks, _choice];

	// Randomly choose sniper unit
	private _units = missionNamespace getVariable _pool;
	private _sniper = _units call BIS_fnc_selectRandom;
	_units = _units - [_sniper];

	// Add to array
	_snipers set [count _snipers, _sniper];

	// Delete others
	{deleteVehicle _x} forEach _units;
} forEach BIS_snipers;

// Store units
BIS_snipers = _snipers;

private _attackers = [];
private _final = BIS_chosenAttacks select ((count BIS_chosenAttacks) - 1);

{
	private _pool = _x;

	private _attack = switch (_pool) do {
		case "BIS_attackA": {"A"};
		case "BIS_attackB": {"B"};
		case "BIS_attackC": {"C"};
		case "BIS_attackD": {"D"};
	};

	private _units = missionNamespace getVariable _pool;

	if (!(_attack in BIS_chosenAttacks)) then {
		// Delete
		BIS_attackers = BIS_attackers - [_pool];
		{deleteVehicle _x} forEach _units;
	} else {
		if (count BIS_chosenAttacks > 1) then {
			if (_attack == _final) then {
				if (_count <= 2) then {
					// Delete
					BIS_attackers = BIS_attackers - [_pool];
					{deleteVehicle _x} forEach _units;
					_units = [];
				} else {
					// Trim
					private _unit = _units call BIS_fnc_selectRandom;
					_units = _units - [_unit];
					deleteVehicle _unit;
				};
			};
		};

		// Add remaining units to array
		_attackers = _attackers + _units;
	};
} forEach BIS_attackers;

// Store in array
BIS_attackers = _attackers;

// Pool units
BIS_SF = (BIS_snipers + BIS_attackers);

{
	// Unhide all units
	[_x, _x getVariable "BIS_alt"] call BIS_fnc_setHeight;
	_x hideObjectGlobal false;
	_x enableSimulationGlobal true;
	_x allowDamage true;

	// Remove silencers if needed
	private _silencer = (primaryWeaponItems _x) select 0;
	if (_silencer != "") then {_x removePrimaryWeaponItem _silencer};
} forEach BIS_SF;

private _badMags = ["30Rnd_65x39_caseless_green", "30Rnd_65x39_caseless_green_mag_Tracer"];

{
	private _unit = _x;

	// Remove everything except .50 cal ammo from snipers
	{_unit removeMagazines _x} forEach _badMags;

	// Add NV scope
	_unit addPrimaryWeaponItem "optic_NVS";
} forEach BIS_snipers;

// Decrease accuracy of attackers
{_x setSkill ["aimingAccuracy", 0.2]} forEach BIS_attackers;

// Choose random position, launch flare
private _pos = [markerPos "BIS_defend", random 50, random 360] call BIS_fnc_relPos;
_pos set [2, 200];
["RED", _pos, (10 + random 5), false] spawn BIS_fnc_EXP_m04_flareCreate;

sleep 1;

// Make surviving camp units flee
{
	if (alive _x) then {
		_x disableAI "AUTOCOMBAT";
		_x setCombatMode "BLUE";
		_x setBehaviour "AWARE";

		private _group = group _x;
		private _wp = _group addWaypoint [[3427.15,6704.06,0], 0];
		_wp setWaypointStatements ["true", "deleteVehicle this"];
		_wp setWaypointSpeed "FULL";
		_wp setWaypointCombatMode "BLUE";
		_wp setWaypointBehaviour "AWARE";
		_wp setWaypointType "MOVE";
		_group setCurrentWaypoint _wp;
	};
} forEach BIS_campUnits;

sleep 3;

// Update tasks
["BIS_capture", "CANCELED"] call BIS_fnc_missionTasks;
"BIS_defend" call BIS_fnc_missionTasks;

sleep 1;

private _dest = markerPos "BIS_defend";
private _time = time + 20;
waitUntil {time >= _time || { {(vehicle _x) distance _dest <= 20} count ([] call BIS_fnc_listPlayers) > 0 }};

// Make first sniper fire
private _sniper = BIS_snipers call BIS_fnc_selectRandom;
[_sniper, true] spawn BIS_fnc_EXP_m04_sniper;

sleep 2;

// Send attackers
{
	switch (_x) do {
		case "A": {[] spawn BIS_fnc_EXP_m04_attackA};
		case "B": {[] spawn BIS_fnc_EXP_m04_attackB};
		case "C": {[] spawn BIS_fnc_EXP_m04_attackC};
		case "D": {[] spawn BIS_fnc_EXP_m04_attackD};
	};
} forEach BIS_chosenAttacks;

// Turn on IR lasers
{_x enableIRLasers true} forEach BIS_SF;

// Track players' gunshots
BIS_trackShots = true;

sleep 1;

// Play music
[["LeadTrack02_F_EXP", 0.3], "BIS_fnc_EXP_m04_playMusic"] call BIS_fnc_MP;

true