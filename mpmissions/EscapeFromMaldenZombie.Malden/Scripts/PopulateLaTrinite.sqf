/*
Populate La Trinite
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameCityCapital"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["LaTrinite_populated",true,true];

// Empty vehicles
_car01 = "C_Hatchback_01_F" createVehicle [7155.36,7738.72,0];
_car01 setDir 247;
_car01 setPosATL [7155.36,7738.72,0];

_car02 = "C_Truck_02_covered_F" createVehicle [7229.8,8166.09,0];
_car02 setDir 49;
_car02 setPosATL [7229.8,8166.09,0];

_car03 = "C_Offroad_01_F" createVehicle [7252.49,7934.37,0];
_car03 setDir 270;
_car03 setPosATL [7252.49,7934.37,0];

{
	clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x; _x addItemCargoGlobal ["FirstAidKit",1];
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
} forEach [_car01,_car02,_car03];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [latrinite_vehi_0];

//NNS : Damage map buildings
[_triggerPos,650] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_null = latrinite_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = latrinite_tower_1 call NNS_fnc_CargoTower_Equipments;
_null = latrinite_tower_2 call NNS_fnc_CargoTower_Equipments;

//NNS: Init zombie spawner
if (latrinite_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[latrinite_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};
