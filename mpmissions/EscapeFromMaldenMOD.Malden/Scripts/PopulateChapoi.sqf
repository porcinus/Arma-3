/*
Populate Chapoi
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in Chapoi (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Chapoi_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Chapoi call BIS_fnc_EfM_populateTower;

// Empty vehicles
_car01 = "C_Hatchback_01_F" createVehicle [5794.66,3529,0];
_car01 setDir 2;
_car01 setFuel 0.125;
_car01 setPosATL [5794.66,3529,0];
_car01 enableDynamicSimulation true;

_car02 = "C_Van_01_transport_F" createVehicle [5932.91,3532.17,0];
_car02 setDir 180;
_car02 setFuel 0.235;
_car02 setPosATL [5932.91,3532.17,0];
_car02 enableDynamicSimulation true;

_car03 = "C_Offroad_01_F" createVehicle [6015.08,3633.26,0];
_car03 setDir 75;
_car03 setFuel 0.235;
_car03 setPosATL [6015.08,3633.26,0];
_car03 enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1]} forEach [_car01,_car02,_car03];

sleep 2.5;

// 1st patrol group
_pos01a = [5666.72,3524.64,0];
_pos01b = [6020.29,3526.32,0];

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

sleep 2.5;

// 2nd patrol group
_pos02a = [5811.69,3427.38,0];
_pos02b = [5850.58,3665.81,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);

[[_grp01,_grp02]] call NNS_fnc_AInoPower; //powergrid off
