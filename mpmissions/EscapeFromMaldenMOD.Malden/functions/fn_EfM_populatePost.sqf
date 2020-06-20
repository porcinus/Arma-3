/*
Populate cargo posts in Escape from Malden

Example: _null = post call BIS_fnc_EfM_populatePost;
*/

// Params
params
[
	["_post",objNull,[objNull]]
];


// Check for validity
if (isNull _post) exitWith {[format["BIS_fnc_EfM_populatePost : Non-existing post %1 used!",_post]] call BIS_fnc_NNS_debugOutput;};

[format["BIS_fnc_EfM_populatePost : %1",player distance2d _post]] call BIS_fnc_NNS_debugOutput; //debug

// Create group on the post
_grp01 = createGroup west;
_grp01 setFormDir ((getDir _post) - 180);

_pos01 = _post getRelPos [2,135];
_pos01 set [2, ((getPosASL _post select 2) + 4.4)];
_pos02 = _post getRelPos [2,225];
_pos02 set [2, ((getPosASL _post select 2) + 4.4)];

_unit01 = _grp01 createUnit [selectRandom ["B_Soldier_F","B_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL _pos01;
_unit02 = _grp01 createUnit [selectRandom ["B_Soldier_AR_F","B_Soldier_M_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL _pos02;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir ((getDir _post) - 180)} forEach [_unit01,_unit02];
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};
{[_x,"limited"] call BIS_fnc_NNS_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.15]} forEach (units _grp01);

_grp01 enableDynamicSimulation true;

[[_grp01]] call BIS_fnc_NNS_AInoPower; //NNS: powergrid off
