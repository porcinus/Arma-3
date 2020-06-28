/*
NNS
Populate bag bunker tower with 2 NATO units

Example: _null = bunker1 call NNS_fnc_Populate_BagBunkerTower;

*/

// Params
params
[
	["_bunker",objNull,[objNull]]
];

// Check for validity
if (isNull _tower) exitWith {[format["NNS_fnc_Populate_BagBunkerTower : Non-existing unit tower %1 used!",_tower]] call NNS_fnc_debugOutput;};

[format["NNS_fnc_Populate_BagBunkerTower : %1",player distance2d _bunker]] call NNS_fnc_debugOutput; //debug

_pos = getPos _bunker; 
_dir = getDir _bunker;

_grp01 = createGroup west;

_pos01a = _pos getPos [-2.1,_dir];
_pos02a = _pos getPos [-2.6,_dir]; _pos02a = [_pos02a select 0, _pos02a select 1, (_pos select 2) + 2.8];

if (_dir>=180) then { _dir = _dir - 180;}else{_dir = _dir + 180;}; //reverse heading
_grp01 setFormDir _dir; //group heading

_unit01a = _grp01 createUnit [selectRandom ["B_HeavyGunner_F","B_Soldier_LAT_F"], _pos01a, [], 0, "CAN_COLLIDE"]; // _unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["B_Sharpshooter_F","B_Soldier_M_F"], _pos02a, [], 0, "CAN_COLLIDE"]; //_unit01b setPosASL _pos01b;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir} forEach [_unit01a,_unit01b];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.3]} forEach (units _grp01);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

_grp01 enableDynamicSimulation true;
