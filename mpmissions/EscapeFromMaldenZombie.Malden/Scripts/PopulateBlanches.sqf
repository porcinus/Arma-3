/*
Populate the Villa
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, ""]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["CacheVilla_populated",true,true];

//NNS : limit ammobox content
[villa_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

// Empty vehicles
_lsv = "O_LSV_02_armed_F" createVehicle [5012.8,4007.76,0];
_lsv setDir 215;
_lsv setPosATL [5012.8,4007.76,0];

{
	clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1];
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [_lsv];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS: Init zombie spawner
if (villa_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[villa_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
