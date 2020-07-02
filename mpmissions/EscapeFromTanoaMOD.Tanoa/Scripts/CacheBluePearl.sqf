/*
Populate Blue Pearl port
*/

// Supply boxes
_ammobox = "O_CargoNet_01_ammo_F" createVehicle [13660.4,12221.3,0];
_ammobox setPos [13660.4,12221.3,0];
_ammobox setDir 110;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxCSAT;
_ammobox enableDynamicSimulation true;

// Empty vehicle 01
_vehicle01 = "O_T_MRAP_02_gmg_ghex_F" createVehicle [13667.1,12226,0];
_vehicle01 setDir 113;
_vehicle01 setFuel 0.45;
_vehicle01 setPosATL [13667.1,12226,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle01];
_vehicle01 addItemCargoGlobal ["FirstAidKit",2];
_vehicle01 enableDynamicSimulation true;

// Empty vehicle 02
_vehicle02 = "O_T_LSV_02_armed_F" createVehicle [13661.2,12214.6,0];
_vehicle02 setDir 75;
_vehicle02 setFuel 0.45;
_vehicle02 setPosATL [13661.2,12214.6,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle02];
_vehicle02 addItemCargoGlobal ["FirstAidKit",2];
_vehicle02 enableDynamicSimulation true;

sleep 2;

// Marid
_marid = createVehicle ["O_T_APC_Wheeled_02_rcws_ghex_F", [13610.3,11972.4,0], [], 0, "NONE"];
_marid setDir 305;
createVehicleCrew _marid;
_maridCrew = crew _marid;
_maridGroup = group (_maridCrew select 0);

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_marid];
_marid addItemCargoGlobal ["FirstAidKit",2];
_wpMarid01 = _maridGroup addWaypoint [[13610.3,11972.4,0], 0];
_wpMarid02 = _maridGroup addWaypoint [[13227.3,12122.2,0], 0];
_wpMarid03 = _maridGroup addWaypoint [[13610.3,11972.4,0], 0];
_wpMarid03 setWaypointType "Cycle";
_maridGroup setSpeedMode "Limited";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _maridCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _maridCrew;

_maridGroup enableDynamicSimulation true;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_marid allowCrewInImmobile true;
};

sleep 2;

// LSV
_lsv = createVehicle ["O_T_LSV_02_armed_F", [13535.6,12350.2,0], [], 0, "NONE"];
_lsv setDir 200;
createVehicleCrew _lsv;
_lsvCrew = crew _lsv;
_lsvGroup = group (_lsvCrew select 0);

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv];
_lsv addItemCargoGlobal ["FirstAidKit",2];
_wpLSV01 = _lsvGroup addWaypoint [[13535.6,12350.2,0], 0];
_wpLSV01 setWaypointType "Guard";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _lsvCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _lsvCrew;

_lsvGroup enableDynamicSimulation true;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_lsv allowCrewInImmobile true;
};

sleep 2;

// 1st group - office team
_pos01a = [13307.8,11948.8,0];
_pos01b = [13335.1,12007.6,0];
_pos01c = [13237.5,12051.7,0];
_pos01d = [13214.9,12006.6,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

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
_wp01c = _grp01 addWaypoint [_pos01c, 0];
_wp01d = _grp01 addWaypoint [_pos01d, 0];
_wp01e = _grp01 addWaypoint [_pos01a, 0];

_wp01e setWaypointType "Cycle";

sleep 2;

// 2nd group - container squad
_pos02a = [13420.6,12095.8,0];
_pos02b = [13529.1,12351.5,0];
_pos02c = [13369.9,12411,0];
_pos02d = [13262.6,12170.6,0];

_grp02 = grpNull;
_grp02 = [_pos02a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

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
_wp02c = _grp02 addWaypoint [_pos02c, 0];
_wp02d = _grp02 addWaypoint [_pos02d, 0];
_wp02e = _grp02 addWaypoint [_pos02a, 0];
_wp02e setWaypointType "Cycle";

sleep 2;

// 4th group - marksman on a crane
_grp04 = createGroup east;
_grp04 setFormDir 210;
_unit04 = _grp04 createUnit ["O_T_Soldier_M_F", [13639.8,12314.5,34.3294], [], 0, "CAN_COLLIDE"];
_unit04 setPosATL [13639.8,12314.5,34.3294];

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 210} forEach (units _grp04);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp04);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp04)};
_grp04 enableDynamicSimulation true;

// 5th group - rifleman on stairs
_grp05 = createGroup east;
_grp05 setFormDir 200;
_unit05 = _grp05 createUnit ["O_T_Soldier_F", [13394.2,12094.5,10.5705], [], 0, "CAN_COLLIDE"];
_unit05 setPosATL [13394.2,12094.5,10.5705];

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 200} forEach (units _grp05);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp05);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp05)};
_grp05 enableDynamicSimulation true;

// 6th group - eastern team
_pos06a = [13565.9,11810.2,0];
_pos06b = [13667.2,12071.1,0];

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
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp06)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp06);
_grp06 enableDynamicSimulation true;

_wp06a = _grp06 addWaypoint [_pos06a, 0];
_wp06b = _grp06 addWaypoint [_pos06b, 0];
_wp06c = _grp06 addWaypoint [_pos06a, 0];
_wp06c setWaypointType "Cycle";

sleep 2;

// 7th group - city team
_pos07a = [13503.1,12252.6,0];
_pos07b = [13627.7,12201.4,0];
_pos07c = [13672.8,12309.4,0];
_pos07d = [13552.8,12359.7,0];

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
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp07)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp07);
_grp07 enableDynamicSimulation true;

_wp07a = _grp07 addWaypoint [_pos07a, 0];
_wp07b = _grp07 addWaypoint [_pos07b, 0];
_wp07c = _grp07 addWaypoint [_pos07c, 0];
_wp07d = _grp07 addWaypoint [_pos07d, 0];
_wp07e = _grp07 addWaypoint [_pos07a, 0];
_wp07e setWaypointType "Cycle";
