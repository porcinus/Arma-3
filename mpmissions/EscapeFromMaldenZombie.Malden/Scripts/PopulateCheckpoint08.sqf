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
//missionNamespace setVariable ["NNSCheckpoint02_populated",true,true];

//Vehicles
checkpoint_08_vehi_0 = (selectRandom BIS_csatVehicles) createVehicle [0,0,0];
checkpoint_08_vehi_0 setDir 50.3;
checkpoint_08_vehi_0 setPos [7543.36,4866.55,0];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [checkpoint_08_vehi_0,checkpoint_08_vehi_1,checkpoint_08_vehi_2];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building
_null = checkpoint_08_hq_0 call NNS_fnc_CargoHQ_Equipments;

//NNS : limit ammobox content
[checkpoint_08_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_08_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_08_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;
[checkpoint_08_ammo_3,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: Init zombie spawner
if (checkpoint_08_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[checkpoint_08_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

//NNS: spawn civilian vehicles
[[7515,4922,0],10,0] call NNS_fnc_spawnVehicleOnRoad;

//NNS : Create civilian vehicle
_civVehiPos = [
[7628,4834,35.56],
[7629.12,4802.71,313.18]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;
