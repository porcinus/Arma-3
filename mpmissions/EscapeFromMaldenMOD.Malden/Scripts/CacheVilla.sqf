/*
Populate the Villa
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected around the Villa (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["CacheVilla_populated",true,true];

//NNS : Populate building / ammo box
BIS_ViperBox call BIS_fnc_EfM_ammoboxSpecial;

// Empty vehicles
_lsv = "O_LSV_02_armed_F" createVehicle [5012.8,4007.76,0];
_lsv setDir 215;
_lsv setFuel 0.135;
_lsv setPosATL [5012.8,4007.76,0];
_lsv enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_lsv];

sleep 2;

// 1st group - outer patrol
_pos01a = [5029.09,3905.71,0];
_pos01b = [5092.69,4001.78,0];
_pos01c = [4991.65,4064.23,0];
_pos01d = [4937.12,3960.91,0];

_grp01 = grpNull;
_grp01 = [_pos01a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01c, 0];
_wp01d = _grp01 addWaypoint [_pos01d, 0];
_wp01e = _grp01 addWaypoint [_pos01a, 0];
_wp01e setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	{if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp01);

sleep 2.5;

// 2nd group - inner patrol
_pos02a = [5026.3,3942,0];
_pos02b = [5034.42,3985.72,0];
_pos02c = [4997.6,4009.17,0];
_pos02d = [4975.04,3979.14,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02c, 0];
_wp02d = _grp02 addWaypoint [_pos02d, 0];
_wp02e = _grp02 addWaypoint [_pos02a, 0];
_wp02e setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	{if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);
