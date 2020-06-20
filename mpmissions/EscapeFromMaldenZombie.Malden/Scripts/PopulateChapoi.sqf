/*
Populate Chapoi
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameCity"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Chapoi_populated",true,true];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_null = chapoi_tower_0 call NNS_fnc_CargoTower_Equipments;

//NNS: Init zombie spawner
if (chapoi_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[chapoi_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
