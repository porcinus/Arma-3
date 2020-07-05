/*
NNS
Populate cargo HQ with 4 CSAT units

Example: _null = cargohq1 call NNS_fnc_populateCargoHQ_Nato;
*/

// Params
params [
	["_building",objNull,[objNull]]
];

// Check for validity
if (isNull _building) exitWith {[format["NNS_fnc_populateCargoHQ_Nato : Non-existing unit cargohq %1 used!",_building]] call NNS_fnc_debugOutput; []};
if (damage _building > 0.99) exitWith {["NNS_fnc_populateCargoHQ_Nato : HQ is almost destroyed!"] call NNS_fnc_debugOutput; []};

[format["NNS_fnc_populateCargoHQ_Nato : %1",player distance2d _building]] call NNS_fnc_debugOutput; //debug

_dir = getDir _building;

_grp01 = createGroup west;
_grp01 setFormDir _dir;

_pos01a = (AGLToASL (_building buildingPos 0));
_pos01b = (AGLToASL (_building buildingPos 4));
_pos01c = (AGLToASL (_building buildingPos 5));
_pos01d = (AGLToASL (_building buildingPos 6));

_unit01a = _grp01 createUnit [selectRandom ["B_Soldier_SL_F","B_soldier_M_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01a setPosASL _pos01a;
_unit01b = _grp01 createUnit [selectRandom ["B_soldier_AR_F","B_soldier_GL_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01b setPosASL _pos01b;
_unit01c = _grp01 createUnit [selectRandom ["B_medic_F","B_HeavyGunner_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01c setPosASL _pos01c;
_unit01d = _grp01 createUnit [selectRandom ["B_soldier_GL_F","B_soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01d setPosASL _pos01d;

_allReturnUnits = [_unit01a,_unit01b,_unit01c,_unit01d];

{
	_x setUnitPos "Up";
	_x disableAI "Path";
	_x setDir _dir;
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x enableGunLights "forceOn"; //turn on flashlight
	[_x] call NNS_fnc_AIskill;
	if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {_x execVM "Scripts\LimitEquipment.sqf"};
} forEach _allReturnUnits;

if (missionNamespace getVariable ["BIS_LimitEnemyCount",false]) then {
	for "_i" from 0 to round ((count _allReturnUnits) / 2) do {
		_rnd = random ((count _allReturnUnits) - 1);
		_unit = _allReturnUnits select _rnd;
		deleteVehicle _unit;
		_allReturnUnits set [_rnd, objNull];
	};
	_allReturnUnits = _allReturnUnits arrayIntersect _allReturnUnits; //remove objNull from units array
};

_grp01 enableDynamicSimulation true;
_grp01 allowFleeing 0;
_grp01 enableGunLights "forceOn"; //turn on flashlight

[_building,[_grp01]] call NNS_fnc_CleanBuilding;

//return units created
_allReturnUnits