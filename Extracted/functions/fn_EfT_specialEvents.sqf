/*
*** Special events for Escape from Tanoa - types and frequency
- mortar fire on randomly selected team member
- cluster shell on randomly selected team member
- Taru bench with squad FFV
- CAS with Orca or VTOL
*/

// Params
params
[
	["_delayMin",10,[999]], // min delay in minutes
	["_delayMax",15,[999]] // max delay in minutes
];

private _delayFinal = (((random (_delayMax - _delayMin)) + _delayMin) * 60);
private _event = selectRandom BIS_EfT_events;

// Remove the selected event from array so it's not repeated. If all events happened, restart it.
BIS_EfT_events = BIS_EfT_events - [_event];
if (count BIS_EfT_events == 0) then {BIS_EfT_events = ["Mortar",/*"Cluster",*/"TaruBench","Orca","VTOL"]};

// Trigger next event
sleep _delayFinal;
_null = [_delayMin,_delayMax] spawn BIS_fnc_EfT_specialEvents;

// MORTAR
if (_event == "Mortar") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	"DistantMortar" remoteExec ["playSound"];
	sleep 2;
	"DistantMortar" remoteExec ["playSound"];
	sleep 2;
	"DistantMortar" remoteExec ["playSound"];
	sleep 2;
	"DistantMortar" remoteExec ["playSound"];
	sleep 2;
	"DistantMortar" remoteExec ["playSound"];
	sleep 2;
	"DistantMortar" remoteExec ["playSound"];

	sleep 15;
	_target = selectRandom allPlayers;
	_null = [_target,"Sh_82mm_AMOS",200,18,2,nil,nil,nil,nil,["mortar1","mortar2"]] spawn BIS_fnc_fireSupportVirtual;

};

// CLUSTER - not used anymore (Orange has better clusters anyway)
if (_event == "Cluster") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	"DistantHowitzer" remoteExec ["playSound"];
	sleep 5;
	"DistantHowitzer" remoteExec ["playSound"];

	sleep 15;
	_target = selectRandom allPlayers;
	_null = [_target,nil,nil,[2,10],5] spawn BIS_fnc_fireSupportCluster;

};

// PARADROP - not used, parachuters are getting killed by their own parachutes or when they land in the forest
if (_event == "Paradrop") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0), (_targetPos select 1) + 500, 150];

	// Create heli and WPs
	_heli = createVehicle [selectRandom ["O_T_VTOL_02_infantry_F","O_Heli_Transport_04_covered_F","O_Heli_Light_02_unarmed_F"], [0,0,150], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);

	// _heli = [[0,0,0], 0, selectRandom ["O_T_VTOL_02_infantry_F","O_Heli_Transport_04_covered_F","O_Heli_Light_02_unarmed_F"], EAST] call BIS_fnc_spawnVehicle;

	_heli setPosATL [(_targetPos select 0),(_targetPos select 1) - 1250, 150];
	_heli flyInHeight 150;
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "Blue";
	{_x disableAI "FSM"; _x disableAI "Target", _x disableAI "Autotarget"} forEach _heliCrew;

	_wpHeli01 = _heliGroup addWaypoint [_wpPos, 0];
	_wpHeli02 = _heliGroup addWaypoint [[100,100,150], 0];

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn
	{
		waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// If the heli is Taru, apply black camo for Tanoa
	if (typeOf _heli == "O_Heli_Transport_04_covered_F") then {[_heli,["Black",1]] call BIS_fnc_initVehicle};

	// Paradrop
	waitUntil {sleep 1; (_heli distance2D _targetPos) < 300};

	_null = _heli execVM "Scripts\Paratroopers.sqf";

	// Delete heli when far away
	waitUntil {sleep 5; (_heli distance2D _targetPos) > 3000};

	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup _heliGroup;

};

// TARU BENCH
if (_event == "TaruBench") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0), (_targetPos select 1) + 500, 250];

	// Create heli and WPs
	// _heli = [[0,0,0], 0, "O_Heli_Transport_04_bench_F", EAST] call BIS_fnc_spawnVehicle;

	_heli = createVehicle ["O_Heli_Transport_04_bench_F", [0,0,150], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);

	_heli setPosATL [(_targetPos select 0),(_targetPos select 1) - 1250, 75];
	_heli flyInHeight 75;
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "Blue";
	_heliGroup allowFleeing 0;
	[_heli,["Black",1]] call BIS_fnc_initVehicle;
	_wpHeli01 = _heliGroup addWaypoint [_targetPos, 0];
	_wpHeli02 = _heliGroup addWaypoint [_targetPos, 500];
	_wpHeli02 setWaypointType "SaD";
	_wpHeli03 = _heliGroup addWaypoint [_targetPos, 500];
	_wpHeli03 setWaypointType "SaD";
        _wpHeli04 = _heliGroup addWaypoint [_targetPos, 0];
	_wpHeli04 setWaypointType "Cycle";

	sleep 1;

	// Create team onboard
	_grp = grpNull;
	_grp = [[0,0,0], EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.3, 0.3]] call BIS_fnc_spawnGroup;

	{_x moveInCargo _heli} forEach (units _grp);
	if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)};

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if the onboard team has losses or the heli is damaged or low on fuel
	_null = [_heliGroup, _grp, _heli] spawn
	{
		waitUntil {sleep 1; ({alive _x} count (units (_this select 1)) < 4) or (damage (_this select 2) > 0.35) or (fuel (_this select 2) < 0.75)};

		_escGroup = createGroup east;
		_unit01 = _escGroup createUnit ["O_T_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		deleteGroup _escGroup;
	};

	// Reveal players to gunners
	{(leader _grp) reveal [_x,4]} forEach allPlayers;

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _heli) < (3000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_heliCrew + [_heli] + (units _grp));
	deleteGroup (_heliGroup);

};

// CAS - Orca
if (_event == "ORCA") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	// Create Orca (B&W)
	// _cas = [[0,0,0], 0, "O_Heli_Light_02_v2_F", EAST] call BIS_fnc_spawnVehicle;

	_cas = createVehicle ["O_Heli_Light_02_v2_F", [0,0,75], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);

	_cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 1500, 75];
	_cas flyInHeight 75;
/*
	_wpCAS01 = (_cas select 2) addWaypoint [[(_targetPos select 0), (_targetPos select 1) - 500, 75], 0];
	_wpCAS02 = (_cas select 2) addWaypoint [[(_targetPos select 0) + 500, (_targetPos select 1), 75], 0];
	_wpCAS03 = (_cas select 2) addWaypoint [[(_targetPos select 0), (_targetPos select 1) + 500, 75], 0];
	_wpCAS04 = (_cas select 2) addWaypoint [[(_targetPos select 0) - 500, (_targetPos select 1), 75], 0];
	_wpCAS05 = (_cas select 2) addWaypoint [[(_targetPos select 0), (_targetPos select 1) - 500, 75], 0];
	_wpCAS05 setWaypointType "Cycle";
*/

	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 500];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 500];
	_wpCAS03 setWaypointType "SaD";
        _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";

	// Reveal players to pilot
	{(driver _cas) reveal [_x,4]} forEach allPlayers;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_casGroup,_cas] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup east;
		_unit01 = _escGroup createUnit ["O_T_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _cas) < (3000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
};

// CAS - VTOL
if (_event == "VTOL") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	// Create VTOL
	// _cas = [[0,0,0], 0, "O_T_VTOL_02_infantry_F", EAST] call BIS_fnc_spawnVehicle;

	_cas = createVehicle ["O_T_VTOL_02_infantry_F", [0,0,125], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);

	_cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 1750, 125];
	_cas flyInHeight 125;
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS01 setWaypointType "Guard";

	// Limit speed
	_cas forceSpeed 100;

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_casGroup, _cas] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup east;
		_unit01 = _escGroup createUnit ["O_T_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _cas) < (3000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
};

// JET - not effective in jungle terrain, do not use
if (_event == "Jet") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	// Create Jet and WPs
	// _jet = [[0,0,0], 0, "O_Plane_CAS_02_F", EAST] call BIS_fnc_spawnVehicle;

	_jet = createVehicle ["O_Plane_CAS_02_F", [0,0,150], [], 0, "FLY"];
	createVehicleCrew _jet;
	_jetCrew = crew _jet;
	_jetGroup = group (_jetCrew select 0);

	_jet setPosATL [(_targetPos select 0),(_targetPos select 1) - 2500, 150];
	_jet flyInHeight 150;
	_wpJet = _jetGroup addWaypoint [_targetPos, 0];
	_wpJet setWaypointType "SaD";
	{_jet removeMagazine _x} forEach ["2Rnd_Missile_AA_03_F","4Rnd_Missile_AGM_01_F"];
	_jet forceSpeed 125;
	_jet action ["engineOn", (_jet select 0)];
	_jet flyInHeight 150;
	_jet setVelocity [0,100,0];

	// Retreat if damaged or after timeout
	_null = [_jetGroup, _jet] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup east;
		_unit01 = _escGroup createUnit ["O_T_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _jet) < (6000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_jetCrew) + [_jet select 0];
	deleteGroup _jetGroup;
};

// UGV DROP - cannot be dropped just anywhere = do not use
if (_event == "UGVDrop") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0), (_targetPos select 1) + 200, 150];

	// Create heli and WPs
	// _heli = [[0,0,0], 0, "O_T_VTOL_02_vehicle_F", EAST] call BIS_fnc_spawnVehicle;

	_heli = createVehicle ["O_T_VTOL_02_vehicle_F", [0,0,100], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);

	_heli setPosATL [(_targetPos select 0),(_targetPos select 1) - 1500, 100];
	_heli flyInHeight 100;
	_heli setVelocity [0,75,0];
	_heli forceSpeed 75;
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "Blue";
	{_x disableAI "FSM"; _x disableAI "Target", _x disableAI "Autotarget"} forEach _heliCrew;

	_wpHeli01 = _heliGroup addWaypoint [_wpPos, 0];
	_wpHeli02 = _heliGroup addWaypoint [[100,100,150], 0];

	sleep 1;

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Create UGV
	_ugv = [[10,10,10], 0, "O_T_UGV_01_rcws_ghex_F", EAST] call BIS_fnc_spawnVehicle;
	(_ugv select 2) setCombatMode "Blue";

	sleep 0.1;

	_heli setVehicleCargo (_ugv select 0);

	sleep 2.5;

	// Let him fire after he lands
	_null = [(_ugv select 0),(_ugv select 2)] spawn {
	waitUntil {sleep 1; isTouchingGround (_this select 0)};
	(_this select 1) setCombatMode "Red";
	};

	// Paradrop
	_null = [_heli,(_ugv select 2),_targetPos] spawn {
	waitUntil {sleep 1; ((_this select 0) distance2D (_this select 2)) < 300};

	(_this select 0) setVehicleCargo objNull;
	_stalk = [(_this select 1),group (allPlayers select 0)] spawn BIS_fnc_stalk;

	};

	// Delete heli when far away
	waitUntil {sleep 5; _heli distance2D _targetPos > 2500};
	{deleteVehicle _x} forEach (_heliCrew) + [_heli];
	deleteGroup _heliGroup;
};
