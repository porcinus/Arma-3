/*
Populate Larche
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameCity"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Larche_populated",true,true];

// Empty vehicles
_car01 = "C_Van_01_transport_F" createVehicle [5894.62,8679.96,0];
_car01 setDir 280;
_car01 setPosATL [5894.62,8679.96,0];

_car02 = "C_SUV_01_F" createVehicle [6032.42,8611.68,0];
_car02 setDir 285;
_car02 setPosATL [6032.42,8611.68,0];

_car03 = "C_Offroad_01_F" createVehicle [6171.57,8678.86,0];
_car03 setDir 160;
_car03 setPosATL [6171.57,8678.86,0];

{
	clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1];
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
} forEach [_car01,_car02,_car03];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_null = larche_tower_0 call NNS_fnc_CargoTower_Equipments;

//NNS: Init zombie spawner
if (larche_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[larche_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
