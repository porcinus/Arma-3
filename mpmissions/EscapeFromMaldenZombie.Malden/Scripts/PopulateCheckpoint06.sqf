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
//missionNamespace setVariable ["Checkpoint06_populated",true,true];

//NNS : limit ammobox content
[checkpoint_06_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//Vehicles
checkpoint_06_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_06_vehi_0 setDir 307.8;
checkpoint_06_vehi_0 setPos [2169.64,2744.24,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_06_vehi_0];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;
