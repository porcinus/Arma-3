/*
NNS : Populate south east base (created from scratch)
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
_distance = round ((getPos _trigger) vectorDistance (getPos player)); //marker length
[format["Enemy activity detected around nearby location (%1m)",_distance]] remoteExec ["systemChat",0,true];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["SouthWestBase_populated",true,true];

//NNS : Populate building / ammo box
_null = objective_9_tower_0 call BIS_fnc_EfM_populateTower;
_null = objective_9_tower_0 call NNS_fnc_Populate_CargoTower_More;
_null = objective_9_tower_1 call BIS_fnc_EfM_populateTower;
_null = objective_9_tower_2 call BIS_fnc_EfM_populateTower;
_null = objective_9_post_0 call BIS_fnc_EfM_populatePost;
_null = objective_9_post_1 call BIS_fnc_EfM_populatePost;
_null = objective_9_post_2 call BIS_fnc_EfM_populatePost;
_null = objective_9_post_3 call BIS_fnc_EfM_populatePost;
_null = objective_9_hq_0 call NNS_fnc_Populate_CargoHQ;
_null = objective_9_hq_0 call NNS_fnc_Populate_CargoHQ_More;
_null = objective_9_hq_1 call NNS_fnc_Populate_CargoHQ;

//enable existing units
{
	if !(_x isEqualTo objNull) then {
		_x enableSimulationGlobal true;
		_x hideObjectGlobal false;
	};
} forEach [objective_9_group_0_vehi,objective_9_group_1_vehi,objective_9_group_2_vehi];

{
	{
		if !(_x isEqualTo objNull) then {
			_x enableSimulationGlobal true;
			_x hideObjectGlobal false;
		};
	} forEach units _x;
} forEach [objective_9_group_0,objective_9_group_1,objective_9_group_2];

// Slammer patrol
_slammer = createVehicle ["B_MBT_01_cannon_F", [1515,1206,0], [], 0, "NONE"]; _slammer setDir 0;
createVehicleCrew _slammer; _slammerCrew = crew _slammer; _slammerGroup = group (_slammerCrew select 0);
_slammerGroup setSpeedMode "Limited"; _slammerGroup setBehaviour "Careless"; _slammerGroup setCombatMode "YELLOW";
_slammerGroup enableDynamicSimulation true;
{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_slammer];
_wpslammer01 = _slammerGroup addWaypoint [[1698,1343,0],0];
_wpslammer02 = _slammerGroup addWaypoint [[1698,1624,0],0];
_wpslammer03 = _slammerGroup addWaypoint [[1455,1400,0],0];
_wpslammer04 = _slammerGroup addWaypoint [[1619,1255,0],0]; _wpslammer04 setWaypointType "Cycle";
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach _slammerCrew};
{[_x,"limited"] call NNS_fnc_AIskill;} forEach _slammerCrew;
//{_x setSkill ["AimingAccuracy",0.2]} forEach _slammerCrew;
if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_slammer allowCrewInImmobile true;};
sleep 2;

// Ghost Hawk patrol
_heli = createVehicle ["B_Heli_Transport_01_F", [1666,1308,0], [], 0, "FLY"]; _slammer setDir 333;
createVehicleCrew _heli; _heliCrew = crew _heli; _heliGroup = group (_heliCrew select 0);
_heliGroup setBehaviour "Careless"; _heliGroup setCombatMode "YELLOW";
_heliGroup enableDynamicSimulation true;
{[_x] call NNS_fnc_AIskill;} forEach _heliCrew;
//{_x setSkill ["AimingAccuracy",0.5]} forEach _heliCrew;
_wpheli01 = _heliGroup addWaypoint [[1500,1268,90],100];
_wpheli02 = _heliGroup addWaypoint [[1338,1397,90],100];
_wpheli03 = _heliGroup addWaypoint [[1596,1810,90],100];
_wpheli04 = _heliGroup addWaypoint [[1975,1521,90],100];
_wpheli05 = _heliGroup addWaypoint [[1656,1151,90],100];
_wpheli05 setWaypointType "Cycle";
_null = [_heli,_heliCrew] spawn {waitUntil {sleep 2.5; !(isNull (_this select 0)) and {!(canMove (_this select 0))}}; {_x setDamage 1} forEach (_this select 1);}; // If the heli is disabled, kill the crew
sleep 2;


