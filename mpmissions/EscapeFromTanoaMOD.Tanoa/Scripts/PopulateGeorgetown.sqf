/*
Populate Georgetown
*/

// Populate cargo post and towers
_null = GeorgePost01 call BIS_fnc_EfT_populatePost;
sleep 2;
_null = GeorgeTower01 call BIS_fnc_EfT_populateTower;
sleep 2;
_null = GeorgeTower02 call BIS_fnc_EfT_populateTower;
sleep 2;

// Empty vehicles
_heli01 = "C_Heli_Light_01_civil_F" createVehicle [10,10,10];
_heli01 setDir 142;
_heli01 setFuel 0.45;
_heli01 setPosATL [5560.664,10457.833,10.62];

_boat01 = "C_Boat_Transport_02_F" createVehicle [5584.027,10452.132,6.395];
_boat01 setDir 54;
_boat01 setFuel 0.45;
_boat01 setPosATL [5584.027,10452.132,6.395];

_boat02 = "C_Boat_Transport_02_F" createVehicle [5589,10444.852,6.048];
_boat02 setDir 54;
_boat02 setFuel 0.45;
_boat02 setPosATL [5589,10444.852,6.048];

sleep 2;

_scooter01 = "C_Scooter_Transport_01_F" createVehicle [5589.009,10451.157,6.045];
_scooter01 setDir 324;
_scooter01 setFuel 0.45;
_scooter01 setPosATL [5589.009,10451.157,6.045];

_scooter02 = "C_Scooter_Transport_01_F" createVehicle [5598.839,10399.296,4.267];
_scooter02 setDir 203;
_scooter02 setFuel 0.45;
_scooter02 setPosATL [5598.839,10399.296,4.267];

_scooter03 = "C_Scooter_Transport_01_F" createVehicle [5605.757,10396.463,3.814];
_scooter03 setDir 205;
_scooter03 setFuel 0.45;
_scooter03 setPosATL [5605.757,10396.463,3.814];

_scooter04 = "C_Scooter_Transport_01_F" createVehicle [5600.133,10394.074,4.169];
_scooter04 setDir 295;
_scooter04 setFuel 0.45;
_scooter04 setPosATL [5600.133,10394.074,4.169];

{_x enableDynamicSimulation true} forEach [_heli01,_boat01,_boat02,_scooter01,_scooter02,_scooter03,_scooter04];

sleep 2;

// Speedboat
_speedboat = createVehicle ["O_T_Boat_Armed_01_hmg_F", [5351.46,10387.4,0], [], 0, "NONE"];
createVehicleCrew _speedboat;
_speedboatCrew = crew _speedboat;
_speedboatGroup = group (_speedboatCrew select 0);

_speedboatGroup enableDynamicSimulation true;

_wpSpeedboat01 = _speedboatGroup addWaypoint [[5351.46,10387.4,0], 0];
_wpSpeedboat02 = _speedboatGroup addWaypoint [[5419.7,10720.6,0], 0];
_wpSpeedboat03 = _speedboatGroup addWaypoint [[5351.46,10387.4,0], 0];
_wpSpeedboat03 setWaypointType "Cycle";
_speedboatGroup setSpeedMode "Limited";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _speedboatCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _speedboatCrew;

sleep 2.5;

// Kamysh
_kamysh = createVehicle ["O_T_APC_Tracked_02_cannon_ghex_F", [5742.81,10309,0], [], 0, "NONE"];
_kamysh setDir 20;
createVehicleCrew _kamysh;
_kamyshCrew = crew _kamysh;
_kamyshGroup = group (_kamyshCrew select 0);

_kamyshGroup enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_kamysh];
_wpKamysh01 = _kamyshGroup addWaypoint [[5742.81,10309,0], 0];
_wpKamysh01 setWaypointType "Guard";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _kamyshCrew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _kamyshCrew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_kamysh allowCrewInImmobile true;
};

sleep 2.5;

// Random vehicle 01 - LSV or Ifrit
_vehicle01 = createVehicle [selectRandom ["O_T_LSV_02_armed_F","O_T_MRAP_02_gmg_ghex_F","O_T_MRAP_02_hmg_ghex_F"], [5857.05,10821.3,0], [], 0, "NONE"];
_vehicle01 setdir 20;
createVehicleCrew _vehicle01;
_vehicle01Crew = crew _vehicle01;
_vehicle01Group = group (_vehicle01Crew select 0);

_vehicle01Group enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle01];
_wpVehicle01 = _vehicle01Group addWaypoint [[5857.05,10821.3,0], 0];
_wpVehicle01 setWaypointType "Guard";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _vehicle01Crew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _vehicle01Crew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_vehicle01 allowCrewInImmobile true;
};

sleep 2.5;

// Random vehicle 02 - LSV or Ifrit
_vehicle02 = createVehicle [selectRandom ["O_T_LSV_02_armed_F","O_T_MRAP_02_gmg_ghex_F","O_T_MRAP_02_hmg_ghex_F"], [5500.2,9886.46,0], [], 0, "NONE"];
_vehicle02 setdir 260;
createVehicleCrew _vehicle02;
_vehicle02Crew = crew _vehicle02;
_vehicle02Group = group (_vehicle02Crew select 0);

_vehicle02Group enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_vehicle02];
_wpVehicle02 = _vehicle02Group addWaypoint [[5500.2,9886.46,0], 0];
_wpVehicle02 setWaypointType "Guard";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _vehicle02Crew};
{_x setSkill ["AimingAccuracy",0.15]} forEach _vehicle02Crew;

if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then
{
	_vehicle02 allowCrewInImmobile true;
};

sleep 5;

// 1st group - southern team
_pos01a = [5507.33,10036.3,0];
_pos01b = [5708.97,10120.7,0];
_pos01c = [5724.44,10022.3,0];
_pos01d = [5558.25,9901.28,0];

_grp01 = grpNull;
_grp01 = [_pos01a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
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

sleep 5;

// 2nd group - harbor squad
_pos02a = [5569.49,10117.5,0];
_pos02b = [5699.86,10478.6,0];

_grp02 = grpNull;
_grp02 = [_pos02a, EAST, configFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> "O_T_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

sleep 5;

// 6th group - central team
_pos06a = [5784.49,10219.7,0];
_pos06b = [5818.61,10356.5,0];
_pos06c = [5708.56,10394,0];
_pos06d = [5662.71,10259.3,0];

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

// 7th group - northern team
_pos07a = [5811,10498.3,0];
_pos07b = [5906.03,10570.2,0];
_pos07c = [5855.05,10817.2,0];
_pos07d = [5778.56,10763.9,0];

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
