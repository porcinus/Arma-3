/*
Populate Military Airbase
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = text nearestLocation [_triggerPos, "NameVillage"]; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_Escape_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["Airbase_populated",true,true];

_escapeVehi = [BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

// Empty vehicles
_kamysh = createVehicle ["O_APC_Tracked_02_cannon_F", [8032.37,10018.10,0], [], 0, "NONE"]; _kamysh setDir 0;
_tigris = createVehicle ["O_APC_Wheeled_02_rcws_v2_F", [7999.55,10069.1,0], [], 0, "NONE"]; _tigris setDir 270;



{ // set random damage and fuel to vehicles
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [_kamysh,_tigris];

{ // set random damage and fuel to refueler
	_x enableDynamicSimulation true;
	[_x,["hitfuel"],0.2,0.6] call NNS_fnc_randomVehicleDamage;
	_x setFuel (0.1 + (random 0.1));
	_x setFuelCargo 1;
} forEach [airbase_refueler_0, airbase_refueler_1, airbase_refueler_2];

//destroy a random heli
for "_i" from 1 to 2 do {
	_rndDestroy = selectRandom _escapeVehi;
	_escapeVehi deleteAt (_escapeVehi find _rndDestroy);
	_rndDestroy setDamage [1, false];
};

//NNS : set fuel from escape vehicle
{_x setFuel 0.015;} forEach _escapeVehi;

//NNS : Populate building
_null = airbase_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = airbase_tower_1 call NNS_fnc_CargoTower_Equipments;

//NNS : limit ammobox content
[airbase_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS : Create civilian vehicle
_civVehiPos = [
[8148.98,10015.41,181.45],
[8024.48,9836.38,289.012],
[8103.14,9763.01,268.96],
[8115.82,9737.14,86.34]]; //[[x,y,dir],...]

{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS: Init zombie spawner
if (airport_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[airport_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

//NNS: Pre escape zombie spawner
[[airbase_refueler_0, airbase_refueler_1, airbase_refueler_2, BIS_EW01, BIS_EW02, BIS_EW03, BIS_EW04, BIS_EW05]] spawn {
	_vehi_list = _this select 0; //recover vehicles list
	waitUntil {sleep 1; allPlayers findIf {vehicle _x in _vehi_list} != -1}; //wait until one player enter a vehicle in the list
	if (island_preescape_zombie_0 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_0] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_1 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_1] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_2 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_2] call RyanZM_fnc_rzfunctionspawn;};};
};
