//NNS: Cinematic start
[] spawn {
	showHUD false; //hide UI
	["start_blackScreen",false] call BIS_fnc_blackOut; //black the screen
	[0, 0] spawn BIS_fnc_cinemaBorder; //cinematic border
	sleep 2;
	["start_blackScreen"] call BIS_fnc_blackIn; //black the screen
	sleep 1;
	[1] spawn BIS_fnc_cinemaBorder; //remove cinematic border
	showHUD true; //show UI
};

//NNS : varible to ignore unit for compute group center
player setVariable ["recovery",true,true];
[] spawn {sleep 10; player setVariable ["recovery",false,true];};

//NNS : teleport to initial respawn position
if !(getMarkerColor "marker_respawn" == "") then {
	[player, "marker_respawn"] call BIS_fnc_moveToRespawnPosition;
	//player setPos ((getMarkerPos "marker_respawn") getPos [5, random 360]); //initial respawn still exist
} else {
	[player, leader group player] call BIS_fnc_moveToRespawnPosition;
	//player setPos ((leader group player) getPos [5, random 360]);
}; //initial respawn don't exist, spawn on group leader

//NNS : more realistic aim
player setCustomAimCoef 0.75;
player setUnitRecoilCoefficient 0.70;
if !(BIS_stamina) then {player enablestamina false;};

//NNS : allow player to heal and repair
if (BIS_loadoutLevel < 2) then {player setUnitTrait ["Medic",true]; player setUnitTrait ["Engineer",true]};

// Create diary for each player
_null = player createDiaryRecord ["Diary", [localize "str_a3_diary_execution_title", format ["%1<br/><br/>%2<br/><br/>%3<br/><br/>%4<br/><br/>%5<br/><br/>%6",localize "STR_NNS_Escape_briefing_0",localize "STR_NNS_Escape_briefing_1",localize "STR_NNS_Escape_briefing_2",localize "STR_NNS_Escape_briefing_3",localize "STR_NNS_Escape_briefing_4",localize "STR_NNS_Escape_briefing_5"]]];

// Add respawn tickets if set to individual unit
_respawnTickets = missionNamespace getVariable ["BIS_respawnTickets",-1];
if !(_respawnTickets == -1) then {[player, _respawnTickets + 1] call BIS_fnc_respawnTickets;};

//NNS : Add respawn inventories / loadout from server selection
_playerClass = "O_Rifleman";
if (typeOf player == "O_Soldier_SL_F") then {_playerClass = "O_SquadLeader"};
if (typeOf player == "O_soldier_M_F") then {_playerClass = "O_Marksman"};
if (typeOf player == "O_soldier_AR_F") then {_playerClass = "O_Autorifleman"};
if (typeOf player == "O_soldier_GL_F") then {_playerClass = "O_Grenadier"};
if (typeOf player == "O_soldier_F") then {_playerClass = "O_Rifleman"};
if (typeOf player == "O_engineer_F") then {_playerClass = "O_Engineer"};
if (typeOf player == "O_medic_F") then {_playerClass = "O_CombatLifesaver"};
if (typeOf player == "O_HeavyGunner_F") then {_playerClass = "O_HeavyGunner"};
[player, _playerClass] call BIS_fnc_addRespawninventory; //set player respawn equipement
player setUnitLoadout (missionConfigFile >> "CfgRespawnInventory" >> _playerClass); //set player equipement
_null = execVM 'scripts\PlayerLimitEquipment.sqf'; //NNS : Limit equipment

//NNS : add debug communications menu for player
if (DebugMenu_level == "anyone" || {(isServer && DebugMenu_level == "admin")}) then {[player, "Debug_Menu"] call BIS_fnc_addCommMenuItem};

//NNS : display stuff on map
[] spawn {_null = _this execVM "Scripts\CustomMapGraffiti.sqf"};

//NNS : backup loadout
[] spawn {while {sleep 5; true} do {if (alive player && {(getDammage player) < 0.9}) then {player setVariable["tmp_saved_loadout",getUnitLoadout player]}}}; //NNS : save previous loadout

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
			if (vehicle player == player) then { _new_distance = (_distance_traveled select 0) + _distance; _distance_traveled set [0, _new_distance]; //not in vehicle
			} else {_new_distance = (_distance_traveled select 1) + _distance; _distance_traveled set [1, _new_distance]}; //in vehicle
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
		if ((_this select 4) in _list_grenades) then {_ammo_alloc=true; _shot_fired set [1, (_shot_fired select 1) + 1]}; //grenade
		if ((_this select 4) in _list_smokes) then {_ammo_alloc=true; _shot_fired set [2, (_shot_fired select 2) + 1]}; //smoke
		if ((_this select 4) in _list_rockets) then {_ammo_alloc=true; _shot_fired set [3, (_shot_fired select 3) + 1]}; //rocket
		if (!_ammo_alloc) then {_shot_fired set [0, (_shot_fired select 0) + 1]} //random ammo
	} else {_shot_fired set [4, (_shot_fired select 4) + 1]}; //update shot from vehicle
	player setVariable ["shot_fired",_shot_fired]; //update var
}];

//NNS : stats : set public stats accessible from map
[] spawn {
	while {sleep 5; true} do {
		_distance_traveled = player getVariable ["distance_traveled",[0,0]]; //foot, vehicle
		_shot_fired = player getVariable ["shot_fired",[0,0,0,0,0]]; //bullet, grenade, smoke, rocket, from vehicle
		player setVariable ["stats", [_shot_fired,_distance_traveled], true]; //public
	};
};

//NNS : stats : get players stats when map opened
addMissionEventHandler ["Map", {
	params ["_mapIsOpened", "_mapIsForced"];
	//systemChat format ["_mapIsOpened:%1, _mapIsForced:%2",_mapIsOpened,_mapIsForced];
	
	if (_mapIsOpened) then {
		private _nullRecord = objNull createDiaryRecord []; //"declare" _nullRecord
		_record = player getVariable ["TeamStatsRecord",_nullRecord]; //recover record
		if (!(player diarySubjectExists "TeamStats")) then {player createDiarySubject ["TeamStats", localize "STR_NNS_Escape_Debrif_Stats_title"];}; //subject not exist, create it
		if (_record isEqualTo _nullRecord) then { //record not exist
			_record = player createDiaryRecord ["TeamStats", [localize "STR_NNS_Escape_Debrif_Stats_team", localize "STR_NNS_Escape_Debrif_Stats_nodata"], taskNull, "", false]; //create record
			player setVariable ["TeamStatsRecord", _record]; //backup record
		};
		
		if !(_record isEqualTo _nullRecord) then { //record not null
			_players_stats = []; //store array
			_shot_fired_group = [0,0,0,0,0]; //store used ammo for whole group
			
			{ //players loop
				_tmpStats = _x getVariable ["stats",[]]; //recover player stats
				if (count _tmpStats == 2) then {
					_players_stats pushBack format["<font color='#99ffffff'>%1:</font><br/>",name _x]; //player name
					
					_shot_fired = _tmpStats select 0;
					_shot_fired_group set [0, (_shot_fired_group select 0) + (_shot_fired select 0)]; _shot_fired_group set [1, (_shot_fired_group select 1) + (_shot_fired select 1)]; _shot_fired_group set [2, (_shot_fired_group select 2) + (_shot_fired select 2)]; _shot_fired_group set [3, (_shot_fired_group select 3) + (_shot_fired select 3)]; _shot_fired_group set [4, (_shot_fired_group select 4) + (_shot_fired select 4)];
					_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired select 0),["","s"] select ((_shot_fired select 0) > 1),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired select 1),["","s"] select ((_shot_fired select 1) > 1)], ""] select ((_shot_fired select 1) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired select 2),["","s"] select ((_shot_fired select 2) > 1)], ""] select ((_shot_fired select 2) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired select 3),["","s"] select ((_shot_fired select 3) > 1)], ""] select ((_shot_fired select 3) == 0),
					[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired select 4),["","s"] select ((_shot_fired select 4) > 1)], ""] select ((_shot_fired select 4) == 0)];
					_players_stats pushBack "<br/>"; //linebreak
					
					_distance_traveled = _tmpStats select 1;
					_players_stats pushBack format[localize "STR_NNS_Debriefing_DistanceTravel_title",round (_distance_traveled select 0),
					[format[localize "STR_NNS_Debriefing_DistanceTravel_vehicle",round (_distance_traveled select 1),round ((_distance_traveled select 0)+(_distance_traveled select 1))], ""] select (round (_distance_traveled select 1) == 0)]; //distance traveled
					_players_stats pushBack "<img image='#(argb,8,8,3)color(1,1,1,0.1)' height='1' width='640' /><br/>"; //linebreak
				};
			} forEach allPlayers;
			
			if (count _players_stats > 0) then { //some data recovered, compile group data
				_players_stats pushBack format["<font color='#99ffffff'>%1:</font><br/>",localize "STR_NNS_Debriefing_GroupStats_title"]; //title
				_players_stats pushBack format[localize "STR_NNS_Debriefing_AmmoUsed_title",(_shot_fired_group select 0),["","s"] select ((_shot_fired_group select 0) > 1),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_HEgrenades",(_shot_fired_group select 1),["","s"] select ((_shot_fired_group select 1) > 1)], ""] select ((_shot_fired_group select 1) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_SmokeGrenade",(_shot_fired_group select 2),["","s"] select ((_shot_fired_group select 2) > 1)], ""] select ((_shot_fired_group select 2) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Rockets",(_shot_fired_group select 3),["","s"] select ((_shot_fired_group select 3) > 1)], ""] select ((_shot_fired_group select 3) == 0),
				[format[localize "STR_NNS_Debriefing_AmmoUsed_Vehicle",(_shot_fired_group select 4),["","s"] select ((_shot_fired_group select 4) > 1)], ""] select ((_shot_fired_group select 4) == 0)];
				
				player setDiaryRecordText [["TeamStats", _record], [localize "STR_NNS_Escape_Debrif_Stats_team", _players_stats joinString ""]];
			};
		};
	};
}];

//NNS : Vehicle light on when night time
player addEventHandler ["GetInMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	if !(sunOrMoon == 1) then { //moon time
		[_vehicle,"ON"] call BIS_fnc_NNS_vehicleLightOnOff; //restore headlights
		player action ["LightOn", _vehicle]; //turn on light
	};
}];

//NNS : Vehicle light blinking glitch fix
player addEventHandler ["GetOutMan", {
	params ["_unit", "_role", "_vehicle", "_turret"];
	if (local _vehicle) then { //vehicle is local
	//if ({(_x in _vehicle && {alive _x})} count allPlayers == 0) then { //no more player in vehicle
		[_vehicle,"OFF"] call BIS_fnc_NNS_vehicleLightOnOff; //destroy headlights
	};
	if !(sunOrMoon == 1) then {player action ["GunLightOn", player]}; //turn on flashlight if moon time
}];

//NNS: Add some ambience
[] spawn {
	while {sleep (30 + random 60); true} do {
		waitUntil {sleep 5; alive player; vehicle player == player}; //wait until player alive and not in vehicle
		_random = round (random 2); //random sound "bank"
		_soundPos = player getPos [0.5 + random 1, random 360];  //random sound position
		_soundObject = "#particlesource" createVehicleLocal _soundPos; //sound object
		_sound = ""; //default sound class
		if (_random == 0) then {_sound = format ["Scared_Animal%1", 1 + round (random 3)];}; //Vanilla: scaredAnimal
		if (_random == 1) then {_sound = format ["AmbienceRZheart%1", 1 + round (random 3)];}; //RyanZM: Heartbeat
		if (_random == 2) then {_sound = format ["AmbienceRZeat%1", 1 + round (random 4)];}; //RyanZM: Eat
		_soundObject say3D _sound;
		sleep 10;
		deleteVehicle _soundObject;
	};
};

//NNS: Drain/Fill fuel tank function
RefuelFnc = {
	_action = _this select 0; //0:fill, 1:drain, 2:drain cargo
	_container = player getVariable "vehiInv"; //recover vehicle
	_tankCap = getNumber (configfile >> "CfgVehicles" >> typeOf _container >> "fuelCapacity"); //get tank capacity
	if (_tankCap == 0) exitWith {}; //no fuel capacity in class
	_literTank = _tankCap * (fuel _container); //fuel tank in "liter"
	_canister = player getVariable ["canisterFuel", 0]; //player fuel canister
	_canisterFuelCap = missionNamespace getVariable ["BIS_FuelCanisterCap",12.5]; //fuel canister capacity
	_total = _literTank + _canister; //total
	_diff = 0; //difference
	_tankNew = fuel _container; //new vehicle tank contain
	_canisterNew = _canister; //new canister contain
	
	if (_action == 0) then { //fill
		_diff = _total - _tankCap; //fuel canister remain
		if (_total > _tankCap) then {_total = _tankCap}; //fuel tank overflow
		if (_diff < 0) then {_diff = 0}; //remain underflow
		_canisterNew = _diff; //new vehicle tank contain
		_tankNew = _total / _tankCap; //new vehicle tank contain
	};
	
	if (_action == 1) then { //drain
		ctrlEnable [10000, false]; //disable drain button to limit vehicle tank sync problems when vehicle not local
		_diff = _total - _canisterFuelCap; //fuel tank remain
		if (_total > _canisterFuelCap) then {_total = _canisterFuelCap}; //fuel canister overflow
		if (_diff < 0) then {_diff = 0}; //remain underflow
		_canisterNew = _total; //new vehicle tank contain
		_tankNew = _diff / _tankCap; //new vehicle tank contain
	};
	
	if (_action == 2) then { //drain cargo
		_cargoCap = getNumber (configfile >> "CfgVehicles" >> typeOf _container >> "transportFuel"); //get cargo capacity
		_cargoFuel = getFuelCargo _container; //current cargo remain
		if (_cargoCap > 0 && {_cargoFuel > 0}) then {_canisterNew = _canisterFuelCap;}; //vehicle have some fuel cargo, since transportFuel = 1e+012 on most refueler, don't waste time to compute
	};
	
	if (local _container) then {_container setFuel _tankNew;
	} else {[_container,_tankNew] remoteexec ['setFuel',_container];};
	player setVariable ["canisterFuel", _canisterNew]; //update player canister
};

//NNS: Allow drain/fill of fuel tank
player addEventHandler ["InventoryOpened", {
	params ["_unit", "_container"];
	
	//add button in inventory screen if player not in a vehicle, have canister on him and container is a non destroyed car
	if (player getVariable ["haveCanister", false] && {alive _container}) then {
		player setVariable ["vehiInv",_container]; //backup current container
		[_container] spawn {
			disableSerialization;
			_container = _this select 0; //recover vehicle object
			_canisterFuelCap = missionNamespace getVariable ["BIS_FuelCanisterCap",12.5]; //fuel canister capacity
			
			waitUntil {!isNull (findDisplay 602)}; //wait for screen to open
			_inventoryDisplay = findDisplay 602; //found the screen object
			
			//colors
			_invBgColor = [0.05, 0.05, 0.05, 0.7];
			_invTxtColor = [1, 1, 1, 0.7];
			_invProgressColor = [0.9, 0.9, 0.9, 0.9];
			_invFrameColor = [0.5, 0.5, 0.5, 0.5];
			
			//common
			_textH = getNumber (configFile >> "RscText" >> "SizeEx"); //text font size
			_buttonH = getNumber (configFile >> "RscButton" >> "h"); //button height
			_buttonFS = getNumber (configFile >> "RscButton" >> "SizeEx"); //button font size
			_progressH = getNumber (configFile >> "RscProgress" >> "h"); //progressbar height
			
			//left column
			_invContainerPos = ctrlPosition (_inventoryDisplay displayCtrl 1001); //CA_ContainerBackground : RscText
			_invContainerProgressPos = ctrlPosition (_inventoryDisplay displayCtrl 6307); //GroundLoad : RscProgress
			_invContainerX = _invContainerPos select 0; //left column X
			_invW = _invContainerPos select 2; //left column width
			_invPadding = abs (_invContainerX - (_invContainerProgressPos select 0));
			
			_buttonY = (_invPadding * 2) + _progressH;
			_buttonW = _invW - (_invPadding * 2);
			
			//right column
			_invPlayerPos = ctrlPosition (_inventoryDisplay displayCtrl 1002); //CA_PlayerBackground : RscText
			_invPlayerX = _invPlayerPos select 0; //right column X
			
			if (vehicle player == player && {_container isKindOf "Car" || _container isKindOf "Air"}) then { //vehicle inventory
				_hasCargo = false; if (getNumber (configfile >> "CfgVehicles" >> typeOf _container >> "transportFuel") != 0 && {(getFuelCargo _container) > 0}) then {_hasCargo = true}; //vehicle have some fuel cargo
				
				//drain fuel part
				_drainGrp = _inventoryDisplay ctrlCreate ["RscControlsGroupNoScrollbars", -1]; _drainGrp ctrlSetPosition [_invContainerX, (_invContainerPos select 1) + (_invContainerPos select 3) + _invPadding]; _drainGrp ctrlCommit 0;
				_drainBg = _inventoryDisplay ctrlCreate ["RscText", -1, _drainGrp];_drainBg ctrlSetPosition [0, 0, _invW, [(_invPadding * 3) + _buttonH + _progressH, (_invPadding * 4) + (_buttonH * 2) + _progressH] select (_hasCargo)];_drainBg ctrlSetBackgroundColor _invBgColor; _drainBg ctrlCommit 0;
				_vehiProgress = _inventoryDisplay ctrlCreate ["RscProgress", -1, _drainGrp]; _vehiProgress ctrlSetPosition [_invPadding, _invPadding, _buttonW, _progressH]; _vehiProgress ctrlSetTextColor _invProgressColor; _vehiProgress ctrlCommit 0;
				_vehiProgress progressSetPosition (fuel _container);
				_vehiProgressFrame = _inventoryDisplay ctrlCreate ["RscFrame", -1, _drainGrp]; _vehiProgressFrame ctrlSetPosition [_invPadding, _invPadding, _buttonW, _progressH]; _vehiProgressFrame ctrlSetTextColor _invFrameColor; _vehiProgressFrame ctrlCommit 0;
				for "_i" from 1 to 9 do {_tmpX = _invPadding + (_buttonW / 10) * _i; _tmpCtl = _inventoryDisplay ctrlCreate ["RscLine", -1, _drainGrp]; _tmpCtl ctrlSetPosition [_tmpX, _invPadding, 0, _progressH]; _tmpCtl ctrlSetTextColor _invFrameColor; _tmpCtl ctrlCommit 0;};
				_drainButton = _inventoryDisplay ctrlCreate ["RscButton", 10000, _drainGrp]; _drainButton ctrlSetPosition [_invPadding, _buttonY, _buttonW, _buttonH]; _drainButton ctrlSetText localize "STR_NNS_Escape_FuelTank_drain"; _drainButton ctrlSetFontHeight _buttonFS; _drainButton buttonSetAction "[1] call RefuelFnc"; _drainButton ctrlCommit 0;
				if ((fuel _container == 0) || {(player getVariable ["canisterFuel", 0]) == _canisterFuelCap}) then {_drainButton ctrlEnable false;}; //no fuel or canister full, disable control
				if (_hasCargo) then {
					_cargoButton = _inventoryDisplay ctrlCreate ["RscButton", 10002, _drainGrp]; _cargoButton ctrlSetPosition [_invPadding, _buttonY + _invPadding + _buttonH, _buttonW, _buttonH]; _cargoButton ctrlSetText localize "STR_NNS_Escape_FuelTank_draincargo"; _cargoButton ctrlSetFontHeight _buttonFS; _cargoButton buttonSetAction "[2] call RefuelFnc"; _cargoButton ctrlCommit 0;
					if ((player getVariable ["canisterFuel", 0]) == _canisterFuelCap) then {_cargoButton ctrlEnable false;}; //canister full, disable control
				};
				
				//fill fuel part
				_fillGrp = _inventoryDisplay ctrlCreate ["RscControlsGroupNoScrollbars", -1]; _fillGrp ctrlSetPosition [_invPlayerX, (_invPlayerPos select 1) + (_invPlayerPos select 3) + _invPadding]; _fillGrp ctrlCommit 0;
				_fillBg = _inventoryDisplay ctrlCreate ["RscText", -1, _fillGrp]; _fillBg ctrlSetPosition [0, 0, _invW, (_invPadding * 3) + _buttonH + _progressH]; _fillBg ctrlSetBackgroundColor _invBgColor; _fillBg ctrlCommit 0;
				_fillProgress = _inventoryDisplay ctrlCreate ["RscProgress", -1, _fillGrp]; _fillProgress ctrlSetPosition [_invPadding, _invPadding, _buttonW, _progressH]; _fillProgress ctrlSetTextColor _invProgressColor; _fillProgress ctrlCommit 0;
				_fillProgress progressSetPosition ((player getVariable ["canisterFuel", 0]) / _canisterFuelCap);
				_fillProgressFrame = _inventoryDisplay ctrlCreate ["RscFrame", -1, _fillGrp]; _fillProgressFrame ctrlSetPosition [_invPadding, _invPadding, _buttonW, _progressH]; _fillProgressFrame ctrlSetTextColor _invFrameColor; _fillProgressFrame ctrlCommit 0;
				for "_i" from 1 to 9 do {_tmpX = _invPadding + (_buttonW / 10) * _i; _tmpCtl = _inventoryDisplay ctrlCreate ["RscLine", -1, _fillGrp]; _tmpCtl ctrlSetPosition [_tmpX, _invPadding, 0, _progressH]; _tmpCtl ctrlSetTextColor _invFrameColor; _tmpCtl ctrlCommit 0;};
				_fillButton = _inventoryDisplay ctrlCreate ["RscButton", 10001, _fillGrp]; _fillButton ctrlSetPosition [_invPadding, _buttonY, _buttonW, _buttonH]; _fillButton ctrlSetText localize "STR_NNS_Escape_FuelTank_fill"; _fillButton ctrlSetFontHeight _buttonFS; _fillButton buttonSetAction "[0] call RefuelFnc"; _fillButton ctrlCommit 0;
				if (player getVariable ["canisterFuel", 0] == 0 || {fuel _container > 0.99}) then {_fillButton ctrlEnable false;}; //no fuel in canister, disable control
				
				//update all progressbars / buttons
				_lastFuel = 0;
				_lastCanister = 0;
				while {sleep 0.1; !isNull (findDisplay 602) && !isNull _vehiProgress && !isNull _container && !isNull _fillProgress} do { //loop if inventory open
					_newFuel = fuel _container; //vehicle fuel
					_newCanister = (player getVariable ["canisterFuel", 0]) / _canisterFuelCap; //canister
					
					if (!(_newFuel == _lastFuel) || !(_newCanister == _lastCanister)) then { //vehicle fuel or canister changed
						if (_newFuel > 0 && {_newCanister < 0.99}) then {ctrlEnable [10000, true]} else {ctrlEnable [10000, false]}; //enable/disable drain button
						if (_newCanister > 0 && {_newFuel < 0.99}) then {ctrlEnable [10001, true]} else {ctrlEnable [10001, false]}; //enable/disable fill button
						if (_newCanister < 0.99) then {ctrlEnable [10002, true]} else {ctrlEnable [10002, false]}; //enable/disable cargo drain button
					};
					
					if !(_newFuel == _lastFuel) then { //vehicle fuel changed
						_vehiProgress progressSetPosition _newFuel; //update vehicle fuel progress bar
						_lastFuel = _newFuel; //backup value
					};
					
					if !(_newCanister == _lastCanister) then { //canister changed
						_fillProgress progressSetPosition _newCanister; //update canister progress bar
						_lastCanister = _newCanister; //backup value
					};
				};
			} else { //player inventory
				_invPlayerW = _invPlayerPos select 2; //player inventory width
				_canisterGrp = _inventoryDisplay ctrlCreate ["RscControlsGroupNoScrollbars", -1]; _canisterGrp ctrlSetPosition [_invPlayerX, (_invPlayerPos select 1) + (_invPlayerPos select 3) + _invPadding]; _canisterGrp ctrlCommit 0;
				_canisterBg = _inventoryDisplay ctrlCreate ["RscText", -1, _canisterGrp]; _canisterBg ctrlSetPosition [0, 0, _invPlayerW, (_invPadding * 2) + _progressH]; _canisterBg ctrlSetBackgroundColor _invBgColor; _canisterBg ctrlCommit 0;
				_canisterTxt = _inventoryDisplay ctrlCreate ["RscText", -1, _canisterGrp]; _canisterTxt ctrlSetPosition [_invPadding - 0.008, _invPadding, _invPlayerW - (_invPadding * 2), _progressH]; _canisterTxt ctrlSetText (localize "STR_NNS_Escape_FuelCanister"); _canisterTxt ctrlSetTextColor _invTxtColor; _canisterTxt ctrlSetFontHeight _textH; _canisterTxt ctrlSetBackgroundColor [0, 0, 0, 0]; _canisterTxt ctrlCommit 0;
				_txtW = (ctrlTextWidth _canisterTxt) - 0.016; //not include 0.008 margin
				_progressX = _txtW + (_invPadding * 2);
				_progressW = _invPlayerW - (_progressX + _invPadding);
				_canisterProgress = _inventoryDisplay ctrlCreate ["RscProgress", -1, _canisterGrp]; _canisterProgress ctrlSetPosition [_progressX, _invPadding, _progressW, _progressH]; _canisterProgress ctrlSetTextColor _invProgressColor; _canisterProgress ctrlCommit 0;
				_canisterProgress progressSetPosition ((player getVariable ["canisterFuel", 0]) / (missionNamespace getVariable ["BIS_FuelCanisterCap",12.5]));
				_canisterProgressFrame = _inventoryDisplay ctrlCreate ["RscFrame", -1, _canisterGrp]; _canisterProgressFrame ctrlSetPosition [_progressX, _invPadding, _progressW, _progressH]; _canisterProgressFrame ctrlSetTextColor _invFrameColor; _canisterProgressFrame ctrlCommit 0;
				for "_i" from 1 to 9 do {_tmpX = _progressX + (_progressW / 10) * _i; _tmpCtl = _inventoryDisplay ctrlCreate ["RscLine", -1, _canisterGrp]; _tmpCtl ctrlSetPosition [_tmpX, _invPadding, 0, _progressH]; _tmpCtl ctrlSetTextColor _invFrameColor; _tmpCtl ctrlCommit 0;};
			};
		};
	};
}];

//Add a chance to unhide loot marker when looting zombie soldier
player addEventHandler ["InventoryClosed", {
	params ["_unit", "_container"];
	_containerType = typeOf _container; //typeOf
	if (_containerType find "Zombie" != -1 && {_containerType find "Soldier" != -1} && {!(_container getVariable ["looted",false])}) then { //not looted zombie soldier
		if (random 100 > 95) then { //5% chance to "found" a marker location
			_loot_markers = missionNamespace getVariable ["lootMarkers",[]]; //recover list
			_marker = selectRandom _loot_markers; //marker
			_loot_markers deleteAt (_loot_markers find _marker); //delete from array
			missionNamespace setVariable ["lootMarkers",_loot_markers,true];
			_marker setMarkerText ""; _marker setMarkerAlpha 1; //display marker
			[name player, localize "STR_NNS_LootMarkerFound_title"] remoteExec ["BIS_fnc_showSubtitle"]; //advise all players
		};
		_container setVariable ["looted",true,true]; //set zombie to looted
	};
}];

//NNS: try to limit real player friendly fire by AI
player addEventHandler ["Dammaged", { //The typo is "intentional": it is Dammaged with two "m".
	params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];
	if (!isNull _shooter) then {
		_uid = getPlayerUID _shooter;
		if (_uid == "" || {_uid == "_SP_AI_"}) then { //AI
			if (side _shooter == side player) then { //same side
				player setHitIndex [_hitIndex, 0, false]; //set damage to 0 for the touched hit index
			};
		};
	};
}];

// Handle JIP respawn
missionNamespace setVariable ["_initialRespawn", addMissionEventHandler ["PreloadFinished", {
	//if !(getMarkerColor "marker_respawn" == "") then {player setPos (getMarkerPos "marker_respawn"); //initial respawn still exist
	//} else {player setPos getPos (leader group player);}; //initial respawn don't exist, spawn on group leader
	removeMissionEventHandler ["PreloadFinished", missionNamespace getVariable ["_initialRespawn", -1]];
	missionNamespace setVariable ["_initialRespawn", nil];
	
	playMusic "AmbientTrack01_F_EPB"; //initial music
	
	if (didJIP and (time > 30)) then {
		player enableSimulationGlobal false;
		player enableSimulation false;
		player hideObjectGlobal true;
		player hideObject true;
		forceRespawn player;
		deleteVehicle player;
	};
	
	//NNS : turn on flashlight and NVG if night
	if !(sunOrMoon == 1) then { //moon time, not perfect but work for most
		waitUntil {alive player};
		player action ["GunLightOn", player]; //turn on flashlight
	};
}]];

/*
//debug: move to debug zone and add fuel canister
player setPos [1243.528,12267.417,0];
player setDir 180;
player setVariable ["haveCanister", true];
player setVariable ["canisterFuel", 10];
*/

//NNS: try to handle refuel glitch for escape vehicles when hit by zombies
[] spawn {
	while {sleep 2; true} do {
		if (vehicle player != player) then { //player in vehicle
			_vehi = vehicle player;
			if (alive player && {(driver _vehi) isEqualTo player} && {alive _vehi} && {_vehi isKindOf "Air"} && {isTouchingGround _vehi}) then { //player is driver of air vehicle that touch ground
				_nearTrucks = nearestObjects [getPos _vehi, ["Car"], 20]; //all car type object in 20m radius
				{
					if (alive _x && {["fuel", toLower (typeOf _x), true] call BIS_fnc_inString}) then { //refueler nearby, add 5% fuel per loop
						if (local _vehi) then {_vehi setFuel ((fuel _vehi) + 0.05);
						} else {[_vehi,(fuel _vehi) + 0.05] remoteexec ['setFuel',_vehi];};
					};
				} forEach _nearTrucks;
			};
		};
	};
};

//NNS: punish teamkiller
[] spawn {
	while {sleep 10; true} do {
		if ((rating player < -2000) && {vehicle player == player}) then { //renegade and not in vehicle
			[player, nil, true] spawn BIS_fnc_moduleLightning; //zeus punishment
			player setDamage 1; //kill player
		};
	};
};

