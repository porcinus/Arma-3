/*
Populate Pessagne
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameCity"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Pessagne_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS : Populate building / ammo box
_null = pessagne_tower_0 call NNS_fnc_CargoTower_Equipments;

//NNS : limit ammobox content
[pessagne_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS : Create civilian vehicle
_civVehiPos = [
[3123.49,6316.77,100.50],
[3171.88,6336.65,188.47],
[3215.45,6291.06,11.32]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (pessagne_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[pessagne_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
