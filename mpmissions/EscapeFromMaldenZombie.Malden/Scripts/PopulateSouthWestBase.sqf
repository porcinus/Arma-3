/*
NNS : Populate south west base (created from scratch)
*/

//NNS : advise player for ahead location
private _trigger = _this select 0;
private _triggerPos = getPos _trigger;
private _locationName = localize "STR_NNS_location_SouthWestBase"; //try to recover location name
_distance = round (_triggerPos vectorDistance (getPos player)); //marker length
[format[localize "STR_NNS_approachingLocation",[_locationName] call NNS_fnc_StringCapitalize,_distance]] remoteExec ["systemChat"];

//NNS : delete trigger
deleteVehicle _trigger;
//missionNamespace setVariable ["SouthWestBase_populated",true,true];

//Destroyed helicopter
_wreckHeliPos = [1610,1358,0];
_wreckHeli = "O_Heli_Light_02_unarmed_F" createVehicle [0,0,0]; //create helicopter
_wreckHeli setDamage [1, false]; //destroy helicopter
_wreckHeli setDir (random 360); //set helicopter direction
_wreckHeli setPos _wreckHeliPos; //set helicopter position
_wreckHeli setVectorUp surfaceNormal _wreckHeliPos;
_wreckHeli enableSimulation false; //disable simulation

// spawn refueler
southwestbase_refueler_0 = "O_Truck_03_fuel_F" createVehicle [1056,675,0]; southwestbase_refueler_0 setDir 132; //[[1056,675,0], 132, ["O_Truck_03_fuel_F"], [], 0.1 + (random 0.1), false, false, 0, 1, BIS_zombieSlowSoldiers, 10] call NNS_fnc_spawnCivVehi;
southwestbase_refueler_1 = "O_Truck_03_fuel_F" createVehicle [1976,2062,0]; southwestbase_refueler_0 setDir 165; //[[1976,2062,0], 165, ["O_Truck_03_fuel_F"], [], 0.1 + (random 0.1), false, false, 0, 1, BIS_zombieSlowSoldiers, 10] call NNS_fnc_spawnCivVehi;

// set random damage and fuel to refueler
{
	_x enableDynamicSimulation true;
	_x setFuel (0.1 + (random 0.1));
	[_x,["hitfuel"],0.2,0.6] call NNS_fnc_randomVehicleDamage;
	_x setFuelCargo 1;
} forEach [southwestbase_refueler_0, southwestbase_refueler_1];

//NNS : Damage vehicle
{
	[_x,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
	_x setFuel (random 0.05);
	_x setVehicleAmmo (0.05 + random 0.1);
	[_x,0,0,true] call NNS_fnc_AmmoboxLimiter;
} forEach [southwestbase_vehi_0, southwestbase_vehi_1, southwestbase_vehi_2];

//NNS : set fuel from escape vehicle
{_x setFuel 0;} forEach [BIS_EW09,BIS_EW10];

//NNS : Damage map buildings
[_triggerPos,500] call NNS_fnc_destroyZone;

sleep 2;

//NNS : Populate building / ammo box
_genUnits0 = southwestbase_tower_0 call NNS_fnc_populateTower_CSAT;
_genUnits1 = southwestbase_tower_1 call NNS_fnc_populateTower_CSAT;
_genUnits2 = southwestbase_tower_2 call NNS_fnc_populateTower_CSAT;
_genUnits3 = southwestbase_post_0 call NNS_fnc_populatePost_CSAT;
_genUnits4 = southwestbase_post_1 call NNS_fnc_populatePost_CSAT;
_genUnits5 = southwestbase_post_2 call NNS_fnc_populatePost_CSAT;
_genUnits6 = southwestbase_post_3 call NNS_fnc_populatePost_CSAT;
_genUnits7 = southwestbase_post_4 call NNS_fnc_populatePost_CSAT;
_genUnits8 = southwestbase_post_5 call NNS_fnc_populatePost_CSAT;
_allBaseUnit = _genUnits0+_genUnits1+_genUnits2+_genUnits3+_genUnits4+_genUnits5+_genUnits6+_genUnits7+_genUnits8;

_null = southwestbase_tower_0 call NNS_fnc_CargoTower_Equipments;
_null = southwestbase_tower_1 call NNS_fnc_CargoTower_Equipments;
_null = southwestbase_tower_2 call NNS_fnc_CargoTower_Equipments;
_null = southwestbase_hq_0 call NNS_fnc_CargoHQ_Equipments;
_null = southwestbase_hq_1 call NNS_fnc_CargoHQ_Equipments;

//NNS: create units
_grp01 = createGroup east;
_grp01Pos = [1553,1446,0];
_unit01a = _grp01 createUnit ["O_Soldier_SL_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit01b = _grp01 createUnit ["O_soldier_M_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit01c = _grp01 createUnit ["O_soldier_AR_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit01d = _grp01 createUnit ["O_soldier_GL_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit01e = _grp01 createUnit ["O_soldier_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit01f = _grp01 createUnit ["O_HeavyGunner_F", _grp01Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_grp01 enableDynamicSimulation true;
_grp01 deleteGroupWhenEmpty true;
_grp01 allowFleeing 0;
_allBaseUnit append [_unit01a,_unit01b,_unit01c,_unit01d,_unit01e,_unit01f];

_grp02 = createGroup east;
_grp02Pos = [1613,1416,0];
_unit02a = _grp02 createUnit ["O_Soldier_SL_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02b = _grp02 createUnit ["O_soldier_M_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02c = _grp02 createUnit ["O_soldier_AR_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02d = _grp02 createUnit ["O_soldier_GL_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02e = _grp02 createUnit ["O_soldier_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_unit02f = _grp02 createUnit ["O_HeavyGunner_F", _grp02Pos getPos [3 + random 3, random 360], [], 0, "CAN_COLLIDE"];
_grp02 enableDynamicSimulation true;
_grp02 deleteGroupWhenEmpty true;
_grp02 allowFleeing 0;
_allBaseUnit append [_unit02a,_unit02b,_unit02c,_unit02d,_unit02e,_unit02f];

//NNS: limit units abilities
{
	_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
	_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
	_x disableConversation true; //disable unit radio
	_x setSkill 0.4 + (random 0.2); //limit ability
} forEach _allBaseUnit;

//spawn flares
[_triggerPos, _allBaseUnit] spawn {
	_centerPos = _this select 0;
	_allBaseUnit = _this select 1;
	_unitsAlive = true;
	while {sleep (15 + random 20); _unitsAlive} do {
		for "_i" from 0 to (count _allBaseUnit) -1 do { //units loop
			_unit = _allBaseUnit select _i;
			if (alive _unit) then {_unit setUnitLoadout (configFile >> "CfgVehicles" >> typeOf _unit); //unit alive, refill ammo
			} else {_allBaseUnit set [_i, objNull];}; //replace unit by objNull
		};
		
		_allBaseUnit = _allBaseUnit arrayIntersect _allBaseUnit; //remove objNull from units array
		
		if !(sunOrMoon == 1) then { //moon time
			[_centerPos] remoteExec ["NNS_fnc_spawnFlare"]; //remoteexec flare
			sleep 25; //wait for the flare to die
		} else {sleep 60}; //long wait
		_tmpNearUnits = (_centerPos nearObjects ["Man", 70]) - allPlayers - agents; //detect man objects near position
		if ({alive _x} count _allBaseUnit == 0) then {_unitsAlive = false}; //no units alive, kill loop
	};
};

//NNS : Create civilian vehicle
_civVehiPos = [
[1477.06,1140.26,117.79]]; //[[x,y,dir],...]
{[[_x select 0,_x select 1],_x select 2] call NNS_fnc_spawnCivVehi;} forEach _civVehiPos;

//NNS : limit ammobox content
[southwestbase_ammo_0,0,0,true] call NNS_fnc_AmmoboxLimiter;
[southwestbase_ammo_1,0,0,true] call NNS_fnc_AmmoboxLimiter;
[southwestbase_ammo_2,0,0,true] call NNS_fnc_AmmoboxLimiter;

//NNS: Init zombie spawner
if (southwestbase_zombie_0 getVariable ["TotalAmount",-1] != -1) then {
	[] spawn {[southwestbase_zombie_0] call RyanZM_fnc_rzfunctionspawn;};
};

waitUntil {sleep 1; allPlayers findIf {_x distance2D _triggerPos < 45} != -1}; //wait until one player enter base

//NNS: create secondary objectives
_mrkRefueler0 = createMarker ["mrkRefueler0", getPos southwestbase_refueler_0];
_mrkRefueler0 setMarkerType "hd_unknown"; //"mrkRefueler0" setMarkerColor "ColorRed";

_mrkRefueler1 = createMarker ["mrkRefueler1", getPos southwestbase_refueler_1];
_mrkRefueler1 setMarkerType "hd_unknown"; //"mrkRefueler1" setMarkerColor "ColorRed";

[BIS_grpMain,["southwestbaserefueler","objEscape"],[localize "STR_NNS_Objective_desc",localize "STR_NNS_Objective_title",""],objNull,"ASSIGNED",1,true,"scout"] call BIS_fnc_taskCreate;

[_triggerPos,[southwestbase_refueler_0, southwestbase_refueler_1]] spawn {
	_pos = _this select 0; //trigger position
	_vehi_list = _this select 1; //recover vehicles list
	task_completed = false;
	while {!task_completed} do {
		sleep 5;
		if (_vehi_list findIf {_x distance2D _pos < 55} != -1) then {
			["southwestbaserefueler", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			task_completed = true;
		};
		
		if (!task_completed && {{alive _x} count _vehi_list == 0}) then {
			["southwestbaserefueler", "Failed"] remoteExec ["BIS_fnc_taskSetState",BIS_grpMain,true];
			task_completed = true;
		};
	};
};

//NNS: Pre escape zombie spawner
[_triggerPos,[southwestbase_refueler_0, southwestbase_refueler_1, BIS_EW09, BIS_EW10]] spawn {
	_pos = _this select 0;
	_vehi_list = _this select 1; //recover vehicles list
	southwestbase_refueler_0 = _vehi_list select 0; southwestbase_refueler_1 = _vehi_list select 1;
	waitUntil {sleep 1; allPlayers findIf {vehicle _x in _vehi_list} != -1 && [southwestbase_refueler_0, southwestbase_refueler_1] findIf {_x distance2D _pos < 150} != -1}; //wait until one player enter a vehicle in the list
	if (island_preescape_zombie_0 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_0] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_1 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_1] call RyanZM_fnc_rzfunctionspawn;};};
	if (island_preescape_zombie_2 getVariable ["TotalAmount",-1] != -1) then {[] spawn {[island_preescape_zombie_2] call RyanZM_fnc_rzfunctionspawn;};};
};
