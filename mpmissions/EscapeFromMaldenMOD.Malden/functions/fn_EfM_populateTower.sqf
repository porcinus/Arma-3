/*

Populate cargo tower with NATO units
8 units, those with same watch direction are in a same group

Example: _null = tower1 call BIS_fnc_EfM_populateTower;

usable positions and dirs:
[3,0][15,0]
[8,90][12,90]
[5,180][18,180]
[9,270][16,270]

*/

// Params
params
[
	["_tower",objNull,[objNull]]
];

// Check for validity
if (isNull _tower) exitWith {[format["BIS_fnc_EfM_populateTower : Non-existing unit tower %1 used!",_tower]] call NNS_fnc_debugOutput;};

[format["BIS_fnc_EfM_populateTower : %1",player distance2d _tower]] call NNS_fnc_debugOutput; //debug

// Tower direction
_dir = getDir _tower;

// 1st group - dir as tower
_grp01 = createGroup west;
_grp01 setFormDir _dir;

_pos01a = (AGLToASL (_tower buildingPos 2));
_pos01b = (AGLToASL (_tower buildingPos 14));

_unit01a = _grp01 createUnit [selectRandom ["B_Soldier_F","B_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["B_HeavyGunner_F","B_Soldier_AR_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01b setPosASL _pos01b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir} forEach [_unit01a,_unit01b];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

_grp01 enableDynamicSimulation true;

// 2nd group - dir as tower + 90
_grp02 = createGroup west;
_grp02 setFormDir (_dir + 90);

_pos02a = (AGLToASL (_tower buildingPos 7));
_pos02b = (AGLToASL (_tower buildingPos 11));

_unit02a = _grp02 createUnit ["B_Medic_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02a setPosASL _pos02a;
_unit02b = _grp02 createUnit ["B_Soldier_LAT_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02b setPosASL _pos02b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir (_dir + 90)} forEach [_unit02a,_unit02b];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp02);
//{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp02);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp02)};

_grp02 enableDynamicSimulation true;

// 3rd group - dir as tower + 180
_grp03 = createGroup west;
_grp03 setFormDir (_dir + 180);

_pos03a = (AGLToASL (_tower buildingPos 4));
_pos03b = (AGLToASL (_tower buildingPos 17));

_unit03a = _grp03 createUnit [selectRandom ["B_Soldier_F","B_Soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03a setPosASL _pos03a;
_unit03b = _grp03 createUnit [selectRandom ["B_Soldier_M_F","B_Sharpshooter_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03b setPosASL _pos03b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir (_dir + 180)} forEach [_unit03a,_unit03b];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp03);
//{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp03);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp03)};

_grp03 enableDynamicSimulation true;

// 4th group - dir as tower - 90
_grp04 = createGroup west;
_grp04 setFormDir (_dir - 90);

_pos04a = (AGLToASL (_tower buildingPos 8));
_pos04b = (AGLToASL (_tower buildingPos 15));

_unit04a = _grp04 createUnit [selectRandom ["B_Soldier_SL_F","B_Soldier_TL_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04a setPosASL _pos04a;
_unit04b = _grp04 createUnit ["B_Soldier_AA_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04b setPosASL _pos04b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir (_dir - 90)} forEach [_unit04a,_unit04b];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp04);
//{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp04);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp04)};

_grp04 enableDynamicSimulation true;

[[_grp01,_grp02,_grp03,_grp04]] call NNS_fnc_AInoPower; //NNS: powergrid off

[_tower,[_grp01,_grp02,_grp03,_grp04]] call NNS_fnc_CleanBuilding; //NNS: kill all units in group if buiding destroyed