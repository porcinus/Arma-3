/*
Populate La Trinite
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in La Trinite (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["LaTrinite_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_LaTrinite1 call BIS_fnc_EfM_populateTower;
_null = BIS_Tower_LaTrinite2 call BIS_fnc_EfM_populateTower;
_null = BIS_Tower_LaTrinite3 call BIS_fnc_EfM_populateTower;

// Empty vehicles
_car01 = "C_Hatchback_01_F" createVehicle [7155.36,7738.72,0];
_car01 setDir 247;
_car01 setFuel 0.125;
_car01 setPosATL [7155.36,7738.72,0];
_car01 enableDynamicSimulation true;

_car02 = "C_Truck_02_covered_F" createVehicle [7229.8,8166.09,0];
_car02 setDir 49;
_car02 setFuel 0.235;
_car02 setPosATL [7229.8,8166.09,0];
_car02 enableDynamicSimulation true;

_car03 = "C_Offroad_01_F" createVehicle [7252.49,7934.37,0];
_car03 setDir 270;
_car03 setFuel 0.235;
_car03 setPosATL [7252.49,7934.37,0];
_car03 enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1]} forEach [_car01,_car02,_car03];

sleep 2.5;

// 1st patrol group
_pos01a = [6971.16,8012.38,0];
_pos01b = [7207.52,7911.1,0];

_grp01 = grpNull;
_grp01 = [_pos01a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp01);

sleep 2.5;

// 2nd patrol group
_pos02a = [7247.62,7793.25,0];
_pos02b = [7270.96,8013.3,0];
_pos02c = [7247.79,8160.51,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02c, 0];
_wp02d = _grp02 addWaypoint [_pos02b, 0];
_wp02e = _grp02 addWaypoint [_pos02a, 0];
_wp02e setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);

// 3rd patrol team (guarding Marid)
_pos03a = [7036.91,8088.53,0];
_pos03b = [7009.68,8106.1,0];

_grp03 = grpNull;
_grp03 = [_pos03a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp03];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp03);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);
_grp03 enableDynamicSimulation true;

_wp03a = _grp03 addWaypoint [_pos03a, 0];
_wp03b = _grp03 addWaypoint [_pos03b, 0];
_wp03c = _grp03 addWaypoint [_pos03a, 0];
_wp03c setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp03);

[[_grp01,_grp02,_grp03]] call BIS_fnc_NNS_AInoPower; //powergrid off
