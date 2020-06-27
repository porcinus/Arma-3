/*
Cache in mountain range
*/

// Supply boxes
_ammobox = "O_CargoNet_01_ammo_F" createVehicle [10870.2,8665.49,0];
_ammobox setPos [10870.2,8665.49,0];
_ammobox setDir 355;
_ammobox allowDamage false;
_ammobox call BIS_fnc_EfT_ammoboxSpecial;
_ammobox enableDynamicSimulation true;

// Bunker
_bunker = "Land_BagBunker_01_small_green_F" createVehicle [10687,8702.48,0];
_bunker setPosATL [10687,8702.48,0];
_bunker setDir 230;

// 1st group - lower team
_pos01a = [10679.4,8703.47,0];
_pos01b = [10813.2,8716.83,0];

_grp01 = grpNull;
_grp01 = [_pos01a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaFireTeam", [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

sleep 2;

// 2nd group - upper team
_pos02a = [10717.6,8682.13,0];
_pos02b = [10871.1,8664.1,0];

_grp02 = grpNull;
_grp02 = [_pos02a, Resistance, configFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> "ParaShockTeam", [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

sleep 2;

// 3rd group - MG in bunker
_grp03 = createGroup resistance;
_grp03 setFormDir 52.5;

_pos03 = [10686.6,8702.2,0];

_unit03 = _grp03 createUnit ["I_C_Soldier_Para_4_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL _pos03;
_unit03 setUnitPos "Up";
_unit03 setSkill ["AimingAccuracy",0.1];
_grp03 enableDynamicSimulation true;
