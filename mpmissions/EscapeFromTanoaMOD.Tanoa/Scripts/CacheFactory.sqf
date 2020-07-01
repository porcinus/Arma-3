/*
Cache in Sugarcane factory
*/

// Supply boxes
_ammobox = "O_CargoNet_01_ammo_F" createVehicle [8410.86,10249.3,0];
_ammobox setPos [8410.86,10249.3,0];
_ammobox setDir 0;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxCSAT;
_ammobox enableDynamicSimulation true;

// Vehicles
_lsv01 = "O_T_LSV_02_armed_F" createVehicle [8398.297,10249.239,0];
_lsv01 setDir 135;
_lsv01 setFuel 0.5;
_lsv01 setPosATL [8398.297,10249.239,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv01];
_lsv01 addItemCargoGlobal ["FirstAidKit",2];
_lsv01 enableDynamicSimulation true;

_truck01 = "O_T_Truck_03_transport_ghex_F" createVehicle [8535.459,10194.584,0];
_truck01 setDir 186;
_truck01 setFuel 0.5;
_truck01 setPosATL [8535.459,10194.584,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_truck01];
_truck01 addItemCargoGlobal ["FirstAidKit",2];
_truck01 enableDynamicSimulation true;

sleep 2.5;

// 1st group - depot team
_pos01a = [8523.898,10190.342,0];
_pos01b = [8362.257,10261.27,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;

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
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

sleep 2.5;

// 2nd group - marksman on tower
_grp02 = createGroup east;
_grp02 setFormDir 130;
_unit02 = _grp02 createUnit ["O_T_Soldier_M_F", [8367.73,10355.9,54.648], [], 0, "CAN_COLLIDE"];
_unit02 setPosATL [8367.73,10355.9,54.648];

{_x setUnitPos "Middle"; _x disableAI "Path"; _x setDir 130} forEach (units _grp02);
{_x setSkill ["AimingAccuracy",0.25]} forEach (units _grp02);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
_grp02 enableDynamicSimulation true;

// 3rd group - northern team
_pos03a = [8427.692,10331.186,0];
_pos03b = [8311.46,10412.822,0];

_grp03 = grpNull;
_grp03 = [_pos03a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;

//NNS: higher enemy amount
if (BIS_EnemyAmount > 0) then {
	"O_engineer_F" createUnit [_grp03, _grp03, "", 0.5, "PRIVATE"];
	selectRandom ["O_soldier_M_F","O_T_Soldier_F"] createUnit [_grp03, _grp03, "", 0.5, "PRIVATE"];
};

if (BIS_EnemyAmount > 1) then {
	"O_soldier_AA_F" createUnit [_grp03, _grp03, "", 0.5, "PRIVATE"];
	"O_HeavyGunner_F" createUnit [_grp03, _grp03, "", 0.5, "PRIVATE"];
};

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp03];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);
_grp03 enableDynamicSimulation true;

_wp03a = _grp03 addWaypoint [_pos03a, 0];
_wp03b = _grp03 addWaypoint [_pos03b, 0];
_wp03c = _grp03 addWaypoint [_pos03a, 0];
_wp03c setWaypointType "Cycle";

// 4th group - rifleman on scaffolding
_grp04 = createGroup east;
_grp04 setFormDir 130;
_unit04 = _grp04 createUnit ["O_T_Soldier_F", [8340.2,10261,7.53234], [], 0, "CAN_COLLIDE"];
_unit04 setPosATL [8340.2,10261,7.53234];

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 130} forEach (units _grp04);
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp04);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp04)};
_grp04 enableDynamicSimulation true;
