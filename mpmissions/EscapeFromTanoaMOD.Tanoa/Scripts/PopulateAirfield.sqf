/*
Populate Airfield by CSAT
*/

// Populate cargo towers
_null = AirfieldTower01 call BIS_fnc_EfT_populateTower;
sleep 2;
_null = AirfieldTower02 call BIS_fnc_EfT_populateTower;
sleep 2;

// Empty vehicles

_heli01 = "C_Heli_Light_01_civil_F" createVehicle [6935.636,7236.271,0];
_heli01 setDir 87;
_heli01 setFuel 0.45;
_heli01 setPosATL [6935.636,7236.271,0];

_heli02 = "C_Heli_Light_01_civil_F" createVehicle [6934.953,7262.971,0];
_heli02 setDir 96;
_heli02 setFuel 0.45;
_heli02 setPosATL [6934.953,7262.971,0];

_plane01 = "C_Plane_Civil_01_F" createVehicle [6971.993,7187.476,0];
_plane01 setDir 332;
_plane01 setFuel 0.45;
_plane01 setPosATL [6971.993,7187.476,0];

sleep 2;

_plane02 = "C_Plane_Civil_01_F" createVehicle [6947.962,7171.05,0];
_plane02 setDir 0;
_plane02 setFuel 0.45;
_plane02 setPosATL [6947.962,7171.05,0];

_plane03 = "C_Plane_Civil_01_racing_F" createVehicle [6847.806,7260.713,0.018];
_plane03 setDir 28;
_plane03 setFuel 0.45;
_plane03 setPosATL [6847.806,7260.713,0.018];

_plane04 = "C_Plane_Civil_01_racing_F" createVehicle [6818.45,7324.65,0.037];
_plane04 setDir 141;
_plane04 setFuel 0.45;
_plane04 setPosATL [6818.45,7324.65,0.037];

{_x enableDynamicSimulation true} forEach [_heli01,_heli02,_plane01,_plane02,_plane03,_plane04];

sleep 2;

// Kamysh

_kamysh = createVehicle ["O_T_APC_Tracked_02_cannon_ghex_F", [7095.65,7192.22,0], [], 0, "NONE"];
_kamysh setDir 305;
createVehicleCrew _kamysh;
_kamyshCrew = crew _kamysh;
_kamyshGroup = group (_kamyshCrew select 0);

_kamyshGroup enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_kamysh];
_wpKamysh01 = _kamyshGroup addWaypoint [[7095.65,7192.22,0], 0];
_wpKamysh02 = _kamyshGroup addWaypoint [[7041.09,7502.58,0], 0];
_wpKamysh03 = _kamyshGroup addWaypoint [[7095.65,7192.22,0], 0];
_wpKamysh03 setWaypointType "Cycle";
_kamyshGroup setSpeedMode "Limited";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _kamyshCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _kamyshCrew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_kamysh allowCrewInImmobile true;
};

sleep 5;

// Tigris
_tigris = createVehicle ["O_T_APC_Tracked_02_AA_ghex_F", [6969.31,7288.02,0], [], 0, "NONE"];
_tigris setDir 45;
createVehicleCrew _tigris;
_tigrisCrew = crew _tigris;
_tigrisGroup = group (_tigrisCrew select 0);

_tigrisGroup enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_tigris];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _tigrisCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _tigrisCrew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_tigris allowCrewInImmobile true;
};

sleep 5;

// 1st group - runway team
_pos01a = [7232.73,7318.64,0];
_pos01b = [7156.25,7687.45,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

sleep 5;

// 2nd group - terminal team
_pos02a = [6949.14,7334.01,0];
_pos02b = [6920.8,7485.47,0];
_pos02c = [6842.98,7467.33,0];
_pos02d = [6896.35,7326.56,0];

_grp02 = grpNull;
_grp02 = [_pos02a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
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

sleep 5;

// 6th group - hangar team 1
_pos06a = [6901.42,7286.91,0];
_pos06b = [6818.47,7354.98,0];
_pos06c = [6769.92,7297.7,0];
_pos06d = [6848.78,7223.81,0];

_grp06 = grpNull;
_grp06 = [_pos06a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp06];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp06)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp06);
_grp06 enableDynamicSimulation true;

_wp06a = _grp06 addWaypoint [_pos06a, 0];
_wp06b = _grp06 addWaypoint [_pos06b, 0];
_wp06c = _grp06 addWaypoint [_pos06c, 0];
_wp06d = _grp06 addWaypoint [_pos06d, 0];
_wp06e = _grp06 addWaypoint [_pos06a, 0];
_wp06e setWaypointType "Cycle";

sleep 5;

// 7th group - hangar team 2
_pos07a = [6996.96,7099.42,0];
_pos07b = [6998.36,7217.9,0];
_pos07c = [6910.98,7217.42,0];
_pos07d = [6911.13,7120.86,0];

_grp07 = grpNull;
_grp07 = [_pos07a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
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
