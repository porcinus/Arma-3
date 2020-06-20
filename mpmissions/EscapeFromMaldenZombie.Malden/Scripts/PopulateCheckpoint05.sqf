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
//missionNamespace setVariable ["Checkpoint05_populated",true,true];

//NNS : limit ammobox content
[checkpoint_05_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: spawn civilian vehicles
[[7850,9316,0],10,180] call NNS_fnc_spawnVehicleOnRoad;

//NNS : Create civilian vehicle
_civVehiPos = [
[7656.90,9288.39,17.87]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;
