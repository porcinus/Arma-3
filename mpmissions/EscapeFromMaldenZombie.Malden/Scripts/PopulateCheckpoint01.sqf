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
//missionNamespace setVariable ["Checkpoint01_populated",true,true];

//NNS : Populate building / ammo box
BIS_CSAT_Box_01 call BIS_fnc_EfM_ammoboxCSAT;

//Vehicles
checkpoint_01_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_01_vehi_0 setDir 58.5;
checkpoint_01_vehi_0 setPos [3965.34,4533.66,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_01_vehi_0];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: spawn civilian vehicles
[[3962,4565,0],10] call NNS_fnc_spawnVehicleOnRoad;

//NNS : Create civilian vehicle
_civVehiPos = [
[3948.35,4700.43,239.61]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;
