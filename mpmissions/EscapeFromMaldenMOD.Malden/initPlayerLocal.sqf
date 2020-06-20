//NNS : teleport to initial respawn position
if !(getMarkerColor "marker_respawn" == "") then {player setPos (getMarkerPos "marker_respawn"); //initial respawn still exist
} else {player setPos getPos (leader group player);}; //initial respawn don't exist, spawn on group leader

//NNS : more realistic aim
player setCustomAimCoef 0.75;
player setUnitRecoilCoefficient 0.70;
if (BIS_loadoutLevel == 0) then {player enablestamina false;}; //maraton mode

//NNS : allow player to heal and repair
if (BIS_loadoutLevel == 0) then {
	player setUnitTrait ["Medic",true];
	player setUnitTrait ["Engineer",true];
};

// Create diary for each player
_null = player createDiaryRecord ["Diary", [localize "str_a3_diary_execution_title", format ["%1%4%2%4%3",localize "STR_A3_EscapeFromTanoa_execution01",format [localize "STR_A3_EscapeFromMalden_execution02","</marker>", "<marker name = 'BIS_mrkAirbase'>","<marker name = 'BIS_mrkBase'>"],localize "STR_A3_EscapeFromTanoa_execution03","<br /><br />"]]];

// Add respawn tickets if set to individual unit
if (missionNamespace getVariable "BIS_respawnTickets" == 0) then {[player,1] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 1) then {[player,2] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 2) then {[player,3] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 3) then {[player,4] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 4) then {[player,5] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 5) then {[player,6] call BIS_fnc_respawnTickets};
if (missionNamespace getVariable "BIS_respawnTickets" == 10) then {[player,11] call BIS_fnc_respawnTickets};

// Handle JIP respawn
missionNamespace setVariable ["_initialRespawn", addMissionEventHandler ["PreloadFinished",
{
	if !(getMarkerColor "marker_respawn" == "") then {player setPos (getMarkerPos "marker_respawn"); //initial respawn still exist
	} else {player setPos getPos (leader group player);}; //initial respawn don't exist, spawn on group leader
	removeMissionEventHandler ["PreloadFinished", missionNamespace getVariable ["_initialRespawn", -1]];
	missionNamespace setVariable ["_initialRespawn", nil];

	if (didJIP and (time > 30)) then {
		player enableSimulationGlobal false;
		player enableSimulation false;
		player hideObjectGlobal true;
		player hideObject true;
		forceRespawn player;
		deleteVehicle player;
	};
}]];

//NNS : Add respawn inventories
if (BIS_loadoutLevel == 0 || {typeOf player == "O_Soldier_SL_F"}) then {[player,"O_SquadLeader"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_M_F"}) then {[player,"O_Marksman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_AR_F"}) then {[player,"O_Autorifleman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_GL_F"}) then {[player,"O_Grenadier"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_F"}) then {[player,"O_Rifleman"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_LAT_F"}) then {[player,"O_LAT"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_AA_F"}) then {[player,"O_AA"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_engineer_F"}) then {[player,"O_Engineer"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_medic_F"}) then {[player,"O_CombatLifesaver"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_HeavyGunner_F"}) then {[player,"O_HeavyGunner"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0 || {typeOf player == "O_soldier_AT_F"}) then {[player,"O_AT"] call BIS_fnc_addRespawninventory};
if (BIS_loadoutLevel == 0) then {[player,"O_Saved_Loadout"] call BIS_fnc_addRespawninventory};

//NNS : Player loadout from server selection
if (typeOf player == "O_Soldier_SL_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_SquadLeader");};
if (typeOf player == "O_soldier_M_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_Marksman");player addPrimaryWeaponItem "bipod_02_F_blk";};
if (typeOf player == "O_soldier_AR_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_Autorifleman");};
if (typeOf player == "O_soldier_GL_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_Grenadier");};
if (typeOf player == "O_soldier_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_Rifleman");};
if (typeOf player == "O_soldier_LAT_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_LAT");};
if (typeOf player == "O_soldier_AA_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_AA");};
if (typeOf player == "O_engineer_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_Engineer");};
if (typeOf player == "O_medic_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_CombatLifesaver");};
if (typeOf player == "O_HeavyGunner_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_HeavyGunner");};
if (typeOf player == "O_soldier_AT_F") then {player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> "O_AT");};

_null = execVM 'scripts\PlayerLimitEquipment.sqf'; //NNS : Limit equipment

//NNS : create and attach IR beam to right shoulder
//irbeam = "NVG_TargetC" createVehicle [0,0,0];
//irbeam attachTo [player, [0,-0.03,0.07], "RightShoulder"];
//irbeam hideObject true;

//NNS : Add icon on dead body
if (BIS_loadoutLevel == 0) then {
	addMissionEventHandler ["Draw3D", { // Draw onscreen icons
		 //icon on own dead body
		_oldBody = player getVariable ["BIS_oldBody",objNull];
		if !(_oldBody isEqualTo objNull) then {drawIcon3D ["\A3\ui_f\data\GUI\Cfg\Debriefing\endDeath_ca.paa",[1,0,0,0.3],ASLToAGL getPosASL _oldBody,1,1,0];};
		
		{ //unconscious player in group
			_dammage=getDammage _x; if (_dammage > 0.9 && {_dammage != 1}) then {drawIcon3D ["\A3\ui_f\data\IGUI\Cfg\Cursors\unitUnconscious_ca.paa",[1,0.5,0,0.7],ASLToAGL getPosASL _x,2,2,0];}
		} forEach units BIS_grpMain;
		
	}];
};

//NNS : add debug communications menu for player
if (DebugMenu_level == "anyone" || {(isServer && DebugMenu_level == "admin")}) then {[player, "Debug_Menu"] call BIS_fnc_addCommMenuItem;};

//NNS : add debug menu
//player addAction ["Debug command", "showCommandingMenu '#USER:MENU_COMMS_DEBUG'",cursorTarget, 0, true, true, "", ""];
//_null = execVM 'scripts\DebugMapTriggers.sqf';
//player allowDamage false;

//NNS : display stuff on map
[] spawn {_null = _this execVM "Scripts\CustomMapGraffiti.sqf";};

//NNS : backup loadout
if (BIS_loadoutLevel == 0) then {
	[] spawn {
		while {true} do {
			sleep 5;
			if (alive player && {(getDammage player) < 0.9}) then {player setVariable["tmp_saved_loadout",getUnitLoadout player];}; //NNS : save previous loadout
		};
	};
};

//NNS : stats : track distance traveled
[] spawn {
	player setVariable ["distance_traveled",[0,0]]; //foot, vehicle
	player setVariable ["distance_traveled_suspended",false]; //suspended if just respawned
	
	while {true} do {
		_oldPos = getPos player; sleep 5; //backup and wait 5 sec
		_distance = floor (_oldPos distance2D (getPos player)); //distance traveled
		_suspend = player getVariable ["distance_traveled_suspended",false]; //is suspended for 11sec if just respawned
		if (_distance > 0 && {_distance < 556} &&  {!_suspend}) then { //only log if player is alive and traveled distance not too excessive (200km/h)
			_distance_traveled = player getVariable ["distance_traveled",[0,0]]; //recover old value
			if (vehicle player == player) then {
				_new_distance = (_distance_traveled select 0) + _distance;
				_distance_traveled set [0, _new_distance]; //not in vehicle
			} else {
				_new_distance = (_distance_traveled select 1) + _distance;
				_distance_traveled set [1, _new_distance]; //in vehicle
			};
			player setVariable ["distance_traveled",_distance_traveled]; //update var
		};
	};
};

//NNS : stats : track ammo used
player setVariable ["shot_fired",[0,0,0,0,0]]; //bullet, grenade, smoke, rocket, from vehicle
player addeventhandler ["FiredMan", { //ammo not in grenades,smokes,missile are considered as bullets
	_shot_fired = player getVariable "shot_fired"; //recover old value
	if (vehicle player == player) then { // player not in vehicle
		_ammo_alloc = false; //right list found
		_list_grenades = ["G_40mm_HE","GrenadeHand","mini_Grenade"];
		_list_smokes = ["G_40mm_Smoke","G_40mm_SmokeRed","G_40mm_SmokeGreen","G_40mm_SmokeYellow","G_40mm_SmokePurple","G_40mm_SmokeBlue","G_40mm_SmokeOrange","SmokeShell","SmokeShellRed","SmokeShellGreen","SmokeShellYellow","SmokeShellPurple","SmokeShellBlue","SmokeShellOrange"];
		_list_rockets = ["R_PG32V_F","R_TBG32V_F","M_NLAW_AT_F","M_Titan_AA","M_Titan_AP","M_Titan_AT","M_Titan_AA_long","M_Titan_AT_long","M_Titan_AA_static","M_Titan_AT_static","R_PG7_F","R_MRAAWS_HEAT_F","R_MRAAWS_HE_F","R_MRAAWS_HEAT55_F"];
		if ((_this select 4) in _list_grenades) then {_ammo_alloc=true; _shot_fired set [1, (_shot_fired select 1) + 1];}; //grenade
		if ((_this select 4) in _list_smokes) then {_ammo_alloc=true; _shot_fired set [2, (_shot_fired select 2) + 1];}; //smoke
		if ((_this select 4) in _list_rockets) then {_ammo_alloc=true; _shot_fired set [3, (_shot_fired select 3) + 1];}; //rocket
		if (!_ammo_alloc) then {_shot_fired set [0, (_shot_fired select 0) + 1];} //random ammo
	} else {_shot_fired set [4, (_shot_fired select 4) + 1];}; //update shot from vehicle
	player setVariable ["shot_fired",_shot_fired]; //update var
}];

//NNS : drawable Whitebaord
[] spawn {
	sleep 60;
	_whiteboardObjects = missionNamespace getVariable ["NNS_WhiteboardDraw",[]];
	if (count _whiteboardObjects > 0) then {_null = [_whiteboardObjects,0.5,3,500,'b'] execVM "Scripts\DrawOnSurface.sqf";};
};