/*
NNS
Populate cargo HQ with 4 CSAT units

Example: _null = cargohq1 call NNS_fnc_populateCargoHQ_CSAT;
*/

// Params
params [
	["_building",objNull,[objNull]]
];

// Check for validity
if (isNull _building) exitWith {[format["NNS_fnc_populateCargoHQ_CSAT : Non-existing unit cargohq %1 used!",_building]] call NNS_fnc_debugOutput; []};
if !(alive _building) exitWith {["NNS_fnc_populateCargoHQ_CSAT : HQ is destroyed!"] call NNS_fnc_debugOutput; []};

[format["NNS_fnc_populateCargoHQ_CSAT : %1",player distance2d _building]] call NNS_fnc_debugOutput; //debug

_dir = getDir _building;

_grp01 = createGroup east;
_grp01 setFormDir _dir;

_pos01a = (AGLToASL (_building buildingPos 0));
_pos01b = (AGLToASL (_building buildingPos 4));
_pos01c = (AGLToASL (_building buildingPos 5));
_pos01d = (AGLToASL (_building buildingPos 6));

_unit01a = _grp01 createUnit [selectRandom ["O_Soldier_SL_F","O_soldier_M_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["O_soldier_AR_F","O_soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01b setPosASL _pos01b;
_unit01c = _grp01 createUnit [selectRandom ["O_medic_F","O_HeavyGunner_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01c setPosASL _pos01c;
_unit01d = _grp01 createUnit [selectRandom ["O_soldier_GL_F","O_soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01d setPosASL _pos01d;

{
	_x setUnitPos "Up";
	_x disableAI "Path";
	_x setDir _dir;
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x enableGunLights "forceOn"; //turn on flashlight
} forEach [_unit01a,_unit01b,_unit01c,_unit01d];

_grp01 enableDynamicSimulation true;
_grp01 allowFleeing 0;
_grp01 enableGunLights "forceOn"; //turn on flashlight

//return units created
[_unit01a,_unit01b,_unit01c,_unit01d]