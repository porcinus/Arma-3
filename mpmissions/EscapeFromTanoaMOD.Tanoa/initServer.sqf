
if (isNil {missionNamespace getVariable "Debug_Win"}) then {missionNamespace setVariable ["Debug_Win",false,true];}; //force win

//NNS : delete all AI
{deletevehicle _x} forEach units BIS_grpMain;

//NNS : Add random respawn position
_start_pos_list = [];
for "_i" from 0 to 100 do { //detect from marker_objective_0 to marker_objective_100
	_tmpname = format ["respawn_%1", _i]; //parse marker name
	if (getMarkerColor _tmpname != "") then { //marker exist
		_start_pos_list pushBack _tmpname; //add marker to array
		//[east,_tmpname,_tmpname] call BIS_fnc_addRespawnPosition; //debug, add all respawn
	};
};

_start_pos_rnd = _start_pos_list call BIS_fnc_selectRandom; //select random marker
"respawn" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
"marker_respawn" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
"start" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
"BIS_mrkStart" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position

// Delete empty groups
_deleteEmptyGrups = [] execVM "Scripts\DeleteEmptyGroups.sqf";

// Handle respawn of players - add respawn position for the team and delete older corpse (so only one for each player can be present)
addMissionEventHandler ["EntityRespawned", {
	private _new = _this select 0;
	private _old = _this select 1;

	if (isPlayer _new) then {
		private _oldBody = _old getVariable ["BIS_oldBody", objNull];
		if (!isNull _oldBody) then {deleteVehicle _oldBody;};
    _new setVariable ["BIS_oldBody", _old];
		[west,_new] call BIS_fnc_addRespawnPosition;
	};
}];

_initSpawn = [west,"marker_respawn",localize "STR_A3_EscapeFromTanoa_respawnVolcano"] call BIS_fnc_addRespawnPosition;

if (BIS_EscapeRules == 0) then { //NNS: Original rules -> Remove respawn after 5min
	[_initSpawn] spawn {
		_initSpawn = _this select 0;
		sleep 300;
		waitUntil {sleep 5; {alive _x} count allPlayers > 0};
		deleteMarker "marker_respawn"; //remove respawn
		//_initSpawn call BIS_fnc_removeRespawnPosition;
	};
};

// Start special events if enabled
[] spawn {
	sleep 5;
	if (missionNamespace getVariable "BIS_specialEvents" == 1) then {_events = [10,15] spawn BIS_fnc_EfT_specialEvents;};
};

// Limit equipment of already existing enemy units
[] spawn {
	if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {
		{if ((side group _x == East) or (side group _x == Resistance)) then {_null = _x execVM "Scripts\LimitEquipment.sqf"}} forEach allUnits;
	};
};

// Escape task for players
[BIS_grpMain, "objEscape", [format [localize "STR_A3_EscapeFromTanoa_tskEscapeDesc", "<br/>"], localize "STR_A3_EscapeFromTanoa_tskEscapeTitle", "<br/>"], objNull, TRUE] call BIS_fnc_taskCreate;

// Initial music
[] spawn {
	sleep 15;
	"LeadTrack03a_F_EPA" remoteExec ["playMusic",west,false]; // LeadTrack02_F_EXP, LeadTrack01a_F, LeadTrack01c_F_EXP
};

// Definitions of vehicles and groups to be spawned
BIS_civilCars = ["C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Offroad_02_unarmed_F","C_Truck_02_transport_F"];
BIS_supportVehicles = ["C_Van_01_fuel_F","C_Truck_02_fuel_F","C_Offroad_01_repair_F"];
BIS_SyndikatPatrols = ["EfT_I_Team01","EfT_I_Team02","EfT_I_Team03","EfT_I_Team04","EfT_I_Team05","EfT_I_Squad01","EfT_I_Squad02"];
BIS_CSATPatrols = ["EfT_O_Team01","EfT_O_Team02"];

// Spawning enemy units & vehicles, empty transport and support vehicles
[] spawn {
	while {true} do { //loop to take account of recreated triggers
		{
			if (triggerText _x == "GEN_infantry") then { // Syndikat patrols
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep 5; ({(_x distance2d _basePos) < (1000)} count allPlayers > 0)};

					if ({side _x == resistance} count allGroups > 120) exitWith {"Too many RESISTANCE groups at the same time!" call BIS_fnc_log};

					_newGrp = grpNull;
					_newGrp = [_basePos, Resistance, missionConfigFile >> "CfgGroups" >> "Indep" >> "IND_C_F" >> "Infantry" >> (selectRandom BIS_SyndikatPatrols), [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
					
					if (BIS_EnemyAmount > 0) then {
						format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
						format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
					};
					
					if (BIS_EnemyAmount > 1) then {
						format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
						format ["I_C_Soldier_Bandit_%1_F", 1 + ceil(random 7)] createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
					};
					
					_newGrp enableDynamicSimulation true; // Enable Dynamic simulation
					
					if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach units _newGrp}; // Limit unit equipment if set by server
					
					{_x setSkill ["AimingAccuracy",0.15]} forEach (units _newGrp); // Limit aiming accuracy

					if ((random 1) > 0.65) then {
						/*_wp = _newGrp addWaypoint [position leader _newGrp, 0];
						_wp setWaypointType "GUARD";*/
						_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
					} else {
						{
							_wp = _newGrp addWaypoint [_basePos, _rad];
							_wp setWaypointType "MOVE";
							_wp setWaypointSpeed "LIMITED";
							_wp setWaypointBehaviour "SAFE";
						} forEach [1, 2, 3, 4, 5];
						_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
						_wp setWaypointType "CYCLE";
					};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1300} != -1}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'GEN_infantry' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "GEN_infantry";
					[format["Trigger 'GEN_infantry' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};
			
			if (triggerText _x == "CSAT_infantry") then { // CSAT patrols
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep 5; ({(_x distance2d _basePos) < (1000)} count allPlayers > 0)};

					if ({side _x == east} count allGroups > 120) exitWith {"Too many EAST groups at the same time!" call BIS_fnc_log};

					_newGrp = grpNull;
					_newGrp = [_basePos, EAST, missionConfigFile >> "CfgGroups" >> "East" >> "OPF_T_F" >> "Infantry" >> (selectRandom BIS_CSATPatrols), [], [], [0.3, 0.4]] call BIS_fnc_spawnGroup;
					
					if (BIS_EnemyAmount > 0) then {
						"O_engineer_F" createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
						"O_soldier_F" createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
					};
					
					if (BIS_EnemyAmount > 1) then {
						"O_soldier_AA_F" createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
						"O_HeavyGunner_F" createUnit [_newGrp, _newGrp, "", 0.5, "PRIVATE"];
					};
					
					_newGrp enableDynamicSimulation true; // Enable Dynamic simulation
					
					if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach units _newGrp}; // Limit unit equipment if set by server
					{_x setSkill ["AimingAccuracy",0.20]} forEach (units _newGrp); // Limit aiming accuracy

					if ((random 1) > 0.65) then {
						/*_wp = _newGrp addWaypoint [position leader _newGrp, 0];
						_wp setWaypointType "GUARD";*/
						_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
					} else {
						{
							_wp = _newGrp addWaypoint [_basePos, _rad];
							_wp setWaypointType "MOVE";
							_wp setWaypointSpeed "LIMITED";
							_wp setWaypointBehaviour "SAFE";
						} forEach [1, 2, 3, 4, 5];
						_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
						_wp setWaypointType "CYCLE";
					};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1300} != -1}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'CSAT_infantry' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "CSAT_infantry";
					[format["Trigger 'CSAT_infantry' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};
			
			if (triggerText _x == "GEN_patrolVeh") then { // CSAT patrolling vehicles
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2;
					if (_dir < 0) then {_dir = 360 + _dir};
					_vehType = (triggerStatements _this) select 1;
					_wpPath = group ((synchronizedObjects _this) select 0);	// synchronized civilian unit is used as waypoint storage
					deleteVehicle ((synchronizedObjects _this) select 0);
					deleteVehicle _this;

					waitUntil {sleep 2.5; ({(_x distance _basePos) < 1250} count allPlayers > 0)};

					_vehClass = switch (_vehType) do {
						case "MRAP": {selectRandom ["O_T_MRAP_02_hmg_ghex_F","O_T_MRAP_02_gmg_ghex_F"]};
						case "APC": {"O_T_APC_Wheeled_02_rcws_v2_ghex_F"};
						case "IFV": {"O_T_APC_Tracked_02_cannon_ghex_F"};       // Not used, only one in each escape location
						case "AAA": {"O_T_APC_Tracked_02_AA_ghex_F"};           // Not used, only one at the International Airfield
						case "SPG": {"O_T_MBT_02_arty_ghex_F"};                 // Not used at all
						case "MBT": {"O_T_MBT_02_cannon_ghex_F"};               // Not used at all
						case "LSV": {"O_T_LSV_02_armed_ghex_F"};
						case "LSVU": {"O_T_LSV_02_unarmed_ghex_F"};
						/*case "UGV": {"O_T_UGV_01_rcws_ghex_F"};*/
						default {"O_T_LSV_02_armed_ghex_F"};
					};
					
					_veh = createVehicle [_vehClass, _basePos, [], 0, "NONE"];
					_veh setDir _dir;
					createVehicleCrew _veh;
					_vehCrew = crew _veh;
					_vehGroup = group (_vehCrew select 0);

					_vehGroup copyWaypoints _wpPath;
					deleteGroup _wpPath;
					{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh];
					_veh addItemCargoGlobal ["FirstAidKit",2];
					_veh setFuel (0.35 + random 0.25);
					_veh setVehicleAmmo (0.4 + random 0.4);
					
					if (_vehType == "LSVU") then { // If the vehicle is unarmed LSV, create crew for FFV positions and disable getting out in combat
						_veh setUnloadInCombat [false,false];
						_unit01 = _vehGroup createUnit ["O_T_Soldier_AR_F", [0,0,0], [], 0, "CAN_COLLIDE"]; _unit01 moveInCargo _veh; [_unit01] orderGetIn true;
						_unit02 = _vehGroup createUnit [selectRandom ["O_T_Soldier_GL_F","O_T_Soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"]; _unit02 moveInCargo _veh; [_unit02] orderGetIn true;
						_unit03 = _vehGroup createUnit ["O_T_Soldier_F", [0,0,0], [], 0, "CAN_COLLIDE"]; _unit03 moveInCargo _veh; [_unit03] orderGetIn true;
		        _vehCrew = crew _veh;
					};
					
					if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh allowCrewInImmobile true;}; // Handle immobilization
					
					_doubleChance = 35;
					if (BIS_EnemyAmount == 1) then {_doubleChance = 45};
					if (BIS_EnemyAmount == 2) then {_doubleChance = 55};
					
					if ((_vehType in [/*"UGV",*/"LSV"]) and {random 100 < 35}) then { // Chance to create a second vehicle of the same type - only for armed LSV and UGV
						_veh02 = createVehicle [_vehClass, [(_basePos select 0) - 7, (_basePos select 1) - 7, 0], [], 0, "NONE"];
						_veh02 setDir _dir;
						createVehicleCrew _veh02;
						_veh02Crew = crew _veh02;
						_veh02Crew joinSilent _vehGroup;

						{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh02];
						_veh02 addItemCargoGlobal ["FirstAidKit",2];
						_veh02 setFuel (0.35 + random 0.25);
						_veh02 setVehicleAmmo (0.4 + random 0.4);
						
						if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh02 allowCrewInImmobile true;}; // Handle immobilization
					};
					
					if ((missionNamespace getVariable "BIS_enemyEquipment" == 1) and {_vehType != "UGV"}) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _vehGroup)}; // Limit unit equipment if set by server
					{_x setSkill ["AimingAccuracy",0.1]} forEach (units _vehGroup); // Limit aiming accuracy
					_vehGroup enableDynamicSimulation true; // Enable Dynamic simulation
				};
			};

			// Civilian vehicles
			if (triggerText _x == "GEN_civilCar") then {
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2;
					if (_dir < 0) then {_dir = 360 + _dir};
					deleteVehicle _this;
					waitUntil {sleep 5; ({(_x distance _basePos) < 1000} count allPlayers > 0)};
					_veh = (selectRandom BIS_civilCars) createVehicle _basePos;
					_veh setFuel (0.35 + (random 0.25));
					_veh setDir _dir;
					{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh];
					_veh addItemCargo ["FirstAidKit",1];
					_veh enableDynamicSimulation true;
				};
			};
		} forEach (allMissionObjects "EmptyDetector");
		sleep 30; //wait for next loop
	};
};

// Check if the players are escaping
BIS_Escaped = false;
publicVariable "BIS_Escaped";

[] spawn {
	while {!(BIS_Escaped)} do {
		sleep 5;
		
		{if ((((vehicle _x in list BIS_getaway_area_1) || (vehicle _x in list BIS_getaway_area_2) || (vehicle _x in list BIS_getaway_area_3) || (vehicle _x in list BIS_getaway_area_4) || (vehicle _x in list BIS_getaway_area_5) || (vehicle _x in list BIS_getaway_area_6)) && ((vehicle _x isKindOf "Ship") || (vehicle _x isKindOf "Air"))) || (missionNamespace getVariable ["Debug_Win",false]))} forEach (allPlayers) then { //NNS : rework winning condition, original one allow you to win in some case if soldier was in a destroyed heli
			_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
			["objEscape", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",west,true]; //success
			["success"] remoteExec ["BIS_fnc_endMission",west,true]; //call end mission
			BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
		};
	};
};

if (BIS_EscapeRules == 0) then { //NNS: Original rules -> Mission fail if everyone is dead
	[] spawn {
		sleep 5; //wait 5min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} == -1}; //check if all players dead
		//waitUntil {sleep 5; {alive _x} count (units BIS_grpMain) > 0}; //check if at least one player alive
		//waitUntil {sleep 5; {alive _x} count (units BIS_grpMain) == 0}; //check if all players dead
		_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
		["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",west,true]; //failed
		["endLoser", false] remoteExec ["BIS_fnc_endMission",west,true]; //call end mission
	};
};

[] spawn { //NNS: Mission fail if all player tickets = 0
	sleep 5; //wait 5min
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	
	while {!(BIS_Escaped)} do {
		sleep 5;
		_remainingTickets = 0;
		{
			_tmpTickets = [_x] call BIS_fnc_respawnTickets; //recover player remaining ticket
			_remainingTickets = _remainingTickets + _tmpTickets; //add to group tickets
		} forEach (units BIS_grpMain);
		
		if (_remainingTickets < 0) then {_remainingTickets = [west] call BIS_fnc_respawnTickets;}; //ticket but group
		
		if (_remainingTickets == 0) then { //no more ticket remaining
			_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
			["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",west,true]; //failed
			["endLoser", false] remoteExec ["BIS_fnc_endMission",west,true]; //call end mission
			BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
		};
	};
};

// Music when somebody gets into one of the escape vehicles
[] spawn {
	sleep 5;
	waitUntil {sleep 5; {(vehicle _x isKindOf "Ship") or (vehicle _x isKindOf "Air")} count units BIS_grpMain > 0};
	5 fadeMusic 0.75;
	"LeadTrack04_F_EXP" remoteExec ["playMusic",west,false];
};

//NNS : stats : longest kill / weapon used per player
addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator"];
	if (isNull _instigator) then {_instigator = _killer}; // player driven vehicle road kill
	if ((getPlayerUID _instigator) != "") then { //not AI
		if (_instigator in (units BIS_grpMain)) then { //is a player
			if !(_killed isEqualTo _instigator) then { //player didn't killed itself
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
		};
	};
}];

//NNS : stats : backup players stats, used to restore stat if player lose connection or crash and join back
[] spawn {
	_playersStatsIndex = []; //contain players ID
	_playersStatsLastUpdate = []; //last update time
	_playersStats = []; //contain players stats
	while {sleep 5; true} do {
		{if (alive _x) then {deletevehicle _x;};} forEach (units BIS_grpMain); //delete AI units, in case someone disconnected
		_tmpTime = time; //time
		{ //players loop
			_tmpUID = getPlayerUID _x; //get player UID
			if ((getPlayerUID _x) != "") then { //player has UID
				_tmpStats = +(_x getVariable ["stats",[[0,0,0,0,0],[0,0]]]); //recover player stats, array copy, not pointer
				if (count _tmpStats == 2) then { //at least one valid stats array
					if !(_tmpUID in _playersStatsIndex) then { //current player stat not backup a single time
						_playersStatsIndex pushBack _tmpUID; //add player uid to index
						_playersStats append [_tmpStats]; //add player stats
						_playersStatsLastUpdate pushBack _tmpTime; //add player update time
					};
					
					_tmpIndex = _playersStatsIndex find _tmpUID; //found proper player index
					if ((_tmpTime - (_playersStatsLastUpdate select _tmpIndex)) > 12) then { //player stat outdated (over 1min), may have reconnect
						_tmpOldLastUpdate = _playersStatsLastUpdate select _tmpIndex; //recover old update time
						_tmpOldStats = _playersStats select _tmpIndex; //recover old stats
						_x setVariable ["stats",_tmpOldStats, true]; //restore old player stats
						_x setVariable ["statsSrv",true, true]; //told player its stats are from server backup
					} else {_playersStats set [_tmpIndex, _tmpStats];}; //backup player stats
					_playersStatsLastUpdate set [_tmpIndex, _tmpTime]; //last time update
				};
			};
		} forEach allPlayers;
	};
};

//NNS : Move spawn point
[_initSpawn] spawn {
	sleep 5;
	_initSpawn = (_this select 0); //initial respawn
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	_lastRespawnPos = [0,0,0];
	while {true} do {
		if !(count _initSpawn == 0) then { //initial respaw still exist
			_ignorePlayers = [];
			{if (_x getVariable ["recovery",false]) then {_ignorePlayers pushBack _x;};} forEach (units BIS_grpMain); //add to ignore list
			_lastRespawnPos = [BIS_grpMain, _lastRespawnPos, _ignorePlayers] call NNS_fnc_groupCenter; //get group center
			if !(getMarkerColor "marker_respawn" == "") then {"marker_respawn" setMarkerPos _lastRespawnPos;}; //move respawn marker
			//if !(isNull respawnball) then {respawnball setPos _lastRespawnPos;}; //move respawn object
		};
		sleep 5;
	};
};

