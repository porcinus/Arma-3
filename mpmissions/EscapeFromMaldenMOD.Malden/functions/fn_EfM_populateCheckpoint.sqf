/*
Populate checkpoints in Escape from Malden
- create pair of guards on each (named) tower (random unit type)
- create fire team patrolling around (waypoints on markers set in parameters)

Example: _null = [tower1,tower2,"wp1","wp2","wp3","wp4"] call BIS_fnc_EfM_populateCheckpoint;
*/

// Params
params
[
	["_tower01",objNull,[objNull]],
	["_tower02",objNull,[objNull]],
	["_marker01","",[""]],
	["_marker02","",[""]],
	["_marker03","",[""]],
	["_marker04","",[""]]
];

// Check for validity
if (isNull _tower01) exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing unit tower %1 used!",_tower01]] call BIS_fnc_NNS_debugOutput;};
if (isNull _tower02) exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing unit tower %1 used!",_tower02]] call BIS_fnc_NNS_debugOutput;};
if (getMarkerType _marker01 == "") exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing marker %1 used!",_marker01]] call BIS_fnc_NNS_debugOutput;};
if (getMarkerType _marker02 == "") exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing marker %1 used!",_marker02]] call BIS_fnc_NNS_debugOutput;};
if (getMarkerType _marker03 == "") exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing marker %1 used!",_marker03]] call BIS_fnc_NNS_debugOutput;};
if (getMarkerType _marker04 == "") exitWith {[format["BIS_fnc_EfM_populateCheckpoint : Non-existing marker %1 used!",_marker04]] call BIS_fnc_NNS_debugOutput;};

//NNS : advice player for ahead location
_distance = round ((getPos _tower01) vectorDistance (getPos player)); //marker length
[format["Enemy checkpoint ahead (%1m)",_distance]] remoteExec ["systemChat",0,true];

[format["BIS_fnc_EfM_populateCheckpoint : %1",player distance2d _tower01]] call BIS_fnc_NNS_debugOutput; //debug


// Create group on 1st tower
_grp01 = createGroup west;
_grp01 setFormDir ((getDir _tower01) - 180);
_pos01 = _tower01 getRelPos [2,135];
_pos01 set [2, ((getPosASL _tower01 select 2) + 4.4)];
_pos02 = _tower01 getRelPos [2,225];
_pos02 set [2, ((getPosASL _tower01 select 2) + 4.4)];

_unit01 = _grp01 createUnit [selectRandom ["B_Soldier_F","B_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL _pos01;
_unit02 = _grp01 createUnit [selectRandom ["B_Soldier_AR_F","B_HeavyGunner_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL _pos02;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir ((getDir _tower01) - 180)} forEach [_unit01,_unit02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);

_grp01 enableDynamicSimulation true;

// Create group on 2nd tower
_grp02 = createGroup west;
_grp02 setFormDir ((getDir _tower02) - 180);
_pos03 = _tower02 getRelPos [2,135];
_pos03 set [2, ((getPosASL _tower02 select 2) + 4.4)];
_pos04 = _tower02 getRelPos [2,225];
_pos04 set [2, ((getPosASL _tower02 select 2) + 4.4)];

_unit03 = _grp02 createUnit [selectRandom ["B_Soldier_F","B_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL _pos03;
_unit04 = _grp02 createUnit [selectRandom ["B_Soldier_M_F","B_Sharpshooter_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04 setPosASL _pos04;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir ((getDir _tower02) - 180)} forEach [_unit03,_unit04];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp02);

_grp02 enableDynamicSimulation true;

// Create patrolling group
_grp03 = createGroup west;
_unit05 = _grp03 createUnit [selectRandom ["B_Soldier_TL_F","B_Soldier_SL_F"], getMarkerPos _marker01, [], 0, "CAN_COLLIDE"];
_unit06 = _grp03 createUnit [selectRandom ["B_Soldier_GL_F","B_Soldier_AR_F"], getMarkerPos _marker01, [], 0, "CAN_COLLIDE"];
_unit07 = _grp03 createUnit [selectRandom ["B_Medic_F","B_Soldier_F"], getMarkerPos _marker01, [], 0, "CAN_COLLIDE"];
_unit08 = _grp03 createUnit ["B_Soldier_LAT_F", getMarkerPos _marker01, [], 0, "CAN_COLLIDE"];
// removeBackpack _unit08; // no spare NLAWs

{_x setBehaviour "Safe"; _x setSpeedMode "Limited"; _x setFormation "Column"} forEach [_grp03];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp03);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp03);

_wp01 = _grp03 addWaypoint [getMarkerPos _marker01, 0];
_wp02 = _grp03 addWaypoint [getMarkerPos _marker02, 0];
_wp03 = _grp03 addWaypoint [getMarkerPos _marker03, 0];
_wp04 = _grp03 addWaypoint [getMarkerPos _marker04, 0];
_wp05 = _grp03 addWaypoint [getMarkerPos _marker01, 0];
_wp05 setWaypointType "Cycle";

_grp03 enableDynamicSimulation true;
