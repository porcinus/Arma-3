/*
Populate Cancon
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Chapoi_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

//NNS : Create civilian vehicle
_civVehiPos = [
[5530.66,11179.87,26.93],
[5559.38,11180.58,102.16]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (lolisse_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[lolisse_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
