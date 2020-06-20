// Params
private _heli = _this;
private _dir = getDir _heli;

[format["Paratroopers : _heli: %1 ,typeOf _heli: %2, %3m",_heli, typeOf _heli, player distance _heli]] call BIS_fnc_NNS_debugOutput; //debug

// Create paratroopers and let them chase players
_grp = createGroup west;
_grp setFormDir _dir;

_unit01 = _grp createUnit ["B_Soldier_SL_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit01 addBackpack "B_Parachute";
_unit01 action ["OpenParachute",_unit01];

_stalk = [_grp,group (allPlayers select 0)] spawn BIS_fnc_stalk;

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit02 = _grp createUnit ["B_soldier_M_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit02 addBackpack "B_Parachute";
_unit02 action ["OpenParachute",_unit02];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit03 = _grp createUnit ["B_soldier_AR_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit03 addBackpack "B_Parachute";
_unit03 action ["OpenParachute",_unit03];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit04 = _grp createUnit ["B_soldier_AR_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit04 addBackpack "B_Parachute";
_unit04 action ["OpenParachute",_unit04];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit05 = _grp createUnit ["B_Soldier_GL_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit05 addBackpack "B_Parachute";
_unit05 action ["OpenParachute",_unit05];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit06 = _grp createUnit ["B_soldier_LAT_F", [0,0,0], [], 0, "CAN_COLLIDE"];
removeBackpack _unit06;
_unit06 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit06 addBackpack "B_Parachute";
_unit06 action ["OpenParachute",_unit06];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit07 = _grp createUnit ["B_soldier_AA_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit07 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit07 addBackpack "B_Parachute";
_unit07 action ["OpenParachute",_unit07];

sleep 0.5;
if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

_unit08 = _grp createUnit ["B_HeavyGunner_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit08 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit08 addBackpack "B_Parachute";
_unit08 action ["OpenParachute",_unit08];

if !(typeOf _heli == "B_Heli_Transport_03_F") then { //NNS : not Huron, continue airdrop
	sleep 0.5;
	if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

	_unit09 = _grp createUnit ["B_Sharpshooter_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unit09 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
	_unit09 addBackpack "B_Parachute";
	_unit09 action ["OpenParachute",_unit09];

	sleep 0.5;
	if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

	_unit10 = _grp createUnit ["B_Soldier_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unit10 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
	_unit10 addBackpack "B_Parachute";
	_unit10 action ["OpenParachute",_unit10];

	sleep 0.5;
	if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

	_unit11 = _grp createUnit ["B_Soldier_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unit11 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
	_unit11 addBackpack "B_Parachute";
	_unit11 action ["OpenParachute",_unit11];

	sleep 0.5;
	if !(alive _heli) exitWith {_grp enableDynamicSimulation true;}; //NNS : stop is vehicle destroyed

	_unit12 = _grp createUnit ["B_Soldier_F", [0,0,0], [], 0, "CAN_COLLIDE"];
	_unit12 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
	_unit12 addBackpack "B_Parachute";
	_unit12 action ["OpenParachute",_unit12];

	sleep 2;
	if (alive _heli) then {_heli animateDoor ["Door_1_source",0,false];};
};

// Don't limit their equipment - they're fresh units
// if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)};
_grp enableDynamicSimulation true;


/*
waitUntil {sleep 5; ({(_x distance (leader _grp)) < (1500)} count (allPlayers) == 0)};
{deleteVehicle _x} forEach (units _grp);
deleteGroup _grp;
*/
