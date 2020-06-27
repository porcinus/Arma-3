/*
Populate the harbour in Le Port
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Harbor_populated",true,true];

// Empty vehicles
_boat01 = "C_Rubberboat" createVehicle [8495.92,3797.15,6.1];
_boat01 setDir 6.5;
_boat01 setPosATL [8495.92,3797.15,6.1];

_boat03 = "C_Rubberboat" createVehicle [8499.44,3857.12,2.5];
_boat03 setDir 95;
_boat03 setPosATL [8499.44,3857.12,2.5];

_boat02 = "C_Rubberboat" createVehicle [9294.75,3872.42,4.55];
_boat02 setDir 165;
_boat02 setPosATL [9294.75,3872.42,4.55];

{
	clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x;
	_x setFuel 0.135;
	_x enableDynamicSimulation true;
	_x allowDamage false;
} forEach [_boat01,_boat02,_boat03];

//NNS : Damage map buildings
[_triggerPos,700] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_null = harbor_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = harbor_tower_1 call NNS_fnc_CargoTower_Equipments;

//NNS : Create civilian vehicle
_civVehiPos = [
[7547.31,3851.23,304.85],
[8003.74,4066.98,213.43],
[8206.10,3883.26,241.12],
[8436.65,3849.36,269.58],
[8289.35,2891.78,53.71],
[7807.17,3155.89,121.63],
[7831.74,3134.12,346.28]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (harbor_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[harbor_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

if (harbor_zombie_1 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[harbor_zombie_1] call RyanZM_fnc_rzfunctionspawn;};
};
