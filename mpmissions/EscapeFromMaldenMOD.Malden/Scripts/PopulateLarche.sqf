/*
Populate Larche
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in Larche (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Larche_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Larche call BIS_fnc_EfM_populateTower;

// Empty vehicles
_car01 = "C_Van_01_transport_F" createVehicle [5894.62,8679.96,0];
_car01 setDir 280;
_car01 setFuel 0.125;
_car01 setPosATL [5894.62,8679.96,0];
_car01 enableDynamicSimulation true;

_car02 = "C_SUV_01_F" createVehicle [6032.42,8611.68,0];
_car02 setDir 285;
_car02 setFuel 0.235;
_car02 setPosATL [6032.42,8611.68,0];
_car02 enableDynamicSimulation true;

_car03 = "C_Offroad_01_F" createVehicle [6171.57,8678.86,0];
_car03 setDir 160;
_car03 setFuel 0.235;
_car03 setPosATL [6171.57,8678.86,0];
_car03 enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1]} forEach [_car01,_car02,_car03];

sleep 2.5;

// 1st patrol group
_pos01a = [5871.87,8624.6,0];
_pos01b = [6122.65,8650.46,0];

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
_pos02a = [5929.81,8542.25,0];
_pos02b = [6014.16,8649.99,0];
_pos02c = [6022.4,8835.9,0];

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

[[_grp01,_grp02]] call BIS_fnc_NNS_AInoPower; //powergrid off
