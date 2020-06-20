/*
Populate Military island
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected near old military base (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Island_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Island call BIS_fnc_EfM_populateTower;
BIS_IslandBox call BIS_fnc_EfM_ammoboxNATO;

// Empty vehicles
/*
_heli01 = "B_Heli_Transport_01_F" createVehicle [9705.15,3961.74,0];
_heli01 setDir 2.5;
_heli01 setFuel 0.235;
_heli01 setPosATL [9705.15,3961.74,0];
_heli01 enableDynamicSimulation true;

_heli02 = "B_Heli_Transport_01_F" createVehicle [9744.53,3955.79,0];
_heli02 setDir 180;
_heli02 setFuel 0.25;
_heli02 setPosATL [9744.53,3955.79,0];
_heli02 enableDynamicSimulation true;

_car = "B_Truck_01_covered_F" createVehicle [9773.65,3894.2,0];
_car setDir 0;
_car setFuel 0.075;
_car setPosATL [9773.65,3894.2,0];
_car enableDynamicSimulation true;

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearItemCargoGlobal _x} forEach [_heli01,_heli02,_car];

sleep 2;
*/
// 1st group - patrol
_pos01a = [9547.37,3744.12,0];
_pos01b = [9575.82,3906.38,0];

_grp01 = grpNull;
_grp01 = [_pos01a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfTeam", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
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

sleep 5;

// 2nd group - base squad
_pos02a = [9700.19,3907.25,0];
_pos02b = [9764.24,3880.19,0];
_pos02c = [9767.04,3939.23,0];

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
_wp02d = _grp02 addWaypoint [_pos02a, 0];
_wp02d setWaypointType "Cycle";

	// Remove backpack with spare NLAWs
	// {if (typeOf _x == "B_Soldier_LAT_F") then {removeBackpackGlobal _x}} forEach (units _grp02);

[[_grp01,_grp02]] call BIS_fnc_NNS_AInoPower; //powergrid off
