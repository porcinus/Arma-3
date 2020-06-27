/*
Populate Military island
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameLocal"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Island_populated",true,true];

{ //NNS : Damage vehicle
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [island_vehi_0, island_vehi_1];

{ // set random damage and fuel to refueler
	_x enableDynamicSimulation true;
	_x setFuel (0.1 + (random 0.1));
	[_x,["hitfuel"],0.2,0.6] call NNS_fnc_randomVehicleDamage;
	_x setFuelCargo 1;
} forEach [island_refueler_0, island_refueler_1];

//NNS : set fuel from escape vehicle
{_x setFuel 0.015;} forEach [BIS_EW06,BIS_EW07];

//NNS : Damage map buildings
[_triggerPos,600] call NNS_fnc_destroyZone;

//NNS : Populate building / ammo box
_null = island_tower_0 call NNS_fnc_CargoTower_Equipments;

//NNS : limit ammobox content
[island_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS : Create civilian vehicle
_civVehiPos = [
[10079.84,3985.53,3.59]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (island_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[island_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

//NNS: Pre escape zombie spawner
[[island_refueler_0, island_refueler_1, BIS_EW06, BIS_EW07]] spawn {
	_vehi_list = _this select 0; //recover vehicles list
	waitUntil {sleep 1; allPlayers findIf {vehicle _x in _vehi_list} != -1}; //wait until one player enter a vehicle in the list
	if (island_preescape_zombie_0 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_0] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_1 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_1] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_2 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_2] call RyanZM_fnc_rzfunctionspawn;};};
};
