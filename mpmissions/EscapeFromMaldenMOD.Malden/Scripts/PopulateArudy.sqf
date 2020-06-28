/*
Populate Arudy
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in Arudy (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Arudy_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Arudy call BIS_fnc_EfM_populateTower;

// Empty vehicles
_car01 = "C_Offroad_01_F" createVehicle [5485.33,6974.15,0];
_car01 setDir 325;
_car01 setFuel 0.125;
_car01 setPosATL [5485.33,6974.15,0];
_car01 enableDynamicSimulation true;

_car02 = "C_Van_01_transport_F" createVehicle [5561.74,7015.65,0];
_car02 setDir 345;
_car02 setFuel 0.235;
_car02 setPosATL [5561.74,7015.65,0];
_car02 enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1]} forEach [_car01,_car02];

sleep 2.5;

// 1st patrol group
_pos01a = [5659.98,6996.41,0];
_pos01b = [5477.67,6981.38,0];

_grp01 = grpNull;
_grp01 = [_pos01a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01a, 0];
_wp01c setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp01);
/*
sleep 2.5;

// 2nd patrol group
_pos02a = [5811.69,3427.38,0];
_pos02b = [5850.58,3665.81,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	{if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);
*/

[[_grp01]] call NNS_fnc_AInoPower; //powergrid off
