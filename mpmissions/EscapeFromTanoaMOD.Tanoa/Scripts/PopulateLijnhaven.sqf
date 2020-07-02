/*
Populate Lijnhaven city, port and airfield by CSAT
+ add a Kamysh, people like Kamyshes a lot
*/

// Populate cargo tower
 _null = LijnTower01 call BIS_fnc_EfT_populateTower;

sleep 2;

// Empty vehicles
_boat01 = "I_C_Boat_Transport_02_F" createVehicle [11598.361,2507.098,2.39];
_boat01 setDir 315;
_boat01 setFuel 0.45;
[_boat01,["Black",1],true] call BIS_fnc_initVehicle;
_boat01 setPosATL [11598.361,2507.098,2.39];

_boat02 = "I_C_Boat_Transport_02_F" createVehicle [11602.986,2512.608,2.39];
_boat02 setDir 315;
_boat02 setFuel 0.45;
[_boat02,["Black",1],true] call BIS_fnc_initVehicle;
_boat02 setPosATL [11602.986,2512.608,2.39];

sleep 2;

_boat03 = "I_C_Boat_Transport_02_F" createVehicle [11868.351,2726.113,3.667];
_boat03 setDir 133;
_boat03 setFuel 0.45;
[_boat03,["Black",1],true] call BIS_fnc_initVehicle;
_boat03 setPosATL [11868.351,2726.113,3.667];

_boat04 = "I_C_Boat_Transport_02_F" createVehicle [11844.327,2733.021,2.909];
_boat04 setDir 85;
_boat04 setFuel 0.45;
[_boat04,["Black",1],true] call BIS_fnc_initVehicle;
_boat04 setPosATL [11844.327,2733.021,2.909];

sleep 2;

_boat05 = "I_C_Boat_Transport_02_F" createVehicle [11779.588,2653.907,2.39];
_boat05 setDir 0;
_boat05 setFuel 0.45;
_boat05 setPosATL [11779.588,2653.907,2.39];

_boat06 = "I_C_Boat_Transport_02_F" createVehicle [11779.646,2642.135,2.39];
_boat06 setDir 180;
_boat06 setFuel 0.45;
_boat06 setPosATL [11779.646,2642.135,2.39];

sleep 2;

_boat07 = "C_Scooter_Transport_01_F" createVehicle [11833.195,2731.782,2.85];
_boat07 setDir 174;
_boat07 setFuel 0.45;
_boat07 setPosATL [11833.195,2731.782,2.85];

_boat08 = "C_Scooter_Transport_01_F" createVehicle [11807.638,2721.478,4.2];
_boat08 setDir 176;
_boat08 setFuel 0.45;
_boat08 setPosATL [11807.638,2721.478,4.2];

{_x enableDynamicSimulation true} forEach [_boat01,_boat02,_boat03,_boat04,_boat05,_boat06,_boat07,_boat08];

sleep 2;

_heli01 = "C_Heli_Light_01_civil_F" createVehicle [11666.19,3058.237,0];
_heli01 setDir 38;
_heli01 setFuel 0.45;
_heli01 setPosATL [11666.19,3058.237,0];

_heli02 = "C_Heli_Light_01_civil_F" createVehicle [11718.476,3174.401,0.139];
_heli02 setDir 215;
_heli02 setFuel 0.45;
_heli02 setPosATL [11718.476,3174.401,0.139];

_heli03 = "C_Heli_Light_01_civil_F" createVehicle [11751.715,3144.391,0];
_heli03 setDir 231;
_heli03 setFuel 0.45;
_heli03 setPosATL [11751.715,3144.391,0];

sleep 2;

_plane01 = "C_Plane_Civil_01_racing_F" createVehicle [11689.437,3173.52,0];
_plane01 setDir 185;
_plane01 setFuel 0.45;
_plane01 setPosATL [11689.437,3173.52,0];

_plane02 = "C_Plane_Civil_01_F" createVehicle [11778.201,3133.239,0.22];
_plane02 setDir 202;
_plane02 setFuel 0.45;
_plane02 setPosATL [11778.201,3133.239,0.22];

{_x enableDynamicSimulation true} forEach [_heli01,_heli02,_heli03,_plane01,_plane02];

sleep 2;

// Kamysh
_kamysh = createVehicle ["O_T_APC_Tracked_02_cannon_ghex_F", [11788.9,3028.75,0], [], 0, "NONE"];
_kamysh setDir 305;
createVehicleCrew _kamysh;
_kamyshCrew = crew _kamysh;
_kamyshGroup = group (_kamyshCrew select 0);

_kamyshGroup enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_kamysh];
_wpKamysh01 = _kamyshGroup addWaypoint [[11788.9,3028.75,0], 0];
_wpKamysh02 = _kamyshGroup addWaypoint [[11601.7,3167.37,0], 0];
_wpKamysh03 = _kamyshGroup addWaypoint [[11788.9,3028.75,0], 0];
_wpKamysh03 setWaypointType "Cycle";
_kamyshGroup setSpeedMode "Limited";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _kamyshCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _kamyshCrew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_kamysh allowCrewInImmobile true;
};

sleep 5;

// LSV
_lsv = createVehicle ["O_T_LSV_02_armed_ghex_F", [11553.5,2852.72,0], [], 0, "NONE"];
_lsv setDir 305;
createVehicleCrew _lsv;
_lsvCrew = crew _lsv;
_lsvGroup = group (_lsvCrew select 0);

_lsvGroup enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv];
_wplsv01 = _lsvGroup addWaypoint [[11553.5,2852.72,0], 0];
_wplsv01 setWaypointType "Guard";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _lsvCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _lsvCrew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_lsv allowCrewInImmobile true;
};

sleep 2.5;

// 1st group - runway squad
_pos01a = [11829.4,3042.81,0];
_pos01b = [11618,3201.48,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_soldier_AA_F" createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_engineer_F" createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
	"O_HeavyGunner_F" createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
};

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

sleep 2.5;

// 2nd group - terminal team
_pos02a = [11739.7,2964.43,0];
_pos02b = [11629.2,3049.71,0];

_grp02 = grpNull;
_grp02 = [_pos02a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_engineer_F" createUnit [_grp02, _grp02, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp02, _grp02, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_soldier_AA_F" createUnit [_grp02, _grp02, "", 0.5, "PRIVATE"];
	"O_HeavyGunner_F" createUnit [_grp02, _grp02, "", 0.5, "PRIVATE"];
};

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

sleep 2.5;

// 3rd group - tower guards
_pos03a = [11744.5,2983.35,19.3475];
_pos03b = [11748.5,2988.17,19.3479];
_pos03c = [11748.6,2985.59,23.0535];

_grp03 = createGroup east;
_grp03 setFormDir 290;
_unit03a = _grp03 createUnit [selectRandom ["O_T_Soldier_M_F","O_T_Soldier_LAT_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03a setPosASL _pos03a;
_unit03b = _grp03 createUnit [selectRandom ["O_T_Soldier_AR_F","O_T_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03b setPosASL _pos03b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 290} forEach (units _grp03);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
_grp03 enableDynamicSimulation true;

sleep 2.5;

// 4th group - central pier guards
_pos04a = [11772.3,2651.29,3.11836];
_pos04b = [11772.2,2643.94,3.11837];

_grp04 = createGroup east;
_grp04 setFormDir 90;
_unit04a = _grp04 createUnit [selectRandom ["O_T_Soldier_F","O_T_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04a setPosASL _pos04a;
_unit04b = _grp04 createUnit [selectRandom ["O_T_Soldier_AR_F","O_T_Soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04b setPosASL _pos04b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 90} forEach (units _grp04);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp04);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp04)};
_grp04 enableDynamicSimulation true;

sleep 2.5;

// 5th group - northern pier guards
_pos05a = [11800,2733.45,3.11288];
_pos05b = [11801.4,2720.4,3.11288];

_grp05 = createGroup east;
_grp05 setFormDir 90;
_unit05a = _grp05 createUnit [selectRandom ["O_T_Soldier_F","O_T_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05a setPosASL _pos05a;
_unit05b = _grp05 createUnit [selectRandom ["O_T_Soldier_AR_F","O_T_Soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05b setPosASL _pos05b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 90} forEach (units _grp05);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp05);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp05)};
_grp05 enableDynamicSimulation true;

sleep 2.5;

// 6th group - city team 01
_pos06a = [11506.2,2533.41,0];
_pos06b = [11637.8,2654.39,0];
_pos06c = [11639.7,2784.48,0];
_pos06d = [11792.8,2789.43,0];

_grp06 = grpNull;
_grp06 = [_pos06a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_soldier_AA_F" createUnit [_grp06, _grp06, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp06, _grp06, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_engineer_F" createUnit [_grp06, _grp06, "", 0.5, "PRIVATE"];
	"O_HeavyGunner_F" createUnit [_grp06, _grp06, "", 0.5, "PRIVATE"];
};

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp06];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp06);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp06)};
_grp06 enableDynamicSimulation true;

_wp06a = _grp06 addWaypoint [_pos06a, 0];
_wp06b = _grp06 addWaypoint [_pos06b, 0];
_wp06c = _grp06 addWaypoint [_pos06c, 0];
_wp06d = _grp06 addWaypoint [_pos06d, 0];
_wp06e = _grp06 addWaypoint [_pos06c, 0];
_wp06f = _grp06 addWaypoint [_pos06b, 0];
_wp06g = _grp06 addWaypoint [_pos06a, 0];
_wp06g setWaypointType "Cycle";

sleep 2.5;

// 7th group - city team 02
_pos07a = [11725.3,2520.96,0];
_pos07b = [11659,2518.71,0];
_pos07c = [11541.8,2413.83,0];
_pos07d = [11479,2478.83,0];

_grp07 = grpNull;
_grp07 = [_pos07a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_engineer_F" createUnit [_grp07, _grp07, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp07, _grp07, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_soldier_AA_F" createUnit [_grp07, _grp07, "", 0.5, "PRIVATE"];
	"O_HeavyGunner_F" createUnit [_grp07, _grp07, "", 0.5, "PRIVATE"];
};

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp07];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp07);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp07)};
_grp07 enableDynamicSimulation true;

_wp07a = _grp07 addWaypoint [_pos07a, 0];
_wp07b = _grp07 addWaypoint [_pos07b, 0];
_wp07c = _grp07 addWaypoint [_pos07c, 0];
_wp07d = _grp07 addWaypoint [_pos07d, 0];
_wp07e = _grp07 addWaypoint [_pos07c, 0];
_wp07f = _grp07 addWaypoint [_pos07b, 0];
_wp07g = _grp07 addWaypoint [_pos07a, 0];
_wp07g setWaypointType "Cycle";
