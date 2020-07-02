/*
Cache in La Rochelle - LSVs, ammo + CSAT guards
*/

// Military post
_null = RochellePost01 call BIS_fnc_EfT_populatePost;

// Supply boxes
_ammobox = "B_CargoNet_01_ammo_F" createVehicle [8679.7,13845.3,0];
_ammobox setPos [8679.7,13845.3,0];
_ammobox setDir 135;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxNATO;
_ammobox enableDynamicSimulation true;

_supplybox = "Box_NATO_Equip_F" createVehicle [8678.28,13842.8,0];
_supplybox setPos [8678.28,13842.8,0];
_supplybox setDir 45;
_supplybox allowDamage false;
_supplybox call BIS_fnc_EfT_supplyboxNATO;
_supplybox enableDynamicSimulation true;

// Vehicles
_lsv01 = "B_T_LSV_01_armed_F" createVehicle [8687.269,13848.808,0];
_lsv01 setDir 160;
_lsv01 setFuel 0.5;
_lsv01 setPosATL [8687.269,13848.808,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv01];
_lsv01 addItemCargoGlobal ["FirstAidKit",2];
_lsv01 enableDynamicSimulation true;

_lsv02 = "B_T_LSV_01_unarmed_F" createVehicle [8681.814,13834.026,0];
_lsv02 setDir 100;
_lsv02 setFuel 0.5;
_lsv02 setPosATL [8681.814,13834.026,0];

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv02];
_lsv02 addItemCargoGlobal ["FirstAidKit",2];
_lsv02 enableDynamicSimulation true;

// 1st group - depot squad
_pos01a = [8759.437,13779.299,0];
_pos01b = [8695.155,13833.928,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.2, 0.5]] call BIS_fnc_spawnGroup;

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

// Enable Dynamic simulation
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";
