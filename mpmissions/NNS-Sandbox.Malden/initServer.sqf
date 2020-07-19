if (isNil {missionNamespace getVariable "DebugMenu_level"}) then {missionNamespace setVariable ["DebugMenu_level","none",true]}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_enable"}) then {missionNamespace setVariable ["DebugOutputs_enable",false,true]}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Chatbox"}) then {missionNamespace setVariable ["DebugOutputs_Chatbox",false,true]}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Logs"}) then {missionNamespace setVariable ["DebugOutputs_Logs",false,true]}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "Debug_Win"}) then {missionNamespace setVariable ["Debug_Win",false,true]}; //force win

//NNS : delete all AI from main group
missionNamespace setVariable ["BIS_playerSide", side (leader BIS_grpMain), true]; //backup players side
BIS_grpMainUnits = [];
{
	_type = typeOf _x; //unit class
	if !(_type in BIS_grpMainUnits) then {BIS_grpMainUnits pushBack (typeOf _x)}; //backup unit class
	deletevehicle _x; //delete AI
} forEach units BIS_grpMain; //main group loop
publicVariable "BIS_grpMainUnits";

// Definitions of vehicles and groups to be spawned
BIS_spawnInterval = 10; //sec
BIS_spawnIntervalRnd = 5; //add random sec
BIS_spawnDistance = 800; //meters
BIS_deletionDistance = 1500; //meters

BIS_civilCars = ["C_Offroad_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
BIS_civilWreckCars = ["Land_Wreck_Ural_F","Land_Wreck_Truck_dropside_F","Land_Wreck_Truck_F","Land_Wreck_Van_F","Land_Wreck_Offroad_F","Land_Wreck_Offroad2_F","Land_Wreck_Car_F"];
BIS_supportVehicles = ["C_Van_01_fuel_F","C_Truck_02_fuel_F","C_Offroad_01_repair_F"];

BIS_spawnAllowed = ["nato","csat"];

BIS_natoSide = west;
BIS_natoSideStr = "West";
BIS_natoFaction = "BLU_F";
BIS_natoVehicles = ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F","B_APC_Tracked_01_rcws_F","B_APC_Wheeled_01_cannon_F","B_APC_Tracked_01_AA_F","B_LSV_01_unarmed_F","B_LSV_01_armed_F"];
BIS_natoInfantry = ["BUS_InfSquad", "BUS_InfTeam", "BUS_InfTeam_AT", "BUS_InfTeam_AA"];
BIS_natoRecon = ["BUS_ReconTeam", "BUS_ReconPatrol"];
BIS_natoSniper = ["BUS_SniperTeam"];
BIS_natoCrewUnits = ["B_soldier_F","B_soldier_M_F","B_soldier_AR_F"];

BIS_csatSide = east;
BIS_csatSideStr = "East";
BIS_csatFaction = "OPF_F";
BIS_csatVehicles = ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_APC_Wheeled_02_rcws_v2_F","O_APC_Tracked_02_cannon_F","O_LSV_02_armed_F","O_LSV_02_unarmed_F"];
BIS_csatInfantry = ["OIA_InfSquad", "OIA_InfTeam", "OIA_InfTeam_AT", "OIA_InfTeam_AA"];
BIS_csatRecon = ["OI_ReconTeam", "OI_ReconPatrol"];
BIS_csatSniper = ["OI_SniperTeam"];
BIS_csatCrewUnits = ["O_soldier_F","O_soldier_M_F","O_soldier_AR_F"];

// Fuel canister data
missionNamespace setVariable ["BIS_FuelCanisterCap",12.5,true]; //capacity in "liter"
missionNamespace setVariable ["BIS_FuelCanisterRatio",0.5,true]; //game unit to "liter" ratio

//NNS: Delete empty groups
_deleteEmptyGrups = [BIS_deletionDistance] execVM "scripts\DeleteEmptyGroups.sqf"; //1200m radius

//NNS : Add random respawn position
_start_pos_list = []; //respawn marker array
for "_i" from 0 to 100 do { //detect from marker_objective_0 to marker_objective_100
	_tmpname = format ["respawn_%1", _i]; //parse marker name
	if (getMarkerColor _tmpname != "") then {_start_pos_list pushBack _tmpname;}; //marker exist, add to array
};

if (count _start_pos_list > 0) then { //at least one respawn marker found
	_start_pos_rnd = selectRandom _start_pos_list; //select random marker
	_pos = getMarkerPos _start_pos_rnd; //initial respawn position
	"marker_initspawn" setMarkerPos _pos; //set initial marker position
	"marker_respawn" setMarkerPos _pos; "marker_respawn" setMarkerAlpha 0.01; //set respawn marker position and hide it
	{_x setpos (_pos getPos [5, random 360]);} forEach (units BIS_grpMain); //move all base units to respawn location
	[BIS_playerSide,"marker_respawn","Respawn"] call BIS_fnc_addRespawnPosition; //add respawn point
};

//NNS: Original rules -> Remove respawn after 5min
if (BIS_EscapeRules == 0) then {
	[] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; allPlayers findIf {alive _x} != -1}; //check if at least one player alive
		deleteMarker "marker_respawn"; //remove respawn marker, done that way to avoid error showing
	};
};

//BIS: Handle respawn of players - add respawn position for the team and delete older corpse (so only one for each player can be present)
addMissionEventHandler ["EntityRespawned", {
	params [["_new", objNull], ["_old", objNull]]; //recover params
	if (isPlayer _new) then { //avoid glitch
		private _oldBody = _old getVariable ["BIS_oldBody", objNull]; //recover old body object
		if (!isNull _oldBody) then {deleteVehicle _oldBody;}; //object exits, delete it
		_new setVariable ["BIS_oldBody", _old]; //update old body var
		[BIS_playerSide, _new] call BIS_fnc_addRespawnPosition; //add respawn on player
	};
}];

//NNS: spawn civilian vehicles near respawn
_vehicle_near_respawn = (getMarkerPos "marker_respawn") nearObjects ['EmptyDetector', 150]; //150m radius
{
	if (triggerText _x == "GEN_civilCar") then { // Civilian vehicles
		_x spawn {
			_basePos = position _this; //trigger position
			_dir = (triggerArea _this) select 2; //trigger direction
			deleteVehicle _this; //delete trigger
			_veh = [_basePos,_dir,[],[],0.1 + (random 0.1),false,false,0,0] call NNS_fnc_spawnCivVehi; //spawn civilian vehicle
			[format["'%1' spawned near respawn (%2m)", typeOf _veh, (getMarkerPos "marker_respawn") distance2d _basePos]] call NNS_fnc_debugOutput; //debug
			waitUntil {sleep BIS_spawnInterval; (isNull _veh) || {(allPlayers findIf {(_x distance2d (getPos _veh)) > BIS_deletionDistance} != -1)}}; //NNS : wait until all players are far away
			if (!isNull _veh) then {deleteVehicle _veh}; //delete vehicle if still exist
		};
	};
} forEach _vehicle_near_respawn;

//BIS: Escape task for players
[BIS_grpMain, "objEscape", [localize "STR_NNS_task_main_desc", localize "STR_NNS_task_main_title", "<br/>"], objNull, TRUE] call BIS_fnc_taskCreate;

//NNS: spawning units/patrols/vehicles, based on BIS Escape from Malden
// Trigger text:
// GEN_civilCar, GEN_supportVeh, GEN_natoVeh, GEN_csatVeh
// NATO_patrolVeh, NATO_infantry, NATO_recon, NATO_sniper
// CSAT_patrolVeh, CSAT_infantry, CSAT_recon, CSAT_sniper

[] spawn {
	sleep 5; //needed to avoid troubles with vehicles spawned near respawn
	while {sleep BIS_spawnInterval; true} do { //loop to take account of recreated triggers
		{ //EmptyDetector loop
			_triggerText = toLower (triggerText _x); //trigger text
			_triggerTextSplit = _triggerText splitString "_"; //split text
			_triggerTextPre = ""; _triggerTextPost = "";
			if (count _triggerTextSplit > 0) then {
				_triggerTextPre = _triggerTextSplit select 0;
				_triggerTextPost = _triggerTextSplit select 1;
			};
			
			if (_triggerTextPre == "gen") then { //spawn vehicle, civilian if invalid text
				[_x, _triggerTextPost] spawn {
					params [["_trigger", ObjNull], ["_textPost",""]]; //params
					_pos = getPos _trigger; //trigger position
					_dir = (triggerArea _trigger) select 2; //trigger direction
					_text = triggerText _trigger; //trigger text, used for debug
					deleteVehicle _trigger; //delete trigger
					
					waitUntil {sleep (BIS_spawnInterval + (random BIS_spawnIntervalRnd)); allPlayers findIf {(_x distance2d _pos) < BIS_spawnDistance} != -1}; //some players near trigger
					
					_vehClass = []; //class to use
					_clearCargo = true;
					if (_textPost == "supportveh") then {_vehClass = BIS_supportVehicles};
					if (_textPost == "natoveh") then {_vehClass = BIS_natoVehicles; _clearCargo = false};
					if (_textPost == "csatveh") then {_vehClass = BIS_csatVehicles; _clearCargo = false};
					
					_veh = [_pos,_dir,_vehClass,[],0.1 + (random 0.1),false,false,0,0,[],0,_clearCargo] call NNS_fnc_spawnCivVehi; //spawn vehicle
					
					[format["'%1': '%2' spawned, cargo clear:%3 (%4m)", _text, typeOf _veh, _clearCargo, (leader BIS_grpMain) distance2d _pos]] call NNS_fnc_debugOutput; //debug
					waitUntil {sleep BIS_spawnInterval; (isNull _veh) || {(allPlayers findIf {(_x distance2d (getPos _veh)) > BIS_deletionDistance} != -1)}}; //NNS : wait until all players are far away
					if (!isNull _veh) then {deleteVehicle _veh}; //delete vehicle if still exist
				};
			};
			
			if (_triggerTextPre in BIS_spawnAllowed) then { //spawn "military" units/vehicles
				[_x, _triggerTextPre, _triggerTextPost] spawn {
					params [["_trigger", ObjNull], ["_textPre",""], ["_textPost",""]]; //params
					_pos = getPos _trigger; //trigger position
					_dir = (triggerArea _trigger) select 2; //trigger direction
					_rad = (triggerArea _trigger) select 0; //trigger radius
					_text = triggerText _trigger; //trigger text, used for debug
					
					_wpPath = grpNull;
					_syncUnit = synchronizedObjects _trigger; //get synchronized objects
					if (count _syncUnit > 0) then { //has synchronized objects
						_wpPath = group (_syncUnit select 0); //synchronized civilian unit is used as waypoint storage
						deleteVehicle (_syncUnit select 0); //delete synchronized unit
					};
					
					deleteVehicle _trigger; //delete trigger
					
					waitUntil {sleep (BIS_spawnInterval + (random BIS_spawnIntervalRnd)); allPlayers findIf {(_x distance2d _pos) < BIS_spawnDistance} != -1}; //some players near trigger
					
					_infSide = missionNamespace getVariable [format ["BIS_%1Side",_textPre], civilian]; //units side
					_infSideStr = missionNamespace getVariable [format ["BIS_%1SideStr",_textPre], "Civ"]; //units side string
					_infFaction = missionNamespace getVariable [format ["BIS_%1Faction",_textPre], "Civ_F"]; //units faction
					
					if (_textPost == "patrolveh") then { //spawn patrol
						_cargoLimiter = missionNamespace getVariable ["BIS_ammoboxAmount",[0.75,1]]; //recover ammobox limiter values
						
						_vehClass = missionNamespace getVariable [format ["BIS_%1Vehicles",_textPre], []]; //vehicle class to use
						_infClass = missionNamespace getVariable [format ["BIS_%1CrewUnits",_textPre], "C_man_1"]; //units class as crew if needed
						
						if (count _vehClass > 0) then {
							_vehPos = [_pos, 0, 50, 10, 0, 0.7, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos; //try to found safe place for vehicle
							_veh = [_vehPos,_dir,_vehClass,[],0.1 + (random 0.1),false,false,0,0,[],0,false] call NNS_fnc_spawnCivVehi; //spawn vehicle
							createVehicleCrew _veh; //create vehicle crew
							_vehCrew = crew _veh; //get vehicle crew
							_vehGroup = group (_vehCrew select 0); //get vehicle crew group
							if (count (units _vehGroup) < 2) then { //probably unarmed lsv, fill missing units
								while {count (units _vehGroup) < 4} do {
									_unit = _vehGroup createUnit [selectRandom _infClass, [0,0,0], [], 0, "CAN_COLLIDE"]; //create unit
									_unit moveInCargo _veh; //move to vehicle
									[_unit] orderGetIn true; //force unit to get in vehicle
								};
							};
									
							[format["'%1': '%2' spawned (%3m)", _text, typeOf _veh, (leader BIS_grpMain) distance2d _pos]] call NNS_fnc_debugOutput; //debug
							
							if (!isNull _wpPath) then {_vehGroup copyWaypoints _wpPath; deleteGroup _wpPath}; //had synchronized unit, copy waypoints, delete synchronized group 
							[_veh, _cargoLimiter select 0, _cargoLimiter select 1] call NNS_fnc_AmmoboxLimiter; //limit vehicle cargo content
							_veh setUnloadInCombat [false,false]; //disable getting out in combat
							if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh allowCrewInImmobile true}; // Handle immobilization
							{[_x] call NNS_fnc_AIskill} forEach (units _vehGroup); //set skills for each units
							
							_vehGroup enableDynamicSimulation true; //enable dynamic simulation
							
							if ((random 1 < 0.35) && {!(missionNamespace getVariable ["BIS_LimitEnemyCount",false])}) then { //maybe spawn a second vehicle
								if ((["_mrap_", typeOf _veh, false] call BIS_fnc_inString) || (["_lsv_", typeOf _veh, false] call BIS_fnc_inString)) then { //valid type
									_vehPos2 = [_pos, 0, 50, 10, 0, 0.7, 0, [], [_pos, _pos]] call BIS_fnc_findSafePos; //try to found safe place for vehicle
									_veh2 = [_vehPos2,_dir,_vehClass,[],0.1 + (random 0.1),false,false,0,0,[],0,false] call NNS_fnc_spawnCivVehi; //spawn vehicle
									createVehicleCrew _veh2; //create vehicle crew
									_vehCrew2 = crew _veh2; //get vehicle crew
									_vehGroup2 = group (_vehCrew2 select 0); //get vehicle crew group
									if (count (units _vehGroup2) < 2) then { //probably unarmed lsv
										while {count (units _vehGroup2) < 4} do {
											_unit = _vehGroup2 createUnit [selectRandom _infClass, [0,0,0], [], 0, "CAN_COLLIDE"]; //create unit
											_unit moveInCargo _veh2; //move to vehicle
											[_unit] orderGetIn true; //force unit to get in vehicle
										};
									};
									
									(units _vehGroup2) joinSilent _vehGroup; //move second group to the first one
									deleteGroup _vehGroup2; //delete second group
									
									[format["'%1': '%2' spawned (%3m)", _text, typeOf _veh2, (leader BIS_grpMain) distance2d _pos]] call NNS_fnc_debugOutput; //debug
									
									[_veh2, _cargoLimiter select 0, _cargoLimiter select 1] call NNS_fnc_AmmoboxLimiter; //limit vehicle cargo content
									_veh2 setUnloadInCombat [false,false]; //disable getting out in combat
									if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh2 allowCrewInImmobile true}; // Handle immobilization
									{[_x] call NNS_fnc_AIskill} forEach (units _vehGroup2); //set skills for each units
									
									_vehGroup2 enableDynamicSimulation true; //enable dynamic simulation
								};
							};
						};
					} else { //spawn units
						_infClass = ""; //class to use
						if (_textPost == "infantry") then {_infClass = selectRandom (missionNamespace getVariable [format ["BIS_%1Infantry",_textPre], [""]])};
						if (_textPost == "recon") then {_infClass = selectRandom (missionNamespace getVariable [format ["BIS_%1Recon",_textPre], [""]])};
						if (_textPost == "sniper") then {_infClass = selectRandom (missionNamespace getVariable [format ["BIS_%1Sniper",_textPre], [""]])};
						
						if !(_infClass == "") then {
							_newGrp = grpNull;
							_newGrp = [_pos, _infSide, configfile >> "CfgGroups" >> _infSideStr >> _infFaction >> "Infantry" >> _infClass, [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
							_newGrp deleteGroupWhenEmpty true; //Mark for auto deletion, not work?
							_newGrp enableDynamicSimulation true; //Enable Dynamic simulation
							
							[format["'%1': '%2' spawned (%3m)", _text, _newGrp, (leader BIS_grpMain) distance2d _pos]] call NNS_fnc_debugOutput; //debug
							
							{
								if (BIS_enemyEquipment == 1) then {_x execVM "Scripts\LimitEquipment.sqf"}; //Limit unit equipment if set by server
								[_x] call NNS_fnc_AIskill; //set unit skill
							} forEach (units _newGrp);
							
							_willStalk = (random 1) > 0.65;
							_toStalk = objNull;
							if (_willStalk) then { //try to stalk player or ennemy
								if (BIS_playerSide == _infSide) then {_toStalk = [units _newGrp select 0, BIS_spawnDistance] call NNS_fnc_FoundNearestEnemy; //players are friendly, stalk enemy units
								} else {_toStalk = leader BIS_grpMain}; //players are enemies, stalk them
							};
							
							if (!isNull _toStalk) then {
								[_newGrp,group _toStalk] spawn BIS_fnc_stalk; //stalk
								[format["'%1' stalk '%2'", _text, group _toStalk]] call NNS_fnc_debugOutput; //debug
							} else { //simple patrol
								{_wp = _newGrp addWaypoint [[_pos select 0, _pos select 1, 0], _rad]; _wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE"} forEach [1, 2, 3, 4, 5]; //add waypoints
								_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0]; _wp setWaypointType "CYCLE"; //cycle waypoint
							};
							
							[_newGrp, _pos, _rad, _text] spawn {
								params [["_grp", grpNull], ["_trgPos",[0,0,0]], ["_trgRad",100], ["_trgText",""]]; //params
								waitUntil {sleep BIS_spawnInterval; allPlayers findIf {(_x distance2d (leader _grp)) > BIS_deletionDistance} != -1}; //wait until all players are far away
								if (!isNull _grp) then {{deleteVehicle _x;} forEach (units _grp); deleteGroup _grp}; //delete units from group and delete group
								
								//recreate trigger
								_newtrg = createTrigger ["EmptyDetector", _trgPos, true];
								_newtrg setTriggerArea [_trgRad, _trgRad, 0, false];
								_newtrg setTriggerText _trgText;
								[format["Trigger '%1' recreated at %2",_trgText,_trgPos]] call NNS_fnc_debugOutput; //debug
							};
						} else {[format["'%1': invalid trigger text (%2m)", _text, (leader BIS_grpMain) distance2d _pos]] call NNS_fnc_debugOutput}; //invalid text, debug
					};
				};
			};
		} forEach (allMissionObjects "EmptyDetector");
	};
};

// Check if the players are escaping
missionNamespace setVariable ["BIS_Escaped",false,true];

[] spawn {
	while {!(BIS_Escaped)} do {
		sleep 5;
		{if ((((vehicle _x in list BIS_getaway_area_1) || (vehicle _x in list BIS_getaway_area_2) || (vehicle _x in list BIS_getaway_area_3) || (vehicle _x in list BIS_getaway_area_4)) && ((vehicle _x isKindOf "Ship") || (vehicle _x isKindOf "Air"))) || (missionNamespace getVariable ["Debug_Win",false]))} forEach (allPlayers) then { //NNS : rework winning condition, original one allow you to win in some case if soldier was in a destroyed heli
			_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
			["objEscape", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",BIS_playerSide,true]; //success
			["success", true, 5] remoteExec ["BIS_fnc_endMission",BIS_playerSide,true]; //call end mission
			missionNamespace setVariable ["BIS_Escaped",true,true]; //trigger to kill loop
		};
	};
};

if (BIS_EscapeRules == 0) then { //NNS: Original rules -> Mission fail if everyone is dead
	[] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} == -1}; //check if all players dead
		_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
		["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",BIS_playerSide,true]; //failed
		["end1", false, 5] remoteExec ["BIS_fnc_endMission",BIS_playerSide,true]; //call end mission
	};
};

//NNS: Mission fail if all player tickets = 0 && tickets not unlimited
if (!([BIS_playerSide] call BIS_fnc_respawnTickets == -1) || !(missionNamespace getVariable ["BIS_respawnTickets",-1] == -1)) then {
	[] spawn {
		if !(missionNamespace getVariable ["BIS_respawnTickets",-1] == 0) then {sleep 120;}; //wait 2min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		while {sleep 5; !(BIS_Escaped)} do {
			_remainingTickets = 0;
			{
				_tmpTickets = [_x] call BIS_fnc_respawnTickets; //recover player remaining ticket
				_remainingTickets = _remainingTickets + _tmpTickets; //add to group tickets
			} forEach (units BIS_grpMain);
			
			if (_remainingTickets < 0) then {_remainingTickets = [BIS_playerSide] call BIS_fnc_respawnTickets;}; //ticket but group
			if (_remainingTickets == 0) then { //no more ticket remaining
				_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
				["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",BIS_playerSide,true]; //failed
				["end1", false, 5] remoteExec ["BIS_fnc_endMission",BIS_playerSide,true]; //call end mission
				BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
			};
		};
	};
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

//NNS: add pick action to all fuel canister on map
{
	[_x, [localize "STR_NNS_TakeFuelCanister", {(_this select 1) setVariable ["haveCanister", true]; deleteVehicle (_this select 0);}, nil, 1.5, true, true, "", "[true, false] select (player getVariable ['haveCanister', false])", 2]] remoteExec ["addAction", 0, true];
} forEach nearestObjects [[5250,5780,0], ["Land_CanisterFuel_F"], 8000];

//NNS: Handle player disconnect
addMissionEventHandler ["HandleDisconnect", {
	deleteVehicle (_this select 0); //delete AI
}];

//NNS: stats : longest kill / weapon used per player
addMissionEventHandler ["EntityKilled", {
	params ["_killed", "_killer", "_instigator"];
	
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
}];

//NNS: stats : backup players stats, used to restore stat if player lose connection or crash and join back
[] spawn {
	_playersStatsIndex = []; //contain players ID
	_playersStatsLastUpdate = []; //last update time
	_playersStats = []; //contain players stats
	while {sleep 5; true} do {
		//{if (alive _x) then {deletevehicle _x;};} forEach (units BIS_grpMain); //delete AI units, in case someone disconnected
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

//NNS: Move spawn point
[] spawn {
	sleep 5;
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	_lastRespawnPos = [0,0,0];
	while {true} do {
		if !(getMarkerColor "marker_respawn" == "") then { //initial respawn marker still exist
			_ignorePlayers = [];
			{if (_x getVariable ["recovery",false]) then {_ignorePlayers pushBack _x;};} forEach (units BIS_grpMain); //add to ignore list
			_lastRespawnPos = [BIS_grpMain, _lastRespawnPos, _ignorePlayers] call NNS_fnc_groupCenter; //get group center
			if !(getMarkerColor "marker_respawn" == "") then {"marker_respawn" setMarkerPos _lastRespawnPos;}; //move respawn marker
		};
		sleep 5;
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


//NNS: Beginning of test part



/*
//populate buildings
[] spawn {
	_unitsCsat01 = tower_csat_01 call NNS_fnc_populateTower_Csat;
	_unitsCsat02 = towerbunker_csat_01 call NNS_fnc_populateBagBunkerTower_Csat;
	_unitsCsat03 = post_csat_01 call NNS_fnc_populatePost_Csat;
	_unitsCsat04 = hq_csat_01 call NNS_fnc_populateCargoHQ_Csat;
	_unitsNato01 = tower_nato_01 call NNS_fnc_populateTower_Nato;
	_unitsNato02 = towerbunker_nato_01 call NNS_fnc_populateBagBunkerTower_Nato;
	_unitsNato03 = post_nato_01 call NNS_fnc_populatePost_Nato;
	_unitsNato04 = hq_nato_01 call NNS_fnc_populateCargoHQ_Nato;

	_unitsTmp = _unitsCsat01 + _unitsCsat02 + _unitsCsat03 + _unitsCsat04 + _unitsNato01 + _unitsNato02 + _unitsNato03 + _unitsNato04;
	{_x allowDamage false} forEach _unitsTmp; //disable damage
	
	//add equipment to building
	tower_01 call NNS_fnc_CargoTower_Equipments;
	hq_01 call NNS_fnc_CargoHQ_Equipments;
	
	while {sleep 10; true} do {
		{_x setUnitLoadout (configFile >> "CfgVehicles" >> typeOf _x)} forEach _unitsTmp; //refill unit ammo
	};
	
};
*/

//damage vehicle
[] spawn {
	[testvehi01,["hitfuel"],0.3,0.7] call NNS_fnc_randomVehicleDamage;
};

//damage map buildings around marker_destroyZone marker
[] spawn {
	[getMarkerPos "marker_destroyZone",650] call NNS_fnc_destroyZone;
};

//spawn vehicle on road (simple)
[] spawn {
	[getMarkerPos "MarkerSpawnVehiRoadSimple",25,false,[],25,10,0.5,0.7,0,1,true,[],true] call NNS_fnc_spawnVehicleOnRoad;
};

//spawn vehicle on road (advanced)
[] spawn {
	[getPos spawnVehicleOnRoadUnit,25,false,[],200,100,0.5,0.7,0,1,true,[],true,spawnVehicleOnRoadUnit,true] call NNS_fnc_spawnVehicleOnRoad_Adv;
};

//spawn flare
[] spawn {
	while {sleep 25; true} do {
		if !(sunOrMoon == 1) then { //moon time
			[getMarkerPos "marker_testflare"] remoteExec ["NNS_fnc_spawnFlare"]; //remoteexec flare
			sleep 25; //wait for the flare to die
		} else {sleep 60}; //long wait
	};
};

//helicopter support landing demo
[] spawn {
	//{player setPos [7957,9862]; player setDir 270} forEach allPlayers;
	
	[requestGhosthawkSupportObj, ["request Ghosthawk (NATO)", {[[[7957,9862],"ghosthawk",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	[requestHummingbirdSupportObj, ["request Hummingbird (NATO)", {[[[7957,9862],"hummingbird",nil,configNull,false,false,BIS_grpMain], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	[requestHuronSupportObj, ["request Huron (NATO)", {[[[7957,9862],"huron",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
	[requestOrcaSupportObj, ["request Orca (CSAT)", {[[[7957,9862],"orca",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	[requestTaruSupportObj, ["request Taru (CSAT)", {[[[7957,9862],"taru",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	[requestMi48SupportObj, ["request Mi48 (CSAT)", {[[[7957,9862],"mi48",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
	[requestCustomSupportObj, ["request I_Heli_light_03_dynamicLoadout_F (Ind)", {[[[7957,9862],"I_Heli_light_03_dynamicLoadout_F",nil,configNull,false,false], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
	[requestHummingbirdCsatSupportObj, ["request Hummingbird with CSAT units", {[[[7957,9862],"hummingbird",east,configNull,false,false, BIS_grpMain], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
	[requestM900WestSupportObj, ["request M-900 (civ) with BLUFOR recon on Resistance side", {[[[7957,9862],"C_Heli_Light_01_civil_F", resistance, configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_ReconTeam",false , false, BIS_grpMain], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
	[requestMi48ParaSupportObj, ["request Mi48 (CSAT) Paradrop with waypoints", {[[[7957,9862],"mi48",nil,configNull,true,false,grpNull,paradropWaypointStorage], "scripts\HeliSupportLanding.sqf"] remoteExec ["execVM", 2]}]] remoteExec ["addAction", 0, true];
	
};

//display credits demo
[] spawn {
	//start credits
	[startCreditsObj, ["display credits (run once or glitch)", {[
		[[
		["bottom right","placeholder text",0],
		["bottom left","placeholder text",1],
		["top right","placeholder text",2],
		["top left","placeholder text<br/>with<br/>multiple<br/>lines",3],
		["<t font='PuristaBold' size='3'>Center</t>","preformatted title",4]
		]]
	, "scripts\Credits.sqf"] remoteExec ["execVM", 0]}]] remoteExec ["addAction", 0, true];
	
	//end credits
	[EndCreditsObj, ["display end credits (run once or glitch)", {
		_creditsArr = [[briefingName, getText (missionConfigFile >> "author")]]; //mission name and author
		_playersList = allPlayers; _playersList sort true; //get players list and sort it
		{_creditsArr pushBack ["", name _x, false]} forEach allPlayers; //add players to credits array as description
		_creditsArr set [1, [localize "str_mptable_players", _creditsArr select 1 select 1, false]]; //add localized "players" as first player title
		_missionImage = getText (missionConfigFile >> "overviewPicture"); //try to recover overviewPicture from Description.ext
		if (_missionImage == "") then {_missionImage = getText (missionConfigFile >> "loadScreen")}; //failed, try with loadScreen
		if (_missionImage == "") then {_missionImage = getText (configFile >> "CfgWorlds" >> worldName >> "pictureShot")}; //failed, try with default pictureShot from world class
		[[_creditsArr, _missionImage,-1,-1,-1,true] , "scripts\EndCredits.sqf"] remoteExec ["execVM", 0]
	}]] remoteExec ["addAction", 0, true];
};

//populate map buildings
[] spawn {
	//[1, west, ""] execVM "scripts\PopulateMapBuildings.sqf";
	//[1, west, configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"] execVM "scripts\PopulateMapBuildings.sqf";
	//[1, west, [configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> "BUS_InfSquad"]] execVM "scripts\PopulateMapBuildings.sqf";
	//[1, west, configfile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry", true] execVM "scripts\PopulateMapBuildings.sqf";
	[1, east, "", true] execVM "scripts\PopulateMapBuildings.sqf";
};

//vehicle lottery
[] spawn {
	[LotteryVehicleCommand, ["Try to win a vehicle", {missionNamespace setVariable ["LotteryVehReq", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryVehicleCommandReset, ["Reset", {missionNamespace setVariable ["LotteryVehRes", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryVehicleCommandForced, ["Try to win a vehicle (forced)", {missionNamespace setVariable ["LotteryVehRes", true, true]; missionNamespace setVariable ["LotteryVehReq", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryVehicleSpawner] execVM "scripts\LotteryVehicle.sqf";
};

//weapon lottery
[] spawn {
	player setPos [8036,10122,0];
	player setDir 270;
	[LotteryWeaponCommand, ["Try to win a weapon", {missionNamespace setVariable ["LotteryWpnReq", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryWeaponCommandReset, ["Reset", {missionNamespace setVariable ["LotteryWpnRes", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryWeaponCommandForced, ["Try to win a weapon (forced)", {missionNamespace setVariable ["LotteryWpnRes", true, true]; missionNamespace setVariable ["LotteryWpnReq", true, true]}]] remoteExec ["addAction", 0, true];
	[LotteryWeaponSpawner] execVM "scripts\LotteryWeapon.sqf";
};
