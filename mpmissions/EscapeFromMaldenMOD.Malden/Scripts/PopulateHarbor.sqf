/*
Populate the harbour in Le Port
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected in Le Port (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Harbor_populated",true,true];

//NNS : Populate building / ammo box
_null = BIS_Tower_Port1 call BIS_fnc_EfM_populateTower;
_null = BIS_Tower_Port2 call BIS_fnc_EfM_populateTower;
_null = BIS_Tower_Port2 call NNS_fnc_Populate_CargoTower_More;

// Empty vehicles
_boat01 = "C_Rubberboat" createVehicle [8495.92,3797.15,6.1];
_boat01 setDir 6.5;
_boat01 setFuel 0.135;
_boat01 setPosATL [8495.92,3797.15,6.1];
_boat01 enableDynamicSimulation true;
_boat01 allowDamage false; //     ---     ---     ---     cannot be destroyed > for testing

_boat03 = "C_Rubberboat" createVehicle [8499.44,3857.12,2.5];
_boat03 setDir 95;
_boat03 setFuel 0.135;
_boat03 setPosATL [8499.44,3857.12,2.5];
_boat03 enableDynamicSimulation true;
_boat03 allowDamage false; //     ---     ---     ---     cannot be destroyed > for testing

_boat02 = "C_Rubberboat" createVehicle [9294.75,3872.42,4.55];
_boat02 setDir 165;
_boat02 setFuel 0.135;
_boat02 setPosATL [9294.75,3872.42,4.55];
_boat02 enableDynamicSimulation true;
_boat02 allowDamage false; //     ---     ---     ---     cannot be destroyed > for testing

{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_boat01,_boat02,_boat03];

sleep 2;

// 1st group - western harbor (squad)
_pos01a = [8439.32,3704.28,0];
_pos01b = [8429.37,3906.9,0];

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

sleep 5;

// 2nd group - eastern harbor (sentry)
_pos02a = [9379.02,3747.84,0];
_pos02b = [9347.92,3853.96,0];

_grp02 = grpNull;
_grp02 = [_pos02a, west, configFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSentry", [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);
_grp02 enableDynamicSimulation true;

_wp02a = _grp02 addWaypoint [_pos02a, 0];
_wp02b = _grp02 addWaypoint [_pos02b, 0];
_wp02c = _grp02 addWaypoint [_pos02a, 0];
_wp02c setWaypointType "Cycle";


[[_grp01,_grp02]] call NNS_fnc_AInoPower; //powergrid off
