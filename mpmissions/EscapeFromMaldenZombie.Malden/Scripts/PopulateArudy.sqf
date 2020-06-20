/*
Populate Arudy
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Arudy_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building
_null = arudy_tower_0 call NNS_fnc_CargoTower_Equipments;

{ // set random damage and fuel to tanks/truck
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [arudy_vehi_0];

//NNS: Init zombie spawner
if (arudy_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[arudy_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

//NNS : limit ammobox content
[arudy_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
