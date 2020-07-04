/*
NNS, original from 'Escape from Malden'
Populate guard post with 2 CSAT units

Example: _null = post call NNS_fnc_populatePost_Csat;
*/

// Params
params [
	["_post",objNull,[objNull]]
];

// Check for validity
if (isNull _post) exitWith {[format["NNS_fnc_populatePost_Csat : Non-existing post %1 used!",_post]] call NNS_fnc_debugOutput; []};
if !(alive _post) exitWith {["NNS_fnc_populatePost_Csat : Guard post is destroyed!"] call NNS_fnc_debugOutput; []};

[format["NNS_fnc_populatePost_Csat : %1",player distance2d _post]] call NNS_fnc_debugOutput; //debug

// Create group on the post
_grp01 = createGroup east;
_grp01 setFormDir ((getDir _post) - 180);

_pos01 = _post getRelPos [2,135];
_pos01 set [2, ((getPosASL _post select 2) + 4.4)];
_pos02 = _post getRelPos [2,225];
_pos02 set [2, ((getPosASL _post select 2) + 4.4)];

_unit01 = _grp01 createUnit [selectRandom ["O_soldier_GL_F","O_HeavyGunner_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01 setPosASL _pos01;
_unit02 = _grp01 createUnit [selectRandom ["O_soldier_F","O_soldier_AR_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit02 setPosASL _pos02;

{
	_x setUnitPos "Up";
	_x disableAI "Path";
	_x setDir ((getDir _post) - 180);
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x enableGunLights "forceOn"; //turn on flashlight
	[_x] call NNS_fnc_AIskill;
	if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {_x execVM "Scripts\LimitEquipment.sqf"};
} forEach [_unit01,_unit02];

_grp01 enableDynamicSimulation true;
_grp01 allowFleeing 0;
_grp01 enableGunLights "forceOn"; //turn on flashlight

[_post,[_grp01]] call NNS_fnc_CleanBuilding;

//return units created
[_unit01,_unit02]