/*
Cache - Mine
*/

// Supply boxes
_ammobox = "B_CargoNet_01_ammo_F" createVehicle [12067.6,10611,0];
_ammobox setPos [12067.6,10611,0];
_ammobox setDir 135;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxNATO;
_ammobox enableDynamicSimulation true;

_supplybox = "Box_NATO_Equip_F" createVehicle [12068.4,10607.8,0];
_supplybox setPos [12068.4,10607.8,0];
_supplybox setDir 0;
_supplybox allowDamage false;
_supplybox call BIS_fnc_EfT_supplyboxNATO;
_supplybox enableDynamicSimulation true;

// Vehicles
_lsv01 = "B_T_LSV_01_armed_F" createVehicle [12077.097,10606.555,0];
_lsv01 setDir 224;
_lsv01 setFuel 0.5;
_lsv01 setPosATL [12077.097,10606.555,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv01];
_lsv01 addItemCargoGlobal ["FirstAidKit",2];
_lsv01 enableDynamicSimulation true;

_lsv02 = "B_T_LSV_01_unarmed_F" createVehicle [12082.371,10600.057,0];
_lsv02 setDir 262;
_lsv02 setFuel 0.45;
_lsv02 setPosATL [12082.371,10600.057,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv02];
_lsv02 addItemCargoGlobal ["FirstAidKit",2];
_lsv02 enableDynamicSimulation true;

// 1st group - outer team
_pos01a = [12278.5,10633.1,0];
_pos01b = [12148.4,10812.8,0];
_pos01c = [11979.2,10858.2,0];
_pos01d = [11844.1,10707.7,0];

_grp01 = grpNull;
_grp01 = [_pos01a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditFireTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01c, 0];
_wp01d = _grp01 addWaypoint [_pos01d, 0];
_wp01e = _grp01 addWaypoint [_pos01c, 0];
_wp01f = _grp01 addWaypoint [_pos01b, 0];
_wp01g = _grp01 addWaypoint [_pos01a, 0];
_wp01g setWaypointType "Cycle";

sleep 2.5;

// 2nd group - road team
_pos02a = [11912.3,10556.1,0];
_pos02b = [12138.7,10529.3,0];

_grp02 = grpNull;
_grp02 = [_pos02a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

sleep 2.5;

// 3rd group - inner team
_pos03a = [12009.6,10615.3,0];
_pos03b = [12135.9,10626.3,0];

_grp03 = grpNull;
_grp03 = [_pos03a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditFireTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp03];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
_grp03 enableDynamicSimulation true;

_wp03a = _grp03 addWaypoint [_pos03a, 0];
_wp03b = _grp03 addWaypoint [_pos03b, 0];
_wp03c = _grp03 addWaypoint [_pos03a, 0];
_wp03c setWaypointType "Cycle";

sleep 2.5;

// 1st 'strongpoint'
_grp04 = createGroup resistance;
_grp04 setFormDir 213;

_pos04a = [12052.187,10472.985,0];
_pos04b = [12050.642,10474.441,0];

_unit04a = _grp04 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Para_6_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04a setPosASL _pos04a;
_unit04b = _grp04 createUnit [selectRandom ["I_C_Soldier_Para_1_F","I_C_Soldier_Para_5_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04b setPosASL _pos04b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 213} forEach [_unit04a,_unit04b];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp04);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp04)};
_grp04 enableDynamicSimulation true;

sleep 2.5;

// 2nd 'strongpoint'
_grp05 = createGroup resistance;
_grp05 setFormDir 213;

_pos05a = [12004.225,10268.519,0];
_pos05b = [12002.536,10269.798,0];

_unit05a = _grp05 createUnit [selectRandom ["I_C_Soldier_Para_4_F","I_C_Soldier_Para_6_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05a setPosASL _pos05a;
_unit05b = _grp05 createUnit [selectRandom ["I_C_Soldier_Para_1_F","I_C_Soldier_Para_5_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05b setPosASL _pos05b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir 213} forEach [_unit05a,_unit05b];
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp05);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp05)};
_grp05 enableDynamicSimulation true;
