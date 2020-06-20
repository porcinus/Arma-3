/*
Populate Checkpoint
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[localize "STR_A3_escape_marker_checkpoint"] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint02_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building
_null = checkpoint_02_tower_0 call NNS_fnc_CargoTower_Equipments;

//NNS : limit ammobox content
[checkpoint_02_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: spawn civilian vehicles
[[7444,3793,0],10] call NNS_fnc_spawnVehicleOnRoad;
