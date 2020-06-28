/*
NNS
Populate cargo HQ with 4 extra NATO units

Example: _null = cargohq1 call NNS_fnc_Populate_CargoHQ_More;

*/

// Params
params
[
	["_building",objNull,[objNull]]
];

// Check for validity
if (isNull _building) exitWith {[format["NNS_fnc_Populate_CargoHQ_More : Non-existing unit cargohq %1 used!",_building]] call NNS_fnc_debugOutput;};

[format["NNS_fnc_Populate_CargoHQ_More : %1",player distance2d _building]] call NNS_fnc_debugOutput; //debug

_dir = getDir _building;

_grp01 = createGroup west;
_grp01 setFormDir _dir;

_pos01a = (AGLToASL (_building buildingPos 1));
_pos01b = (AGLToASL (_building buildingPos 2));
_pos01c = (AGLToASL (_building buildingPos 3));
_pos01d = (AGLToASL (_building buildingPos 7));

_unit01a = _grp01 createUnit [selectRandom ["B_Soldier_SL_F","B_Soldier_TL_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["B_Sharpshooter_F","B_Soldier_M_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01b setPosASL _pos01b;
_unit01c = _grp01 createUnit [selectRandom ["B_Soldier_LAT_F","B_Soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01c setPosASL _pos01c;
_unit01d = _grp01 createUnit [selectRandom ["B_HeavyGunner_F","B_Soldier_LAT_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01d setPosASL _pos01d;

{_x setUnitPos "Up"; _x disableAI "Path"; _x setDir _dir} forEach [_unit01a,_unit01b,_unit01c,_unit01d];
{[_x,"limited"] call NNS_fnc_AIskill;} forEach (units _grp01);
//{_x setSkill ["AimingAccuracy",0.1]} forEach (units _grp01);
if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp01)};

_grp01 enableDynamicSimulation true;
