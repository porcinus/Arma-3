// Params
private _heli = _this;
private _dir = getDir _heli;

// Create paratroopers and let them chase players
_grp = createGroup east;
_grp setFormDir _dir;

_unit01 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit01 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit01 action ["OpenParachute",_unit01];

_stalk = [_grp,group (allPlayers select 0)] spawn BIS_fnc_stalk;

sleep 0.5;

_unit02 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit02 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit02 action ["OpenParachute",_unit02];

sleep 0.5;

_unit03 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit03 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit03 action ["OpenParachute",_unit03];

sleep 0.5;

_unit04 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit04 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit04 action ["OpenParachute",_unit04];

sleep 0.5;

_unit05 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit05 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit05 action ["OpenParachute",_unit05];

sleep 0.5;

_unit06 = _grp createUnit ["O_T_Soldier_PG_F", [0,0,0], [], 0, "CAN_COLLIDE"];
_unit06 setPosASL [(getPosASL _heli select 0), (getPosASL _heli select 1), (getPosASL _heli select 2) - 5];
_unit06 action ["OpenParachute",_unit06];

if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _grp)};
_grp enableDynamicSimulation true;

WaitUntil {sleep 5; ({(_x distance (leader _grp)) < (1500)} count (BIS_playableUnits) == 0)};
{deleteVehicle _x} forEach (units _grp);
deleteGroup _grp;
