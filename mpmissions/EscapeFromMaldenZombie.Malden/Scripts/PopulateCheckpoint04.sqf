/*
Populate Checkpoint
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[localize "STR_A3_escape_marker_checkpoint"] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Checkpoint04_populated",true,true];

//NNS : limit ammobox content
[checkpoint_04_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//Vehicles
checkpoint_04_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_04_vehi_0 setDir 0.5;
checkpoint_04_vehi_0 setPos [5248.02,9206.61,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_04_vehi_0];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: spawn civilian vehicles
[[5209,9195,0],10,true] call NNS_fnc_spawnVehicleOnRoad;

//NNS : Create civilian vehicle
_civVehiPos = [
[5100.03,9046.02,153.77],
[5131.56,9082.12,62.75]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;
