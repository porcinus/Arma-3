/*
NNS
Populate bag bunker tower with 2 CSAT units

Example: _null = bunker1 call NNS_fnc_populateBagBunkerTower_Csat;

*/

// Params
params [
	["_bunker",objNull,[objNull]]
];

// Check for validity
if (isNull _bunker) exitWith {[format["NNS_fnc_populateBagBunkerTower_Csat : Non-existing unit bunker %1 used!",_tower]] call NNS_fnc_debugOutput;};
if (damage _bunker > 0.99) exitWith {["NNS_fnc_populateTower_Nato : Bunker is almost destroyed!"] call NNS_fnc_debugOutput; []};

[format["NNS_fnc_populateBagBunkerTower_Csat : %1",player distance2d _bunker]] call NNS_fnc_debugOutput; //debug

_pos = getPos _bunker; 
_dir = getDir _bunker;

_grp01 = createGroup east;

_pos01a = _pos getPos [-2.1,_dir];
_pos02a = _pos getPos [-2.6,_dir]; _pos02a = [_pos02a select 0, _pos02a select 1, (_pos select 2) + 2.8];

if (_dir>=180) then { _dir = _dir - 180;}else{_dir = _dir + 180;}; //reverse heading
_grp01 setFormDir _dir; //group heading

_unit01a = _grp01 createUnit [selectRandom ["O_HeavyGunner_F","O_soldier_F"], _pos01a, [], 0, "CAN_COLLIDE"]; // _unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["O_soldier_AR_F","O_soldier_GL_F"], _pos02a, [], 0, "CAN_COLLIDE"]; //_unit01b setPosASL _pos01b;

{
	_x setUnitPos "Up";
	_x disableAI "Path";
	_x setDir _dir;
	[_x] call NNS_fnc_AIskill;
	if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {_x execVM "Scripts\LimitEquipment.sqf"};
} forEach [_unit01a,_unit01b];

_grp01 enableDynamicSimulation true;

[_bunker,[_grp01]] call NNS_fnc_CleanBuilding;

//return units created
[_unit01a,_unit01b]