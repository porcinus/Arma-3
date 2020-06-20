/*
Populate Communication Station
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameLocal"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["CommStation_populated",true,true];

//NNS : Damage vehicle
[commstation_vehi_0,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
commstation_vehi_0 setFuel (random 0.05);

//NNS : limit ammobox content
[commstation_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[commstation_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[commstation_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: Init zombie spawner
if (commstation_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[commstation_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
