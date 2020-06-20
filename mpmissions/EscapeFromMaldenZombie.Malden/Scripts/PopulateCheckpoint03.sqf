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
//missionNamespace setVariable ["Checkpoint03_populated",true,true];

//Vehicles
checkpoint_03_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_03_vehi_0 setDir 192.3;
checkpoint_03_vehi_0 setPos [4721.77,6674.68,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_03_vehi_0];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: spawn civilian vehicles
[[4690,6621,0],10,true] call NNS_fnc_spawnVehicleOnRoad;

//NNS : Create civilian vehicle
_civVehiPos = [
[4649.93,6530.77,225.92],
[4753.08,6744.25,280.56]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;
