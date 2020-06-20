if (isNil {missionNamespace getVariable "DebugMenu_level"}) then {missionNamespace setVariable ["DebugMenu_level","none",true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_enable"}) then {missionNamespace setVariable ["DebugOutputs_enable",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Chatbox"}) then {missionNamespace setVariable ["DebugOutputs_Chatbox",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Logs"}) then {missionNamespace setVariable ["DebugOutputs_Logs",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "Debug_Win"}) then {missionNamespace setVariable ["Debug_Win",false,true];}; //force win

// Definitions of vehicles and groups to be spawned
BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];
//BIS_supportVehicles = ["C_Van_01_fuel_F","C_Truck_02_fuel_F","C_Offroad_01_repair_F"];
BIS_csatVehicles = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_v2_F","O_APC_Tracked_02_cannon_F","O_LSV_02_armed_F","O_LSV_02_unarmed_F"];
BIS_csatGroups = ["OIA_InfTeam"];

BIS_zombieSlowSoldiers = ["RyanZombieB_Soldier_02_fslow","RyanZombieB_Soldier_02_f_1slow","RyanZombieB_Soldier_02_f_1_1slow","RyanZombieB_Soldier_03_fslow","RyanZombieB_Soldier_03_f_1slow","RyanZombieB_Soldier_03_f_1_1slow","RyanZombieB_Soldier_04_fslow","RyanZombieB_Soldier_04_f_1slow","RyanZombieB_Soldier_04_f_1_1slow"];
BIS_zombieSlowCivilians = ["RyanZombie15slow","RyanZombie16slow","RyanZombie17slow","RyanZombie18slow","RyanZombie19slow","RyanZombie20slow","RyanZombie21slow","RyanZombie22slow","RyanZombie23slow","RyanZombie24slow","RyanZombie25slow","RyanZombie26slow","RyanZombie27slow","RyanZombie28slow","RyanZombie29slow","RyanZombie30slow","RyanZombie31slow","RyanZombie32slow"];

// Fuel canister data
missionNamespace setVariable ["BIS_FuelCanisterCap",12.5,true]; //capacity in "liter"
missionNamespace setVariable ["BIS_FuelCanisterRatio",0.5,true]; //game unit to "liter" ratio

//missionNamespace setVariable ["genSpw",0,true];

//NNS : Add random respawn position
_start_pos_list = [];
for "_i" from 0 to 100 do { //detect from marker_objective_0 to marker_objective_100
	_tmpname = format ["respawn_%1", _i]; //parse marker name
	if (getMarkerColor _tmpname != "") then { //marker exist
		_start_pos_list append [_tmpname]; //add marker to array
		//[east,_tmpname,_tmpname] call BIS_fnc_addRespawnPosition; //debug, add all respawn
	};
};

_start_pos_rnd = _start_pos_list call BIS_fnc_selectRandom; //select random marker
"marker_0" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
"marker_respawn" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
{
_x setpos ((getMarkerPos "marker_0") getPos [5, random 360]);
_x enableGunLights "forceOn"; _x action ["GunLightOn", _x]; //try to force light on
} forEach (units BIS_grpMain); //move all base units to respawn location
[east,"marker_respawn","Respawn"] call BIS_fnc_addRespawnPosition; //add respawn point

//NNS : Add crashed helicopter near initial spawn
[] spawn {
	_heliCraterPos = [(getMarkerPos "marker_0"), 30, 50, 4, 0, 0.5, 0] call BIS_fnc_findSafePos; //select safe place under 50m, random direction
	if (((getMarkerPos "marker_0") distance2D _heliCraterPos) > 55) then {_heliCraterPos = (getMarkerPos "marker_0") getPos [random 40, random 360];}; //BIS_fnc_findSafePos failed
	
	{_x hideObjectGlobal true;} foreach (_heliCraterPos nearObjects ["House", 30]); //hide object around crash site

	_wreckHeliDir = random 360; //helicopter direction
	_wreckHeliPos = _heliCraterPos getPos [-2, _wreckHeliDir]; //helicopter position, offset from crater
	_wreckHeliPos set [2, (_wreckHeliPos select 2) - 0.5]; //helicopter position, Z offset
	
	_heliCrater = "CraterLong" createVehicle [0,0,0]; //create crater
	_heliCrater setDir _wreckHeliDir; //set crater direction
	_heliCrater setPos _heliCraterPos; //set crater position
	_heliCrater setVectorUp surfaceNormal _heliCraterPos;
	
	_wreckHeli = "O_Heli_Light_02_unarmed_F" createVehicle [0,0,0]; //create helicopter
	_wreckHeli setDamage [1, false]; //destroy helicopter
	_wreckHeli setDir _wreckHeliDir; //set helicopter direction
	_wreckHeli setPos _wreckHeliPos; //set helicopter position
	_wreckHeli setVectorUp surfaceNormal _wreckHeliPos;
	_wreckHeli enableSimulation false; //disable simulation
	
	waitUntil {sleep 1; {alive _x} count allPlayers == (count allPlayers)}; //wait until all player are alive, here to allow fire sound to work on all clients
	[_heliCrater, 500, false, true] remoteExec ["NNS_fnc_spawnBigFire",0,true]; //remoteexec fire
};

 //NNS: Original rules -> Remove respawn after 5min
if (BIS_EscapeRules == 0) then {
	[] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; allPlayers findIf {alive _x} != -1}; //check if at least one player alive
		deleteMarker "marker_respawn"; //remove respawn
	};
};

//NNS : delete all vehicles near respawn
_vehicle_near_respawn = (getMarkerPos "marker_respawn") nearObjects ['EmptyDetector', 150];
{if (triggerText _x == "GEN_civilCar") then {deleteVehicle _x;};} forEach _vehicle_near_respawn; // Civilian vehicle triggers

// Delete empty groups
_deleteEmptyGrups = [800] execVM "Scripts\DeleteEmptyGroups.sqf";

// Handle respawn of players - add respawn position for the team and delete older corpse (so only one for each player can be present)
addMissionEventHandler ["EntityRespawned",
{
	private _new = _this select 0; private _old = _this select 1;
	if (isPlayer _new) then {
		private _oldBody = _old getVariable ["BIS_oldBody", objNull];
		if (!isNull _oldBody) then {deleteVehicle _oldBody;};
		_new setVariable ["BIS_oldBody", _old];
		[east,_new] call BIS_fnc_addRespawnPosition;
	};
}];

// Escape task for players
[BIS_grpMain, "objEscape", [format [localize "STR_A3_EscapeFromTanoa_tskEscapeDesc", "<br/>"], localize "STR_A3_EscapeFromMalden_tskEscapeTitle", "<br/>"], objNull, TRUE] call BIS_fnc_taskCreate;

//NNS: 50% chance to had ammobox to small bunker
[] spawn {
	_equipmentsList = ["Box_East_Ammo_F","Box_East_Wps_F","Box_East_WpsSpecial_F","Box_East_Support_F","O_supplyCrate_f"];
	{
		_selectedPos = round(random 3);
		_selectedEquipment = selectRandom _equipmentsList;
		_equipment = _selectedEquipment createVehicle [0,0,0];
		_equipment setPosASL (AGLToASL (_x buildingPos _selectedPos));
		_equipment setDir (getDir _x);
		_equipment addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
		_equipment addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
		[_equipment,0,0,true] call NNS_fnc_AmmoboxLimiter;
	} forEach nearestObjects [[5250,5780,0], ["Land_Bunker_01_small_F"], 7000];
};

// Spawning NATO and FIA units/vehicles, empty transport and support vehicles
[] spawn {
	sleep 5; //needed to avoid troubles with vehicles spawned near respawn
	while {true} do { //loop to take account of recreated triggers
		{
			_triggerText = triggerText _x;
			if (_triggerText == "CSAT_infantry") then { // CSAT patrols
				_x spawn {
					_basePos = position _this; _rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 600} != -1}; //random is here to limit CPU usage when detection happen
					
					[format["'CSAT_infantry' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug
					
					_newGrp = grpNull;
					_newGrp = [_basePos, east, configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom BIS_csatGroups), [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
					_newGrp deleteGroupWhenEmpty true; // Mark for auto deletion, not work?
					_newGrp enableDynamicSimulation true; // Enable Dynamic simulation
					_newGrp allowFleeing 0;
					_newGrp enableGunLights "forceOn"; //turn on flashlight
					
					{
						_x setSkill ["AimingAccuracy", 0.3 + (random 0.3)]; //limit aiming ability
						_x setSkill ["spotDistance",1]; _x setSkill ["spotTime",1];
						_x setDamage (random 0.4); //injuries
						_x removePrimaryWeaponItem "acc_pointer_IR"; //remove IR pointer
						_x addPrimaryWeaponItem "acc_flashlight";  //add flashlight
						_x setVehicleAmmo (0.15 + random 0.15); //limit unit ammo
						_x enableGunLights "forceOn"; //turn on flashlight
						_x disableConversation true; //disable unit radio
					} forEach (units _newGrp);
					
					{_wp = _newGrp addWaypoint [_basePos, _rad]; _wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE";} forEach [1, 2, 3, 4, 5];
					_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
					_wp setWaypointType "CYCLE";
					
					waitUntil {sleep (15); (allPlayers findIf {(_x distance2d _basePos) > 800} != -1) || ({alive _x} count (units _newGrp) == 0)}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {
						{_x setDamage [1, false];} forEach (units _newGrp); //NNS : kill units from group
						[format["'CSAT_infantry' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					};
				};
			};
			
			if (_triggerText == "GEN_csatVeh" || _triggerText == "GEN_csatDestVeh") then { // CSAT vehicles
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2; if (_dir < 0) then {_dir = 360 + _dir};
					_destroyed = false;
					if (triggerText _this == "GEN_csatDestVeh") then {_destroyed = true;};
					deleteVehicle _this;
					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 600} != -1}; //random is here to limit CPU usage when detection happen
					_veh = createVehicle [(selectRandom BIS_csatVehicles), [0,0,0], [], 0, "NONE"];
					_veh setDir _dir;
					_veh setPos _basePos;
					_veh enableDynamicSimulation true;
					_veh setFuel (random 0.05);
					if (_destroyed) then {
						_veh setDamage [1, false];
					} else {
						_veh disableAI "LIGHTS"; //disable vehicle IA light
						[_veh,["hitfuel"],0.2,0.8] call NNS_fnc_randomVehicleDamage;
						_veh addMagazineCargoGlobal ["150Rnd_93x64_Mag", 3]; //Navid
						_veh addMagazineCargoGlobal ["6Rnd_45ACP_Cylinder", 6]; //Zubr
						sleep 1;
						[_veh,0,0,true] call NNS_fnc_AmmoboxLimiter; //limit cargo weapons/ammos
					};
				};
			};
			
			if (_triggerText == "GEN_civilCar") then { // Civilian vehicles
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2; if (_dir < 0) then {_dir = 360 + _dir};
					deleteVehicle _this;
					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 600} != -1}; //random is here to limit CPU usage when detection happen
					[[_basePos select 0,_basePos select 1],_dir] call NNS_fnc_spawnCivVehi;
				};
			};
		} forEach (allMissionObjects "EmptyDetector");
		sleep 1; //wait for next loop
	};
};

// Check if the players are escaping
BIS_Escaped = false; publicVariable "BIS_Escaped";

[] spawn {
	while {!(BIS_Escaped)} do {
		sleep 5;
		{if ((((vehicle _x in list BIS_getaway_area_1) || (vehicle _x in list BIS_getaway_area_2) || (vehicle _x in list BIS_getaway_area_3) || (vehicle _x in list BIS_getaway_area_4) || (vehicle _x in list BIS_getaway_area_5) || (vehicle _x in list BIS_getaway_area_6)) && ((vehicle _x isKindOf "Ship") || (vehicle _x isKindOf "Air"))) || (missionNamespace getVariable ["Debug_Win",false]))} forEach (allPlayers) then { //NNS : rework winning condition, original one allow you to win in some case if soldier was in a destroyed heli
			_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
			["objEscape", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",east,true]; //success
			["success"] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
			BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
		};
	};
};

//NNS: Original rules -> Mission fail if everyone is dead
if (BIS_EscapeRules == 0) then {
	[] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} == -1}; //check if all players dead
		_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
		["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",east,true]; //failed
		["end1", false] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
	};
};

//NNS: Mission fail if all player tickets = 0 && tickets not unlimited
if (!([east] call BIS_fnc_respawnTickets == -1) || !(missionNamespace getVariable ["BIS_respawnTickets",-1] == -1)) then {
	[] spawn {
		if !(missionNamespace getVariable ["BIS_respawnTickets",-1] == 0) then {sleep 120;}; //wait 2min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		while {sleep 5; !(BIS_Escaped)} do {
			_remainingTickets = 0;
			{
				_tmpTickets = [_x] call BIS_fnc_respawnTickets; //recover player remaining ticket
				_remainingTickets = _remainingTickets + _tmpTickets; //add to group tickets
			} forEach (units BIS_grpMain);
			
			if (_remainingTickets < 0) then {_remainingTickets = [east] call BIS_fnc_respawnTickets;}; //ticket but group
			if (_remainingTickets == 0) then { //no more ticket remaining
				_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
				["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",east,true]; //failed
				["end1", false] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
				BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
			};
		};
	};
};

//NNS: Mission fail if all escape vehicle destroyed
[] spawn {
	sleep 300; //wait 5min
	waitUntil {sleep 5; [BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05,BIS_EW06,BIS_EW07,BIS_EW08,BIS_EW09,BIS_EW10] findIf {canMove _x} == -1}; //check if all vehicles destroyed
	_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
	["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",east,true]; //failed
	["end2", false] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
};

// Music when somebody gets into one of the escape vehicles
[] spawn {
	sleep 5;
	_preEscapeVehi = [
	/*airbase_refueler_0,airbase_refueler_1,airbase_refueler_2,
	island_refueler_0,island_refueler_1,
	base_refueler_0,base_refueler_1,
	southwestbase_refueler_0,southwestbase_refueler_1,*/
	BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05,BIS_EW06,BIS_EW07,BIS_EW08,BIS_EW09,BIS_EW10];
	
	waitUntil {sleep 5; allPlayers findIf {vehicle _x in _preEscapeVehi} != -1}; //wait until one player enter a vehicle in the list
	//waitUntil {sleep 5; (units BIS_grpMain) findIf {(vehicle _x isKindOf "Air")} != -1};
	5 fadeMusic 0.75;
	"LeadTrack06_F" remoteExec ["playMusic",east,false];
};

//NNS: Set zombie spawners settings and init zombie stalker spawner 
_zombies_spawner = [zombie_spawner_0,zombie_spawner_1,zombie_spawner_2];
[_zombies_spawner] spawn {
	_zombies_spawner = (_this select 0);
	_zombies_spawner_cache = [villa_zombie_0];
	_zombies_spawner_checkpoint = [checkpoint_07_zombie_0, checkpoint_08_zombie_0, checkpoint_09_zombie_0];
	_zombies_spawner_base = [commstation_zombie_0, southoldbase_zombie_0];
	_zombies_spawner_city = [arudy_zombie_0, cancon_zombie_0, chapoi_zombie_0, dourdan_zombie_0, goisse_zombie_0, harbor_zombie_0, houdan_zombie_0, lariviere_zombie_0, larche_zombie_0, latrinite_zombie_0, lolisse_zombie_0, pessagne_zombie_0, saintlouis_zombie_0];
	_zombies_spawner_preescape = [airport_preescape_zombie_0, airport_preescape_zombie_1, airport_preescape_zombie_2, southwestbase_preescape_zombie_0, southwestbase_preescape_zombie_1, southwestbase_preescape_zombie_2, island_preescape_zombie_0, island_preescape_zombie_1, island_preescape_zombie_2, northeastbase_zombie_0];
	_zombies_spawner_escape = [airport_zombie_0, island_zombie_0, base_zombie_0, southwestbase_zombie_0, harbor_zombie_1];
	
	//select over infected cities
	_over_infected_city_count = 4 + round (random 1);
	_zombies_spawner_city_big = [];
	while {count _zombies_spawner_city_big != _over_infected_city_count} do {
		_tmp = selectRandom _zombies_spawner_city; //selected city
		_zombies_spawner_city_big pushback _tmp; //add to selected array
		_zombies_spawner_city deleteAt (_zombies_spawner_city find _tmp); //delete from array
	};
	
	//create markers for all zombies zones
	_zombies_marker_size = 400;
	{
		for "_i" from 1 to 3 do {
			_tmpName = format ["mrk_%1_%2",_x,_i];
			_tmpSize = _zombies_marker_size + ((_zombies_marker_size / 3) * _i);
			_tmpMarker = createMarker [_tmpName, getPos _x];
			if (_x in _zombies_spawner_city_big) then {_tmpName setMarkerAlpha 0.25;} else {_tmpName setMarkerAlpha 0.15;};
			_tmpName setMarkerColor "ColorRed";
			_tmpName setMarkerShape "ELLIPSE"; _tmpName setMarkerSize [_tmpSize, _tmpSize];
		};
	} forEach (_zombies_spawner_cache + _zombies_spawner_checkpoint + _zombies_spawner_city + _zombies_spawner_city_big + _zombies_spawner_escape + _zombies_spawner_base);
	
	//recover values
	_zombies_set_alive = missionNamespace getVariable ["BIS_ZM_alive", [35,20,25,35,40]];
	_zombies_set_total = missionNamespace getVariable ["BIS_ZM_total", [9999,30,35,45,50]];
	_zombies_set_horde = missionNamespace getVariable ["BIS_ZM_horde", [10,8,10,15,15]];

	//zombies following players group, set by step, e.g 3 spawner -> 33%, 66%, 100%
	for "_i" from count (_zombies_spawner) to 0 step -1 do {
		_tmpRatio = (1 / count (_zombies_spawner)) * (_i + 1);
		_tmpAlive = _zombies_set_alive select 0;
		_tmpHorde = _zombies_set_horde select 0;
		
		(_zombies_spawner select _i) setVariable ["AliveAmount", ceil (_tmpAlive * _tmpRatio), true];
		(_zombies_spawner select _i) setVariable ["TotalAmount", 9999, true];
		(_zombies_spawner select _i) setVariable ["HordeSize", ceil (_tmpHorde * _tmpRatio), true];
		(_zombies_spawner select _i) setVariable ["Activation", 3, true]; //opfor activation
		
		sleep 1;
		if ((_zombies_spawner select _i) getVariable ["TotalAmount",-1] != -1) then { //init zombie module
			[_zombies_spawner select _i] spawn {[(_this select 0)] call RyanZM_fnc_rzfunctionspawn;};
		};
	};
	
	//zombies in cache zones
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 1, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 1, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 1, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_cache;
	
	//zombies in checkpoints
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 2, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 2, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 2, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_checkpoint;
	
	//zombies in cities
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 3, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 3, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 3, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_city;
	
	//zombies in bases : TODO
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 3, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 3, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 3, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_base;
	
	//zombies in escape zone : TODO
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 3, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 3, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 3, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_escape;
	
	//zombies in over infected cities
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 4, true];
		_x setVariable ["TotalAmount", _zombies_set_total select 4, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 4, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
		_x setVariable ['Type',17,true]; //mixed zombies (no spiders/crawlers)
		_x setVariable ['Type2',13,true]; //demons
	} forEach _zombies_spawner_city_big;
	
	//zombies in pre escape phase
	{
		_x setVariable ["AliveAmount", _zombies_set_alive select 5, true];
		_x setVariable ["TotalAmount", 9999/*_zombies_set_total select 5*/, true];
		_x setVariable ["HordeSize", _zombies_set_horde select 5, true];
		_x setVariable ["Activation", 3, true]; //opfor activation
	} forEach _zombies_spawner_preescape;
};

//NNS: disable fuel pumps, 50% chance to spawn a fuel canister
{
	_x setFuelCargo 0;
	if (random 100 < 50) then {
		_pos = getPos _x;
		_tmp = "Land_CanisterFuel_F" createVehicle [0,0,0];
		_tmp setDir (random 360);
		_tmp setPos (_x getPos [1, (180 * selectRandom [1,-1]) + ((random 70) * selectRandom [1,-1])]);
	};
} forEach nearestObjects [[5250,5780,0], ["Land_fs_feed_F","Land_FuelStation_Feed_F","Land_FuelStation_01_pump_F","Land_FuelStation_01_pump_malevil_F","Land_FuelStation_02_pump_F","Land_FuelStation_03_pump_F"], 8000];

//NNS: 30% chance to spawn a fuel canister in garage
{
	if (random 100 < 50) then {
		_tmp = "Land_CanisterFuel_F" createVehicle [0,0,0];
		_tmp setDir (random 360);
		_tmp setPosASL (AGLToASL (_x buildingPos 0));
	};
} forEach nearestObjects [[5250,5780,0], ["Land_i_Garage_V1_F", "Land_i_Garage_V2_F"], 8000];

//NNS : add pick action to all fuel canister on map
{
	[_x, [localize "STR_NNS_Escape_TakeFuelCanister", {(_this select 1) setVariable ["haveCanister", true]; deleteVehicle (_this select 0);}, nil, 1.5, true, true, "", "[true, false] select (player getVariable ['haveCanister', false])", 2]] remoteExec ["addAction", 0, true];
} forEach nearestObjects [[5250,5780,0], ["Land_CanisterFuel_F"], 8000];

//NNS: hide all loot markers
_loot_markers = []; //loot array
{
	if (markerText _x == "loot") then {_x setMarkerAlpha 0; _loot_markers pushBack _x;}; //if marker text is loot, hide it and add to loot array
} forEach allMapMarkers;
missionNamespace setVariable ["lootMarkers",_loot_markers,true];

//NNS : stats : longest kill / weapon used per player
addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator"];
	//systemChat format ["_killed:%1, typeOf:%2 , _killer:%3, _instigator:%4", _killed, typeOf _killed, _killer, _instigator];
	
	if (isNull _instigator) then {_instigator = _killer}; // player driven vehicle road kill
	
	if ((getPlayerUID _instigator) != "" && {_instigator in (units BIS_grpMain)} && {!(_killed isEqualTo _instigator)}) then { //not AI, is in player group, not a suicide
		if (side group _killed == side group _instigator) then { //frendly killed
			_friendly_kill = _instigator getVariable ["friendly_kill",0]; //recover player var
			_instigator setVariable ["friendly_kill",_friendly_kill+1]; //update player var
		} else {
			_distance = round((getPos _instigator) distance (getPos _killed)); //compute distance
			_longest_kill = _instigator getVariable ["longest_kill",[0,""]]; //recover player var
			if (_distance > (_longest_kill select 0) && _distance < viewDistance) then {
				_longest_kill set [0, _distance]; //update distance
				if(_instigator == vehicle _instigator) then {_longest_kill set [1, currentWeapon _instigator]; //not in vehicle, weapon class
				} else {_longest_kill set [1, typeOf vehicle _instigator];}; //in vehicle, vehicle class
				_instigator setVariable ["longest_kill",_longest_kill]; //update player var
			};
		};
	};
	
	if (["fuel", toLower (typeOf _killed), true] call BIS_fnc_inString) then { //fuel kind class, refuel vehicle, ...
		[_killed] spawn { //spawn big explosion
			_vehi = (_this select 0); //recover object
			if !(isNull _vehi) then { //object isn't null
				_pos = getPos _vehi;
				_explosion = createMine ["SatchelCharge_F", [_pos select 0, _pos select 1, 0], [], 0];
				_explosion setDamage 1;
				sleep 1;
				deleteVehicle _explosion;
			};
		};
	};
}];

//NNS: Zombie spawner mover, move spawn point
[_zombies_spawner] spawn {
	sleep 5;
	_zombies_spawner = (_this select 0); //zombie spawner
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	_lastRespawnPos = [0,0,0];
	_groupOldPos = [BIS_grpMain,[0,0,0]] call NNS_fnc_groupCenter; //initial group position
	_spawnerDist = 100; //tmp
	_spawnerInterval = 2.5; //interval between update
	_spawnerIncreaseInterval = round (1800 / (count _zombies_spawner - 1)); //interval where zombie spawner will be upgraded
	while {true} do {
		_ignorePlayers = [];
		{if (_x getVariable ["recovery",false]) then {_ignorePlayers pushBack _x;};} forEach (units BIS_grpMain); //add to ignore list
		_groupNewPos = [BIS_grpMain, _groupOldPos, _ignorePlayers] call NNS_fnc_groupCenter; //group center
		if !(getMarkerColor "marker_respawn" == "") then {"marker_respawn" setMarkerPos _groupNewPos;}; //move respawn marker
		
		_currentZombieStage = floor (time / _spawnerIncreaseInterval); //compute current stage
		if (_currentZombieStage > (count _zombies_spawner - 1)) then {_currentZombieStage = (count _zombies_spawner - 1);}; //avoid array overflow
		_currentZombieSpawner = _zombies_spawner select _currentZombieStage; //define current spawner
		
		if (_currentZombieStage != 0) then { //not the inital spawner and not in water
			for "_i" from 0 to (_currentZombieStage - 1) do {(_zombies_spawner select _i) setPos [0,0,0];}; //move older spawner to 0,0,0
		};
		
		_tmpDist = _groupNewPos distance2d _groupOldPos; //old to new position distance
		if (_groupNewPos distance2D [1185,12281] < 400) then {_tmpDist = 0;}; //near debug zone, stop update spawner position
		if (_tmpDist > 1) then { //players group moved
			_spawnerDist = (_tmpDist/_spawnerInterval) * 20; //spawner distance ahead of leader based on speed * 25sec
			if (_spawnerDist < 50) then {_spawnerDist = 50;}; //allow only spawn over 50m to leader
			_groupHeading = (((_groupNewPos select 1)-(_groupOldPos select 1)) atan2 ((_groupNewPos select 0)-(_groupOldPos select 0))); //heading from emiter
			_spawnerPos = [(_groupNewPos select 0) + (_spawnerDist * cos(_groupHeading)), (_groupNewPos select 1) + (_spawnerDist * sin(_groupHeading)), 0]; //spawner new position
			if !(surfaceIsWater _spawnerPos) then {_currentZombieSpawner setPos _spawnerPos;}; //move spawner if not in sea
			
			//debug
			//_tmpmarker_name = format["tmpmarker%1%2%3",random 10000,random 10000,random 10000]; //marker name to avoid "colision"
			//[_tmpmarker_name,_groupNewPos,_spawnerPos,"ColorRed",1,1,_spawnerInterval] call NNS_fnc_MapDrawLine; //draw line from initial to new position
		};
		_groupOldPos = _groupNewPos; //backup position
		sleep _spawnerInterval; //wait
	};
};

//NNS : Lights flickering
[] spawn {
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	_objectsLamps = ["Lamps_base_F", "PowerLines_base_F", "PowerLines_Small_base_F", "Land_fs_roof_F", "Land_FuelStation_01_roof_malevil_F"]; //lamp objects
	_objects_toIgnore = ["Land_LampAirport_F","Land_LampHalogen_F"];
	while {true} do {
		if !(sunOrMoon == 1) then { //moon time
			waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
			_pos = leader group player; //get leader position
			if !(getMarkerColor "marker_respawn" == "") then {_pos = getMarkerPos "marker_respawn";}; //get respawn position
			_lampArray = nearestObjects [_pos, _objectsLamps, viewDistance]; //detect lamps around group
			_lampCount = count (_lampArray); //count array lenght
			if (_lampCount != 0) then { //some objects in the array
				for "_i" from 0 to (_lampCount - 1) do { //objects loop
					_tmpObj = (_lampArray select _i); //current obj
					if (damage _tmpObj < 0.9 && {(random 1) > 0.8} && {!((typeOf _tmpObj) in _objects_toIgnore)}) then {
						_lightAlive = 0;
						_tmpHitpoints = getAllHitPointsDamage _tmpObj;
						if !(count _tmpHitpoints == 0) then {_lightAlive = {_x < 0.9} count (_tmpHitpoints select 2);}; //count light hitpoint < 0.9 damage
						if (_lightAlive > 0) then {
							[_tmpObj] remoteExec ["NNS_fnc_LampFlickering"]; //remoteexec a flicker on each clients
						};
					};
					sleep (5/_lampCount); //allow 5sec for the whole array
				};
			} else {sleep 5;}; //no objects, wait 5 sec
		} else {sleep 60;}; //"day" time, nothing to do, long wait
	};
};
/*
//NNS: try to handle refuel glitch for escape vehicles when hit by zombies
[] spawn {
	//_refuelerTypes = ["O_G_Van_01_fuel_F", "O_Truck_02_fuel_F", "O_Truck_03_fuel_F", "O_T_Truck_02_fuel_F", "O_T_Truck_03_fuel_ghex_F"]; //all allowed refueler type
	while {true} do {
		{
			_vehi = vehicle _x;
			if (alive _x && {_vehi isKindOf "Air"} && {isTouchingGround _vehi}) then { //current player in air type vehicle and touching ground
				if (((currentPilot _vehi) isEqualTo _x) && {(fuel _vehi < 1)}) then { //current player is pilot and tank not fuel
					_nearTrucks = nearestObjects [getPos _vehi, ["Car"], 20]; //all car type object in 15m radius
					{
						if (alive _x && {["fuel", toLower (typeOf _x), true] call BIS_fnc_inString}) then { //refueler nearby, add 5% fuel per loop
						//if (typeOf _x in _refuelerTypes) then { //allowed refueler type nearby, add 5% fuel per loop
							[_vehi,(fuel _vehi) + 0.05] remoteexec ['setFuel',_vehi];
							systemChat "eee";
						};
					} forEach _nearTrucks;
				};
			};
		} forEach allPlayers; //all player loop
		sleep 2;
	};
};
*/