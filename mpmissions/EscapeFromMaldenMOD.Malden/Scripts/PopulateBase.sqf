/*
Populate small base at the Military island
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected around nearby location (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Base_populated",true,true];

//NNS : Populate building / ammo box

// Empty vehicles
_car01 = "B_MRAP_01_F" createVehicle [11651.3,4457.85,0];
_car01 setDir 260;
_car01 setFuel 0.25;
_car01 setPosATL [11651.3,4457.85,0];
_car01 enableDynamicSimulation true;

_car02 = "B_Quadbike_01_F" createVehicle [11614.3,4491.38,0];
_car02 setDir 180;
_car02 setFuel 0.235;
_car02 setPosATL [11614.3,4491.38,0];
_car02 enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1]} forEach [_car01,_car02];

sleep 2.5;

// 1st patrol group
_pos01a = [11669.4,4417.79,0];
_pos01b = [11657.1,4512.85,0];
_pos01c = [11582.9,4503.26,0];
_pos01d = [11584.7,4412.15,0];

_grp01 = grpNull;
_grp01 = [_pos01a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp01];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);
_grp01 enableDynamicSimulation true;

_wp01a = _grp01 addWaypoint [_pos01a, 0];
_wp01b = _grp01 addWaypoint [_pos01b, 0];
_wp01c = _grp01 addWaypoint [_pos01c, 0];
_wp01d = _grp01 addWaypoint [_pos01d, 0];
_wp01e = _grp01 addWaypoint [_pos01a, 0];
_wp01e setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp01);

sleep 2.5;

// 2nd patrol team
_pos02a = [11614.4,4441.3,0];
_pos02b = [11644.4,4454.48,0];
_pos02c = [11607.1,4483.58,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02c, 0];
_wp02d = _grp02 addWaypoint [_pos02a, 0];
_wp02d setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);

[[_grp01,_grp02]] call BIS_fnc_NNS_AInoPower; //powergrid off
