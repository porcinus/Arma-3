/*
Populate small base at the Military island
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameLocal"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Base_populated",true,true];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [base_vehi_0, base_vehi_1];

{ // set random damage and fuel to refueler
	_x enableDynamicSimulation true;
	_x setFuel (0.1 + (random 0.1));
	[_x,["hitfuel"],0.2,0.6] call NNS_fnc_randomVehicleDamage;
	_x setFuelCargo 1;
} forEach [base_refueler_0, base_refueler_1];

//NNS : set fuel from escape vehicle
{_x setFuel 0.015;} forEach [BIS_EW08];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: Init zombie spawner
if (base_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[base_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
