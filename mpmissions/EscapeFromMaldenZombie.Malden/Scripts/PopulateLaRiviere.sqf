/*
Populate La Riviere
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["LaRiviere_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS : limit ammobox content
[lariviere_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS : Create civilian vehicle
_civVehiPos = [
[3628.15,3298.23,181.75],
[3631.99,3226.74,14.79],
[3736.13,3163.38,81.33],
[3764.28,3163.60,259.75],
[3740.03,3107.18,56.53]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (lariviere_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[lariviere_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
