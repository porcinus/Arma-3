/*
Populate East Old Base
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = localize "STR_NNS_Escape_location_EastOldBase"; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["EastOldBase_populated",true,true];

{ // set random damage and fuel to tanks/truck
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.9] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [eastoldbase_vehi_0, eastoldbase_vehi_1, eastoldbase_vehi_2];

//NNS : limit ammobox content
[eastoldbase_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[eastoldbase_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[eastoldbase_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;
