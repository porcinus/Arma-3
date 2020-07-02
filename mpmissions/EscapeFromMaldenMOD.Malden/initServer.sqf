/*
if (isNil {missionNamespace getVariable "CacheVilla_populated"}) then {missionNamespace setVariable ["CacheVilla_populated",false,true];};
if (isNil {missionNamespace getVariable "Airbase_populated"}) then {missionNamespace setVariable ["Airbase_populated",false,true];};
if (isNil {missionNamespace getVariable "Arudy_populated"}) then {missionNamespace setVariable ["Arudy_populated",false,true];};
if (isNil {missionNamespace getVariable "Island_populated"}) then {missionNamespace setVariable ["Island_populated",false,true];};
if (isNil {missionNamespace getVariable "Base_populated"}) then {missionNamespace setVariable ["Base_populated",false,true];};
if (isNil {missionNamespace getVariable "SouthEastBase_populated"}) then {missionNamespace setVariable ["SouthEastBase_populated",false,true];}; //from scratch
if (isNil {missionNamespace getVariable "Chapoi_populated"}) then {missionNamespace setVariable ["Chapoi_populated",false,true];};
if (isNil {missionNamespace getVariable "Dourdan_populated"}) then {missionNamespace setVariable ["Dourdan_populated",false,true];};
if (isNil {missionNamespace getVariable "Harbor_populated"}) then {missionNamespace setVariable ["Harbor_populated",false,true];};
if (isNil {missionNamespace getVariable "Houdan_populated"}) then {missionNamespace setVariable ["Houdan_populated",false,true];};
if (isNil {missionNamespace getVariable "Larche_populated"}) then {missionNamespace setVariable ["Larche_populated",false,true];};
if (isNil {missionNamespace getVariable "LaTrinite_populated"}) then {missionNamespace setVariable ["LaTrinite_populated",false,true];};
if (isNil {missionNamespace getVariable "SaintLouis_populated"}) then {missionNamespace setVariable ["SaintLouis_populated",false,true];};
if (isNil {missionNamespace getVariable "Pessagne_populated"}) then {missionNamespace setVariable ["Pessagne_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint01_populated"}) then {missionNamespace setVariable ["Checkpoint01_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint02_populated"}) then {missionNamespace setVariable ["Checkpoint02_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint03_populated"}) then {missionNamespace setVariable ["Checkpoint03_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint04_populated"}) then {missionNamespace setVariable ["Checkpoint04_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint05_populated"}) then {missionNamespace setVariable ["Checkpoint05_populated",false,true];};
if (isNil {missionNamespace getVariable "Checkpoint06_populated"}) then {missionNamespace setVariable ["Checkpoint06_populated",false,true];};
*/
if (isNil {missionNamespace getVariable "DebugMenu_level"}) then {missionNamespace setVariable ["DebugMenu_level","none",true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_enable"}) then {missionNamespace setVariable ["DebugOutputs_enable",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Chatbox"}) then {missionNamespace setVariable ["DebugOutputs_Chatbox",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "DebugOutputs_Logs"}) then {missionNamespace setVariable ["DebugOutputs_Logs",false,true];}; //used when description.ext debug entry disable
if (isNil {missionNamespace getVariable "Debug_Win"}) then {missionNamespace setVariable ["Debug_Win",false,true];}; //force win

//NNS : very important
"donotmoveoriginalcheckpointtriggers" setMarkerAlpha 0;

//NNS : delete all AI
{deletevehicle _x} forEach units BIS_grpMain;

// Definitions of vehicles and groups to be spawned
BIS_civilCars = ["C_Offroad_01_F","C_Quadbike_01_F","C_SUV_01_F","C_Van_01_transport_F","C_Truck_02_transport_F"];
BIS_supportVehicles = ["C_Van_01_fuel_F","C_Truck_02_fuel_F","C_Offroad_01_repair_F"];
BIS_NATOPatrols = ["EfM_W_Team01","EfM_W_Team02","EfM_W_Team03","EfM_W_Team04","EfM_W_Squad01","EfM_W_Squad02"];
BIS_FIAPatrols = ["EfM_E_Squad01"];

//NNS : Limit number of enemies by removing certain building
_null = [] execVM 'scripts\LimitEnemyCount.sqf';

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
"marker_0" setMarkerPos getMarkerPos _start_pos_rnd; //set marker position
"marker_respawn" setMarkerPos getMarkerPos _start_pos_rnd; //set initial respawn marker position
_initSpawn = [east,"marker_respawn","Respawn"] call BIS_fnc_addRespawnPosition; //set respawn
//respawnball setPos [(getMarkerPos _start_pos_rnd) select 0,(getMarkerPos _start_pos_rnd) select 1,0]; //object used for respawn position
//_initSpawn = [east,respawnball,"Respawn"] call BIS_fnc_addRespawnPosition; //set respawn

if (BIS_EscapeRules == 0) then { //NNS: Original rules -> Remove respawn after 5min
	[_initSpawn] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; allPlayers findIf {alive _x} != -1}; //check if at least one player alive
		deleteMarker "marker_respawn"; //remove respawn
		//deleteVehicle respawnball; //remove respawn
	};
};

//NNS : spawn all vehicles near respawn
_vehicle_near_respawn = (getMarkerPos "marker_respawn") nearObjects ['EmptyDetector', 150];
//_vehicle_near_respawn = getMarkerPos "marker_0" nearObjects ['EmptyDetector', 150];
{
	if (triggerText _x == "GEN_civilCar") then { // Civilian vehicles
		_dir = (triggerArea _x) select 2; if (_dir < 0) then {_dir = 360 + _dir};
		_veh = createVehicle [(selectRandom BIS_civilCars), position _x, [], 0, "NONE"];
		deleteVehicle _x; //remove trigger
		_veh setDir _dir;
		_veh setFuel (0.2 + (random 0.2));
		{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh];
		_veh addItemCargoGlobal ["FirstAidKit",1];
		_veh enableDynamicSimulation true;
	};
} forEach _vehicle_near_respawn;

// NNS : Checkpoints mover to "random" position
[] spawn {
	_checkpoint_01_pos = [[3979.0,4530.0,142.00],[3225.8,5359.3,326.22],[5101.4,3745.6,303.67]];
	_checkpoint_02_pos = [[7462.0,3811.0,223.00],[7061.2,3532.1,251.71]];
	_checkpoint_03_pos = [[4709.0,6658.0,192.00],[4855.6,6599.4,258.58],[3810.5,6425.0,295.16]];
	_checkpoint_04_pos = [[5248.0,9223.0,245.00],[4855.3,8178.5,8.26],[4961.1,8626.3,303.66]];
	_checkpoint_06_pos = [[2160.0,2739.0,355.00],[2011.9,2292.2,170.56],[2367.7,3509.9,349.56]];
	
	_checkpoint_01_pos_selected = _checkpoint_01_pos select (round random ((count _checkpoint_01_pos) - 1));
	_checkpoint_02_pos_selected = _checkpoint_02_pos select (round random ((count _checkpoint_02_pos) - 1));
	_checkpoint_03_pos_selected = _checkpoint_03_pos select (round random ((count _checkpoint_03_pos) - 1));
	_checkpoint_04_pos_selected = _checkpoint_04_pos select (round random ((count _checkpoint_04_pos) - 1));
	_checkpoint_06_pos_selected = _checkpoint_06_pos select (round random ((count _checkpoint_06_pos) - 1));
	
	_null = [BIS_checkpoint_01,[_checkpoint_01_pos_selected],80,true] execVM 'Scripts\ObjectGroupMover.sqf';
	_null = [BIS_checkpoint_02,[_checkpoint_02_pos_selected],75,true] execVM 'Scripts\ObjectGroupMover.sqf';
	_null = [BIS_checkpoint_03,[_checkpoint_03_pos_selected],62,true] execVM 'Scripts\ObjectGroupMover.sqf';
	_null = [BIS_checkpoint_04,[_checkpoint_04_pos_selected],60,true] execVM 'Scripts\ObjectGroupMover.sqf';
	_null = [BIS_checkpoint_06,[_checkpoint_06_pos_selected],75,true] execVM 'Scripts\ObjectGroupMover.sqf';
	
	{ //hide power lines, 200m radius
		{_x hideObjectGlobal true;} forEach nearestObjects [[_x select 0, _x select 1], ["PowerLines_Wires_base_F"], 200];
	} forEach [_checkpoint_01_pos_selected, _checkpoint_02_pos_selected, _checkpoint_03_pos_selected, _checkpoint_04_pos_selected, _checkpoint_06_pos_selected];
	
	missionNamespace setVariable ["markerListHide",["BIS_checkpoint_marker_01","BIS_checkpoint_marker_02","BIS_checkpoint_marker_03","BIS_checkpoint_marker_04","BIS_checkpoint_marker_05","BIS_checkpoint_marker_06","NNS_checkpoint_marker_01","NNS_checkpoint_marker_02","NNS_checkpoint_marker_03"],true]; //used to reveal some checkpoint when intel collected
	
	if (BIS_customObjectives!=0) then {{_x setMarkerAlpha 0;} forEach markerListHide;}; //hide all markers if custom objectives
};

// Delete empty groups
_deleteEmptyGrups = [] execVM "Scripts\DeleteEmptyGroups.sqf";

//NNS: Handle respawn of players - delete older corpse (so only one for each player can be present)
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

// Start special events if enabled
[] spawn {sleep 5; if (missionNamespace getVariable "BIS_specialEvents" == 1) then {_special_events = [10,15] spawn BIS_fnc_EfM_specialEvents;};};

// Limit equipment of already existing enemy units
[] spawn {if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{if ((side group _x == West) or (side group _x == Resistance)) then {_null = _x execVM "Scripts\LimitEquipment.sqf"}} forEach allUnits;};};

// Escape task for players
[BIS_grpMain, "objEscape", [format [localize "STR_A3_EscapeFromTanoa_tskEscapeDesc", "<br/>"], localize "STR_A3_EscapeFromMalden_tskEscapeTitle", "<br/>"], objNull, TRUE] call BIS_fnc_taskCreate;

// Initial music
[] spawn {sleep 15; "LeadTrack02_F_Jets" remoteExec ["playMusic",east,false];};

// Spawning NATO and FIA units/vehicles, empty transport and support vehicles
[] spawn {
	sleep 5; //needed to avoid troubles with vehicles spawned near respawn
	while {true} do { //loop to take account of recreated triggers
		{
			if (triggerText _x == "NATO_infantry") then { // NATO patrols
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 800} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (5 + (random 5)); ({(_x distance2d _basePos) < 800} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen

					[format["'NATO_infantry' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug
					
					//if ({side _x == west} count allGroups > 120) exitWith {["Too many WEST groups at the same time!"] call NNS_fnc_debugOutput;};

					_newGrp = grpNull;
					_newGrp = [_basePos, west, missionConfigFile >> "CfgGroups" >> "West" >> "BLU_F" >> "Infantry" >> (selectRandom BIS_NATOPatrols), [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;
					_newGrp deleteGroupWhenEmpty true; // Mark for auto deletion, not work?
					_newGrp enableDynamicSimulation true; // Enable Dynamic simulation

					// Limit unit equipment if set by server
					if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach units _newGrp};

					{[_x] call NNS_fnc_AIskill;} forEach (units _newGrp); //NNS: set skill
					//{_x setSkill ["AimingAccuracy",random 0.5]} forEach (units _newGrp); // Limit aiming accuracy

					if ((random 1) > 0.65) then {_stalk = [_newGrp,group (allPlayers select 0)] spawn BIS_fnc_stalk;
					} else {
						{_wp = _newGrp addWaypoint [_basePos, _rad]; _wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE";} forEach [1, 2, 3, 4, 5];
						_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
						_wp setWaypointType "CYCLE";
					};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1800} != -1}; //NNS : wait until all players are far away
					//waitUntil {sleep (15); ({(_x distance2d _basePos) > 1800} count allPlayers > 0)}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'NATO_infantry' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "NATO_infantry";
					[format["Trigger 'NATO_infantry' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};
			
			if (triggerText _x == "NATO_sniper") then { //NNS : NATO sniper team, was on trigger before
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 1000} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (5 + (random 5)); ({(_x distance2d _basePos) < 1000} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen
					
					[format["'NATO_sniper' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug

					_newGrp = [_basePos select 0,_basePos select 1] call BIS_fnc_EfM_sniperTeam;
					//if ({side _x == west} count allGroups > 120) exitWith {["Too many WEST groups at the same time!"] call NNS_fnc_debugOutput;};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1800} != -1}; //NNS : wait until all players are far away
					//waitUntil {sleep (15); ({(_x distance2d _basePos) > 1800} count allPlayers > 0)}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'NATO_sniper' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "NATO_sniper";
					[format["Trigger 'NATO_sniper' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};

			if (triggerText _x == "NATO_recon") then { //NNS : NATO recon team, was on trigger before
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 800} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (5 + (random 5)); ({(_x distance2d _basePos) < 800} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen
					
					[format["'NATO_recon' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug

					_newGrp = [_basePos select 0,_basePos select 1] call BIS_fnc_EfM_reconTeam;
					//if ({side _x == west} count allGroups > 120) exitWith {["Too many WEST groups at the same time!"] call NNS_fnc_debugOutput;};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1800} != -1}; //NNS : wait until all players are far away
					//waitUntil {sleep (15); ({(_x distance2d _basePos) > 1800} count allPlayers > 0)}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'NATO_recon' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "NATO_recon";
					[format["Trigger 'NATO_recon' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};
			
			if (triggerText _x == "FIA_infantry") then { //NNS : FIA patrols (friendly)
				_x spawn {
					_basePos = position _this;
					_rad = (triggerArea _this) select 0;
					deleteVehicle _this;

					waitUntil {sleep (12 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 800} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (12 + (random 5)); ({(_x distance2d _basePos) < 800} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen
					
					[format["'FIA_infantry' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug

					//if ({side _x == east} count allGroups > 120) exitWith {["Too many EAST groups at the same time!"] call NNS_fnc_debugOutput;};

					_newGrp = grpNull;
					_newGrp = [_basePos, east, missionConfigFile >> "CfgGroups" >> "East" >> "OPF_G_F" >> "Infantry" >> (selectRandom BIS_FIAPatrols), [], [], [0.2, 0.3]] call BIS_fnc_spawnGroup;

					//Convert Demolisher to AA
					{if (typeOf _x == "O_G_Soldier_exp_F") then {clearAllItemsFromBackpack _x; removeBackpack _x; _x addWeapon "launch_B_Titan_tna_F"; _x addSecondaryWeaponItem "Titan_AA"; _x addBackpack "B_FieldPack_blk"; for "_i" from 1 to 2 do {_x addItemToBackpack "Titan_AA";}; [_x] joinSilent _newGrp;};} forEach (units _newGrp); 

					_newGrp deleteGroupWhenEmpty true; // Mark for auto deletion, not work?
					_newGrp enableDynamicSimulation true; // Enable Dynamic simulation
					
					// Limit unit equipment if set by server
					if (missionNamespace getVariable "BIS_enemyEquipment" == 1) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach units _newGrp};

					{[_x] call NNS_fnc_AIskill;} forEach (units _newGrp); //NNS: set skill
					//{_x setSkill ["AimingAccuracy",random 0.5]} forEach (units _newGrp); // Limit aiming accuracy
					
					_tmp_nearest_enemy = [units _newGrp select 0, 800] call NNS_fnc_FoundNearestEnemy; //found nearest enemy
					if !(_tmp_nearest_enemy isEqualTo objNull) then {
						_stalk = [_newGrp,group _tmp_nearest_enemy] spawn BIS_fnc_stalk;
					} else {
						{_wp = _newGrp addWaypoint [_basePos, _rad]; _wp setWaypointType "MOVE"; _wp setWaypointSpeed "LIMITED"; _wp setWaypointBehaviour "SAFE";} forEach [1, 2, 3, 4, 5];
						_wp = _newGrp addWaypoint [waypointPosition [_newGrp, 1], 0];
						_wp setWaypointType "CYCLE";
					};
					
					waitUntil {sleep (15); allPlayers findIf {(_x distance2d _basePos) > 1800} != -1}; //NNS : wait until all players are far away
					//waitUntil {sleep (15); ({(_x distance2d _basePos) > 1800} count allPlayers > 0)}; //NNS : wait until all players are far away
					if !(isNull _newGrp) then {{_x setDamage [1, false];} forEach (units _newGrp);}; //NNS : kill units from group
					[format["'FIA_infantry' group:%1 killed because too far from player",_newGrp]] call NNS_fnc_debugOutput; //debug
					
					//recreate trigger
					_newtrg = createTrigger ["EmptyDetector", _basePos, true];
					_newtrg setTriggerArea [_rad, _rad, 0, false];
					_newtrg setTriggerText "FIA_infantry";
					[format["Trigger 'FIA_infantry' recreated at %1",_basePos]] call NNS_fnc_debugOutput; //debug
				};
			};
			
			if (triggerText _x == "NATO_patrolVeh") then { // NATO patrolling vehicles
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2; if (_dir < 0) then {_dir = 360 + _dir};
					_vehType = (triggerStatements _this) select 1;
					_wpPath = group ((synchronizedObjects _this) select 0);	// synchronized civilian unit is used as waypoint storage
					deleteVehicle ((synchronizedObjects _this) select 0);
					deleteVehicle _this;

					waitUntil {sleep (2.5 + (random 2.5)); allPlayers findIf {(_x distance2d _basePos) < 800} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (2.5 + (random 2.5)); ({(_x distance _basePos) < 800} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen

					[format["'NATO_patrolVeh' spawned (%1m)",player distance2d _basePos]] call NNS_fnc_debugOutput; //debug

					_vehClass = switch (_vehType) do {
						case "MRAP": {selectRandom ["B_MRAP_01_gmg_F","B_MRAP_01_hmg_F"]};
						case "APC": {"B_APC_Tracked_01_rcws_F"};
						case "IFV": {"B_APC_Wheeled_01_cannon_F"};
						case "AAA": {"B_APC_Tracked_01_AA_F"};
						case "LSV": {"B_LSV_01_armed_F"};
						case "LSVU": {"B_LSV_01_unarmed_F"};
						case "UGV": {"B_UGV_01_rcws_F"};
						case "Boat": {"B_Boat_Armed_01_minigun_F"};
						default {"B_LSV_01_armed_F"};
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
					_veh setFuel (0.2 + random 0.2);
					_veh setVehicleAmmo (0.4 + random 0.4);

					// If the vehicle is unarmed LSV, create crew for FFV positions and disable getting out in combat
					if (_vehType == "LSVU") then {
						_veh setUnloadInCombat [false,false];
						_unit01 = _vehGroup createUnit ["B_Soldier_AR_F", [0,0,0], [], 0, "CAN_COLLIDE"];
						_unit01 moveInCargo _veh; [_unit01] orderGetIn true;
						_unit02 = _vehGroup createUnit [selectRandom ["B_Soldier_GL_F","B_Soldier_F"], [0,0,0], [], 0, "CAN_COLLIDE"];
						_unit02 moveInCargo _veh; [_unit02] orderGetIn true;
						_unit03 = _vehGroup createUnit ["B_Soldier_F", [0,0,0], [], 0, "CAN_COLLIDE"];
						_unit03 moveInCargo _veh; [_unit03] orderGetIn true;
						_vehCrew = crew _veh;
					};

					if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh allowCrewInImmobile true;}; // Handle immobilization

					// Chance to create a second vehicle of the same type - only for armed LSV and UGV
					if ((_vehType in ["MRAP","LSV","LSVU"]) && {random 100 < 35} && {!BIS_LimitEnemyCount}) then { //NNS : was disable before
						_veh02 = createVehicle [_vehClass, [(_basePos select 0) - 7, (_basePos select 1) - 7, 0], [], 0, "NONE"];
						_veh02 setDir _dir;
						createVehicleCrew _veh02;
						_veh02Crew = crew _veh02;
						_veh02Crew joinSilent _vehGroup;

						{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh02];
						_veh02 addItemCargoGlobal ["FirstAidKit",2];
						_veh02 setFuel (0.2 + random 0.2);
						_veh02 setVehicleAmmo (0.4 + random 0.4);

						if (missionNamespace getVariable "BIS_crewInImmobile" == 1) then {_veh02 allowCrewInImmobile true;}; // Handle immobilization
					};

					// Limit unit equipment if set by server
					if ((missionNamespace getVariable "BIS_enemyEquipment" == 1) and {_vehType != "UGV"}) then {{_null = _x execVM "Scripts\LimitEquipment.sqf"} forEach (units _vehGroup)};

					{[_x] call NNS_fnc_AIskill;} forEach (units _vehGroup); //NNS: set skill
					//{_x setSkill ["AimingAccuracy",random 0.25]} forEach (units _vehGroup); // Limit aiming accuracy
					_vehGroup enableDynamicSimulation true; // Enable Dynamic simulation
				};
			};

			if (triggerText _x == "GEN_civilCar") then { // Civilian vehicles
				_x spawn {
					_basePos = position _this;
					_dir = (triggerArea _this) select 2; if (_dir < 0) then {_dir = 360 + _dir};
					deleteVehicle _this;
					waitUntil {sleep (5 + (random 5)); allPlayers findIf {(_x distance2d _basePos) < 600} != -1}; //random is here to limit CPU usage when detection happen
					//waitUntil {sleep (5 + (random 5)); ({(_x distance _basePos) < 600} count allPlayers > 0)}; //random is here to limit CPU usage when detection happen
					_veh = createVehicle [(selectRandom BIS_civilCars), _basePos, [], 0, "NONE"];
					_veh setDir _dir;
					_veh setFuel (0.2 + (random 0.2));
					{clearMagazineCargoGlobal _x; clearWeaponCargoGlobal _x; clearBackpackCargoGlobal _x; clearItemCargoGlobal _x} forEach [_veh];
					_veh addItemCargoGlobal ["FirstAidKit",1];
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
		
		{if ((((vehicle _x in list BIS_getaway_area_1) || (vehicle _x in list BIS_getaway_area_2) || (vehicle _x in list BIS_getaway_area_3) || (vehicle _x in list BIS_getaway_area_4)) && ((vehicle _x isKindOf "Ship") || (vehicle _x isKindOf "Air"))) || (missionNamespace getVariable ["Debug_Win",false]))} forEach (allPlayers) then { //NNS : rework winning condition, original one allow you to win in some case if soldier was in a destroyed heli
			_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
			["objEscape", "Succeeded"] remoteExec ["BIS_fnc_taskSetState",east,true]; //success
			["success"] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
			BIS_Escaped = true; publicVariable "BIS_Escaped"; //trigger to kill loop
		};
	};
};

if (BIS_EscapeRules == 0) then { //NNS: Original rules -> Mission fail if everyone is dead
	[] spawn {
		sleep 300; //wait 5min
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
		waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} == -1}; //check if all players dead
		//waitUntil {sleep 5; {alive _x} count (units BIS_grpMain) > 0}; //check if at least one player alive
		//waitUntil {sleep 5; {alive _x} count (units BIS_grpMain) == 0}; //check if all players dead
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

/*
[] spawn { //NNS: Mission fail if all player tickets = 0
	sleep 300; //wait 5min
	waitUntil {sleep 5; (units BIS_grpMain) findIf {alive _x} != -1}; //check if at least one player alive
	
	while {!(BIS_Escaped)} do {
		sleep 5;
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
*/
[] spawn { //NNS: Mission fail if all escape vehicle destroyed
	sleep 300; //wait 5min
	waitUntil {sleep 5; [BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05,BIS_EW06,BIS_EW07,BIS_EW08,BIS_EW09,BIS_EW10] findIf {canMove _x} == -1}; //check if all vehicles destroyed
	//waitUntil {sleep 5; {canMove _x} count [BIS_EW01,BIS_EW02,BIS_EW03,BIS_EW04,BIS_EW05,BIS_EW06,BIS_EW07,BIS_EW08,BIS_EW09,BIS_EW10] == 0}; //check if all vehicles destroyed
	_null = [false] call NNS_fnc_CompileDebriefingStats; //NNS : stats : Compile data from players
	["objEscape", "Failed"] remoteExec ["BIS_fnc_taskSetState",east,true]; //failed
	["end2", false] remoteExec ["BIS_fnc_endMission",east,true]; //call end mission
};

// Music when somebody gets into one of the escape vehicles
[] spawn {
	sleep 5;
	waitUntil {sleep 5; (units BIS_grpMain) findIf {(vehicle _x isKindOf "Air")} != -1};
	//waitUntil {sleep 5; {(vehicle _x isKindOf "Air")} count units BIS_grpMain > 0};
	5 fadeMusic 0.75;
	"LeadTrack01_F_Jets" remoteExec ["playMusic",east,false];
};

//NNS : Custom objectives
if (isNil "CustomObjectivesCreated") then {CustomObjectivesCreated=false;}; //publicVariable "CustomObjectivesCreated";

_custom_objectives_list = []; //will content all detected markers
_custom_objectives_selected_list = []; //will content all selected markers
_custom_objectives_toclean_list = []; //will content all detected markers marked for deletion
_custom_objectives_forced = [selectRandom ["collect_intel","collect_intel_2"],"sabotage_powerplant"]; //will be present all the time
_custom_objectives_types = [];

{
	if (markerText _x != "") then {
		_custom_objectives_list pushBack (markerText _x); _x setMarkerAlpha 0; //add marker to array and hide marker
		_custom_objectives_tmp = ((markerText _x) splitString "_") select 0; //extract type : clean,collect,destroy,eliminate,explore
		if !(_custom_objectives_tmp in _custom_objectives_types) then {_custom_objectives_types pushBack _custom_objectives_tmp;}; //add to type array
	} else {
		_x setMarkerColor "ColorPink"; //markers without name goes pink
	};
} forEach ((getMissionLayerEntities "Custom_Objectives") select 1); //scan all marker in "Custom_Objectives" layer
_custom_objectives_initial_count = count _custom_objectives_forced; //backup initial count

if (!CustomObjectivesCreated && BIS_customObjectives!=0 && (count _custom_objectives_list) > 0) then { //objectives need to be created
	{
		_custom_objectives_tmp = (_x splitString "_") select 0; //extract type
		if (_custom_objectives_tmp in _custom_objectives_types) then {_custom_objectives_types deleteAt (_custom_objectives_types find _custom_objectives_tmp);}; //delete from type array
		_custom_objectives_selected_list pushback _x; //add to selected array
		_custom_objectives_list deleteAt (_custom_objectives_list find _x); //delete from list array
	} forEach _custom_objectives_forced; //remove forced objectives from main list
	
	while {(count _custom_objectives_selected_list) < BIS_customObjectives && (count _custom_objectives_list) > 0} do { //not super effective but work
		_custom_objectives_rnd = _custom_objectives_list call BIS_fnc_selectRandom; //select random index
		_custom_objectives_tmp = (_custom_objectives_rnd splitString "_") select 0; //extract type
		
		if ((_custom_objectives_tmp in _custom_objectives_types) || {(count _custom_objectives_types) == 0}) then { //not already used type or type array empty
			_custom_objectives_selected_list pushback _custom_objectives_rnd; //add to selected array
			if (_custom_objectives_tmp in _custom_objectives_types) then {_custom_objectives_types deleteAt (_custom_objectives_types find _custom_objectives_tmp);}; //delete from type array
			_custom_objectives_list deleteAt (_custom_objectives_list find _custom_objectives_rnd); //delete from list array
		};
	};
	
	_custom_objectives_selected_list sort true; //sort objective by name
	
	{_custom_objectives_toclean_list pushBack _x;} forEach _custom_objectives_list; //add unused objective to cleanup list
	
	{
		_selected_custom_objectives = format ["Custom_Objectives\%1.sqf", _x]; //format filename
		[format["Objective : %1",_selected_custom_objectives]] call NNS_fnc_debugOutput; //debug
		_null = [] execVM _selected_custom_objectives;
	} forEach _custom_objectives_selected_list; //objectives loop
	
	{
		_selected_custom_objectives_toclean = format ["Custom_Objectives\%1_cleanup.sqf", _x]; //format filename
		[format["Objective cleanup : %1",_selected_custom_objectives_toclean]] call NNS_fnc_debugOutput; //debug
		_null = [] execVM _selected_custom_objectives_toclean;
	} forEach _custom_objectives_toclean_list; //unused objectives cleanup loop
	
	CustomObjectivesCreated = true;
}else{ //want no objective, clean everything
	{
		_selected_custom_objectives_toclean = format ["Custom_Objectives\%1_cleanup.sqf", _x]; //format filename
		[format["Objective cleanup : %1",_selected_custom_objectives_toclean]] call NNS_fnc_debugOutput; //debug
		_null = [] execVM _selected_custom_objectives_toclean;
	} forEach _custom_objectives_list; //objectives cleanup loop
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



