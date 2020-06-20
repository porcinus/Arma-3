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
//missionNamespace setVariable ["NNSCheckpoint01_populated",true,true];

//Vehicles
checkpoint_07_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_07_vehi_0 setDir 181.7;
checkpoint_07_vehi_0 setPos [6276.39,3553.15,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_07_vehi_0,checkpoint_07_vehi_1,checkpoint_07_vehi_2,checkpoint_07_vehi_3];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_null = checkpoint_07_hq_0 call NNS_fnc_CargoHQ_Equipments;

//NNS : limit ammobox content
[checkpoint_07_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_07_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_07_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_07_ammo_3,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: Init zombie spawner
if (checkpoint_07_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[checkpoint_07_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

//NNS: spawn civilian vehicles
[[6250,3535,0],10,180] call NNS_fnc_spawnVehicleOnRoad;
