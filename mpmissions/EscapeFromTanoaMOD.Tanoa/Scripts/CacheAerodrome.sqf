/*
Populate Aerodrome
*/

// Supply box
_ammobox = "O_CargoNet_01_ammo_F" createVehicle [11781.7,13052.9,0.053];
_ammobox setPos [11781.7,13052.9,0.053];
_ammobox setDir 200;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxCSAT;
_ammobox enableDynamicSimulation true;

// Empty vehicle 01
_vehicle01 = "O_T_LSV_02_unarmed_F" createVehicle [11788.9,13049.4,0];
_vehicle01 setDir 5;
_vehicle01 setFuel 0.45;
_vehicle01 setPosATL [11788.9,13049.4,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle01];
_vehicle01 addItemCargoGlobal ["FirstAidKit",2];
_vehicle01 enableDynamicSimulation true;

// Empty vehicle 02
_vehicle02 = "O_T_LSV_02_armed_F" createVehicle [11772.2,13054.2,0];
_vehicle02 setDir 23;
_vehicle02 setFuel 0.45;
_vehicle02 setPosATL [11772.2,13054.2,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle02];
_vehicle02 addItemCargoGlobal ["FirstAidKit",2];
_vehicle02 enableDynamicSimulation true;

sleep 2;

// Populate post
_null = BIS_AerodromePost01 call BIS_fnc_EfT_populatePost;

sleep 2;

// 1st group - hangar team
_pos01a = [11749.9,13082.6,0];
_pos01b = [11740.7,13049,0];
_pos01c = [11854.2,13013.4,0];
_pos01d = [11868.4,13053.6,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_engineer_F" createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_soldier_AA_F" createUnit [_grp01, _grp01, "", 0.5, "PRIVATE"];
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

// 2nd group - runway team
_pos02a = [11898.8,13117.3,0];
_pos02b = [11694.4,13176.1,0];

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

sleep 2;

// 6th group - terminal team
_pos06a = [11539.7,13132.6,0];
_pos06b = [11639.3,13098.6,0];

_grp06 = grpNull;
_grp06 = [_pos06a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_reconPatrol", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp06];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp06)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp06);
_grp06 enableDynamicSimulation true;

_wp06a = _grp06 addWaypoint [_pos06a, 0];
_wp06b = _grp06 addWaypoint [_pos06b, 0];
_wp06c = _grp06 addWaypoint [_pos06a, 0];
_wp06c setWaypointType "Cycle";
