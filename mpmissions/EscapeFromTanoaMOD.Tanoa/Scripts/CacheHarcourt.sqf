/*
Cache in Harcourt
*/

// Supply boxes
_ammobox = "B_CargoNet_01_ammo_F" createVehicle [11227.9,5390.82,0];
_ammobox setPos [11227.9,5390.82,0];
_ammobox setDir 135;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxNATO;
_ammobox enableDynamicSimulation true;

_supplybox = "Box_NATO_Equip_F" createVehicle [11230.9,5393.64,0];
_supplybox setPos [11230.9,5393.64,0];
_supplybox setDir 85;
_supplybox allowDamage false;
_supplybox call BIS_fnc_EfT_supplyboxNATO;
_supplybox enableDynamicSimulation true;

// Vehicles
_lsv01 = "B_T_LSV_01_armed_F" createVehicle [11240,5387.23,0];
_lsv01 setDir 171;
_lsv01 setFuel 0.5;
_lsv01 setPosATL [11240,5387.23,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv01];
_lsv01 addItemCargoGlobal ["FirstAidKit",2];
_lsv01 enableDynamicSimulation true;

/*
_apc01 = "B_T_APC_Tracked_01_rcws_F" createVehicle [11219.8,5386.93,0];
_apc01 setDir 115;
_apc01 setFuel 0.35;
_apc01 setPosATL [11219.8,5386.93,0];
_apc01 setVehicleAmmo 0.5;
*/

// 1st group - depot team
_pos01a = [11299.28,5314.256,0];
_pos01b = [11278.281,11278.281,0];

_grp01 = grpNull;
_grp01 = [_pos01a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaShockTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

sleep 2.5;

// 2nd group - city bandit team
_pos02a = [11236,5233.44,0];
_pos02b = [11223.818,5295.118,0];
_pos02c = [11284.128,5305.252,0];
_pos02d = [11297.146,5225.182,0];

_grp02 = grpNull;
_grp02 = [_pos02a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "BanditFireTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
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

sleep 2.5;

// 3rd group - city para team
_pos03a = [11123.441,5166.521,0];
_pos03b = [11278.757,5181.404,0];

_grp03 = grpNull;
_grp03 = [_pos03a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp03];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);
_grp03 enableDynamicSimulation true;

_wp03a = _grp03 addWaypoint [_pos03a, 0];
_wp03b = _grp03 addWaypoint [_pos03b, 0];
_wp03c = _grp03 addWaypoint [_pos03a, 0];
_wp03c setWaypointType "Cycle";
