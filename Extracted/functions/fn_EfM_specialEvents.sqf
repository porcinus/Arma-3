/*
*** Special events for Escape from Tanoa - types and frequency
- mortar fire on randomly selected team member
- Pawnees
- Wipeout
- Blackfish gunship
*/

// Params
params
[
	["_delayMin",10,[999]], // min delay in minutes
	["_delayMax",15,[999]] // max delay in minutes
];

private _delayFinal = (((random (_delayMax - _delayMin)) + _delayMin) * 60);
private _event = selectRandom BIS_EfM_events;

// Remove the selected event from array so it's not repeated. If all events happened, restart it.
BIS_EfM_events = BIS_EfM_events - [_event];
if (count BIS_EfM_events == 0) then {BIS_EfM_events = ["Mortar","Blackfish","Pawnee","A10"]};

// Trigger next event
sleep _delayFinal;
_null = [_delayMin,_delayMax] spawn BIS_fnc_EfM_specialEvents;

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

// CLUSTER - not used (Orange has better clusters anyway)
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

// PARADROP
if (_event == "Paradrop") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0) + 500, (_targetPos select 1) + 500, 100];

	// Create heli and WPs
	_heli = createVehicle ["B_T_VTOL_01_infantry_F", [(_targetPos select 0) + 500,(_targetPos select 1) - 2000, 100], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);
	_heli animateDoor ["Door_1_source",1,false];

	_heli flyInHeight 100;
	_heli forceSpeed 50;
	_heliGroup setBehaviour "Careless";
	_heliGroup setCombatMode "Blue";
	{_x disableAI "FSM"; _x disableAI "Target", _x disableAI "Autotarget"} forEach _heliCrew;

	_wpHeli01 = _heliGroup addWaypoint [_wpPos, 0];
	_wpHeli02 = _heliGroup addWaypoint [[100,100,150], 0];

	// Naval camo
	[_heli,["Blue",1],true] call BIS_fnc_initVehicle;

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn
	{
		waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Paradrop
	waitUntil {sleep 1; (_heli distance2D _targetPos) < 400};

	_null = _heli execVM "Scripts\Paratroopers.sqf";

	// Delete heli when far away
	waitUntil {sleep 5; (_heli distance2D _targetPos) > 4000};

	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup _heliGroup;

};

// BLACKFISH GUNSHIP
if (_event == "Blackfish") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;
	_wpPos = [(_targetPos select 0), (_targetPos select 1) + 500, 250];

	_heli = createVehicle ["B_T_VTOL_01_armed_F", [0,0,500], [], 0, "FLY"];
	createVehicleCrew _heli;
	_heliCrew = crew _heli;
	_heliGroup = group (_heliCrew select 0);

	_heli setPosATL [(_targetPos select 0),(_targetPos select 1) - 2000, 500];
	_heli flyInHeight 500;
	_heliGroup allowFleeing 0;
	_wpHeli01 = _heliGroup addWaypoint [_targetPos, 0];
	_wpHeli01 setWaypointType "Loiter";
	_wpHeli01 setWaypointLoiterType "CIRCLE_L";

	sleep 1;

	// Reveal all players
	{(driver _heli) reveal [_x,4]} forEach (allPlayers);

	// If the heli is disabled, kill the crew
	_null = [_heli,_heliCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Retreat if damaged or after timeout
	_null = [_heliGroup,_heli] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _heli) < (5000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_heliCrew + [_heli]);
	deleteGroup (_heliGroup);

};

// CAS - 2 Littlebirds
if (_event == "Pawnee") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	// 1st Pawnee
	_cas = createVehicle ["B_Heli_Light_01_armed_F", [0,0,75], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);

	_cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 2000, 75];
	_cas flyInHeight 75;

	// 2nd Pawnee
	_cas2 = createVehicle ["B_Heli_Light_01_armed_F", [50,50,75], [], 0, "FLY"];
	createVehicleCrew _cas2;
	_casCrew2 = crew _cas2;
	_casGroup2 = group (_casCrew2 select 0);
	[_casGroup2] join _casGroup;

	_cas2 setPosATL [(_targetPos select 0) + 100,(_targetPos select 1) - 2100, 75];
	_cas2 flyInHeight 75;

	// Waypoints
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS03 setWaypointType "SaD";
        _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (crew (_this select 0));
	};

	// If the cas2 is disabled, kill the crew
	_null = [_cas2,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (crew (_this select 0));
	};

	// Reveal players to pilots
	{(driver _cas) reveal [_x,4]} forEach allPlayers;

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _cas) < (3000)} count (allPlayers) == 0) and ({(_x distance _cas2) < (3000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_casCrew) + [_cas,_cas2];
	deleteGroup _casGroup;
};

// CAS - Comanche
if (_event == "Blackfoot") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	_cas = createVehicle ["B_Heli_Attack_01_F", [0,0,100], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);

	_cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 2000, 100];
	_cas flyInHeight 100;

	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS02 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS02 setWaypointType "SaD";
	_wpCAS03 = _casGroup addWaypoint [_targetPos, 250];
	_wpCAS03 setWaypointType "SaD";
        _wpCAS04 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS04 setWaypointType "Cycle";

	// If the cas is disabled, kill the crew
	_null = [_cas,_casCrew] spawn
	{
		waitUntil {sleep 2; !(isNull (_this select 0)) and {!(canMove (_this select 0))}};
		{_x setDamage 1} forEach (_this select 1);
	};

	// Remove missiles
        {_cas removeWeaponGlobal _x} forEach ["missiles_DAGR"];

	// Reveal players to pilot
	{(driver _cas) reveal [_x,4]} forEach allPlayers;

	// Retreat if damaged or after timeout
	_null = [_casGroup,_cas] spawn
	{
		_t = time;

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 300)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

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

// CAS - A10
if (_event == "A10") then
{
	// ["Event: %1",_event] call BIS_fnc_logFormat;

	_target = selectRandom allPlayers;
	_targetPos = getPosATL _target;

	_cas = createVehicle ["B_Plane_CAS_01_F", [(_targetPos select 0),(_targetPos select 1) - 2250, 125], [], 0, "FLY"];
	createVehicleCrew _cas;
	_casCrew = crew _cas;
	_casGroup = group (_casCrew select 0);

	// _cas setPosATL [(_targetPos select 0),(_targetPos select 1) - 1750, 125];
	_cas flyInHeight 125;
	_wpCAS01 = _casGroup addWaypoint [_targetPos, 0];
	_wpCAS01 setWaypointType "Guard";

	{_cas reveal [_x,4]} forEach (allPlayers);

	// Remove missiles
        {_cas removeWeaponGlobal _x} forEach [/*"Missile_AA_04_Plane_CAS_01_F",*/"Missile_AGM_02_Plane_CAS_01_F"];

	// Limit speed
	_cas forceSpeed 125;

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

		waitUntil {sleep 5; (damage (_this select 1) > 0.35) or (time > _t + 600)};

		_escGroup = createGroup west;
		_unit01 = _escGroup createUnit ["B_Soldier_F", [10,10,0], [], 0, "CAN_COLLIDE"];

		_wp01 = _escGroup addWaypoint [getPosATL _unit01, 0];
		deleteVehicle _unit01;

		(_this select 0) copyWaypoints (_escGroup);
		(_this select 0) setCombatMode "Blue";
		deleteGroup _escGroup;
	};

	// Delete when far away
	waitUntil {sleep 5; ({(_x distance _cas) < (5000)} count (allPlayers) == 0)};
	{deleteVehicle _x} forEach (_casCrew) + [_cas];
	deleteGroup _casGroup;
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
