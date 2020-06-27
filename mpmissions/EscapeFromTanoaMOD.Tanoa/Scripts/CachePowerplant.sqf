/*
Cache in Diesel power plant
*/

// Supply boxes
_ammobox = "B_CargoNet_01_ammo_F" createVehicle [7444.06,8549.16,0];
_ammobox setPos [7444.06,8549.16,0];
_ammobox setDir 315;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxNATO;
_ammobox enableDynamicSimulation true;

_supplybox = "Box_NATO_Equip_F" createVehicle [7444.7,8552.85,0];
_supplybox setPos [7444.7,8552.85,0];
_supplybox setDir 0;
_supplybox allowDamage false;
_supplybox call BIS_fnc_EfT_supplyboxNATO;
_supplybox enableDynamicSimulation true;

// Vehicles
_lsv01 = "B_T_LSV_01_armed_F" createVehicle [7432.461,8548.866,0];
_lsv01 setDir 135;
_lsv01 setFuel 0.5;
_lsv01 setPosATL [7432.461,8548.866,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv01];
_lsv01 addItemCargoGlobal ["FirstAidKit",2];
_lsv01 enableDynamicSimulation true;

sleep 2.5;

// 1st group - main squad
_pos01a = [7470.193,8556.785,0];
_pos01b = [7372.677,8452.096,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";
