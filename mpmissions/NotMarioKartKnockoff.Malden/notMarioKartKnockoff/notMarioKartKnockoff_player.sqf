/*
NNS
Not Mario Kart Knockoff
Remote script executed on client.
*/

waitUntil {!isNull (findDisplay 46)}; //wait for mission screen to open

["notMarioKartKnockoff_player.sqf: Player remote started"] call NNS_fnc_debugOutput;

_tmpHandle = [localize "STR_MKK_server", localize "STR_MKK_waitfordata"] call MKK_fnc_displaySubtitle; //receiving data

removeAllActions player; //remove all player actions
removeAllActions (vehicle player); //remove all player vehicle actions

player removeWeapon "NVGoggles_OPFOR"; player addWeapon "NVGoggles_OPFOR"; //remove and re-add NVG

if (isNil "MKK_diaryEntry") then { //add diary entry if not already done
	MKK_diaryEntry = player createDiaryRecord ["Diary", [localize "STR_MKK_name", format ["%1<br/><br/>%2<br/><br/>%3", localize "STR_MKK_version", localize "STR_MKK_desc", localize "STR_MKK_help0"]]];
};

waitUntil {sleep 1; //wait for server global to be received
	!isNil "MKK_boxs" &&
	{!isNil "MKK_karts"} &&
	{!isNil "MKK_modePointArr"} &&
	{!isNil "MKK_modeLimitArr"} &&
	{!isNil "MKK_modeDuraArr"} &&
	{!isNil "MKK_areaSizesArr"} &&
	{!isNil "MKK_areaKartsPosArr"} &&
	{!isNil "MKK_time"} &&
	{!isNil "MKK_area"} &&
	{!isNil "MKK_mode"} &&
	{!isNil "MKK_modeRules"} &&
	{!isNil "MKK_voteTimeEnd"} &&
	{!isNil "MKK_voteAreaEnd"} &&
	{!isNil "MKK_voteModeEnd"} &&
	{!isNil "MKK_voteRulesEnd"} &&
	{!isNil "MKK_introEnd"} &&
	{!isNil "MKK_roundEnd"} &&
	{!isNil "MKK_scoreEnd"}};

terminate _tmpHandle; //kill receiving data handle


player setVariable ["MKK_init", true, true]; //mark player as initialized

_playerVeh = vehicle player; //backup player vehicle
player switchCamera "EXTERNAL"; //switch to external view
_playerAllowDamage = isDamageAllowed player; //backup player allow damage state
player allowDamage false; //invicible
_playerVeh allowDamage false; //invicible

MKK_unstickLastTime = 0; //last unstuck request time
player addAction [localize "STR_MKK_player_unstruck", { //action to unstick player
	_requestTime = call MKK_fnc_time; //current request time
	_waitTime = _requestTime - MKK_unstickLastTime; //time elapsed since last request
	_tmpVeh = vehicle player; //backup player vehicle
	if (_waitTime < 30) then {
		_waitTime = ceil (30 - _waitTime); //remaining time
		["", format [localize "STR_MKK_player_unstruckWait", _waitTime]] call MKK_fnc_displaySubtitle; //notify player
	} else {
		if (!(MKK_area == -1) && {!((_tmpVeh getVariable ["index", -1]) == -1)}) then {
			_tmpVeh setDir (random 360); //random direction
			_tmpVeh setPos ((MKK_areaKartsPosArr select MKK_area) select (_tmpVeh getVariable "index")); //teleport kart to its original position
			MKK_unstickLastTime = round _requestTime; //backup request time
		};
	};
}, nil, 1.5, false];

//debug skip, only here in solo
if !(isMultiplayer) then {player addAction ["Debug: end current round", {missionNamespace setVariable ["MKK_roundEnd", -1, true]}, nil, 1.5, false]};

setViewDistance 400; //limit view distance

//player non-public global
missionNamespace setVariable ["MKK_modeNameArr", [ //game mode name string: 0:random, 1:balloon, 2:deathmatch
localize "STR_MKK_Gamemode_random_title",
localize "STR_MKK_Gamemode_balloon_title",
localize "STR_MKK_Gamemode_deathmatch_title",
localize "STR_MKK_Gamemode_teamdeathmatch_title",
localize "STR_MKK_Gamemode_freeplay_title"
]];

missionNamespace setVariable ["MKK_gameImgArr", [ //game mode image array
"\A3\ui_f\data\GUI\Cfg\Hints\Team_switch_ca.paa", //random
"notMarioKartKnockoff\img\votes\balloon.paa",
"notMarioKartKnockoff\img\votes\deathmatch.paa",
"notMarioKartKnockoff\img\votes\teamdeathmatch.paa",
"notMarioKartKnockoff\img\votes\freeplay.paa"
]];

missionNamespace setVariable ["MKK_gameDescArr", [ //game mode description array
localize "STR_MKK_Gamemode_random_desc",
localize "STR_MKK_Gamemode_balloon_desc",
localize "STR_MKK_Gamemode_deathmatch_desc",
localize "STR_MKK_Gamemode_teamdeathmatch_desc",
localize "STR_MKK_Gamemode_freeplay_desc"
]];

_tmpArr = [[localize "STR_MKK_Gamemode_random_params"]];
_tmpSubArr = []; for "_i" from 0 to (count (MKK_modePointArr select 1) - 1) do {_tmpSubArr pushBack format [localize "STR_MKK_Gamemode_balloon_params", (MKK_modePointArr select 1) select _i, ceil (((MKK_modeDuraArr select 1) select _i) / 60)]}; _tmpArr pushBack _tmpSubArr;
_tmpSubArr = []; for "_i" from 0 to (count (MKK_modePointArr select 2) - 1) do {_tmpSubArr pushBack format [localize "STR_MKK_Gamemode_deathmatch_params", (MKK_modeLimitArr select 2) select _i, ceil (((MKK_modeDuraArr select 2) select _i) / 60)]}; _tmpArr pushBack _tmpSubArr;
_tmpSubArr = []; for "_i" from 0 to (count (MKK_modePointArr select 3) - 1) do {_tmpSubArr pushBack format [localize "STR_MKK_Gamemode_deathmatch_params", (MKK_modeLimitArr select 3) select _i, ceil (((MKK_modeDuraArr select 3) select _i) / 60)]}; _tmpArr pushBack _tmpSubArr;
_tmpSubArr = []; for "_i" from 0 to (count (MKK_modePointArr select 4) - 1) do {_tmpSubArr pushBack format [localize "STR_MKK_Gamemode_freeplay_params", ceil (((MKK_modeDuraArr select 4) select _i) / 60)]}; _tmpArr pushBack _tmpSubArr;
missionNamespace setVariable ["MKK_gameParamsTextArr", _tmpArr]; //game mode parameters text array
_tmpArr = nil; //free useless var


//scripts
_handleWarn = [] spawn { //script to warn player about sound glitch when 1st person view in vehicle
	while {(vehicle player) != player} do {
		_veh = vehicle player; //backup player vehicle
		waitUntil {sleep 1; ((vehicle player) == player) || (cameraView == "INTERNAL")}; //player switch to internal view
		if (cameraOn == _veh && cameraView == "INTERNAL") then {["", localize "STR_MKK_game_warn1stperson"] call MKK_fnc_displaySubtitle}; //camera on player vehicle, create subtitle
		sleep 15; //wait a bit
	};
};

_handleMapPoly = [] spawn { //script to display polygon areas on map
	_mapDrawHandle = -1;
	
	while {sleep 2; (vehicle player) != player} do { //loop until player exit vehicle
		if (_mapDrawHandle == -1 && {!isNil "MKK_areaPolyArr"}) then { //invalid map draw handle and polygons array set
			_mapDrawHandle = findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", { //draw on map event handler
				params ["_control"]; {_control drawPolygon [_x, [0,0.8,0,1]]} forEach MKK_areaPolyArr; //draw each area polygon
			}];
		};
	};
	
	(findDisplay 12 displayCtrl 51) ctrlRemoveEventHandler ["Draw", _mapDrawHandle]; //remove handle
};

_handleNight = [] spawn { //script to handle night time
	_lastDayTime = -1; //initial daytime
	
	_veh = (vehicle player); //player vehicle
	
	_kartHeadlightL = objNull; _kartHeadlightR = objNull; //headlight objects
	_flarelights = [objNull, objNull, objNull, objNull]; //local light sources array
	
	while {sleep 2; (vehicle player) != player} do { //loop
		_currentDayTime = MKK_time; //recover current daytime
		if (_lastDayTime != _currentDayTime && MKK_area != -1) then { //daytime changed and area set
			if (_currentDayTime == 0) then { //day time
				deleteVehicle _kartHeadlightL; //delete headlight object
				deleteVehicle _kartHeadlightR; //delete headlight object
				{deleteVehicle _x} forEach _flarelights; //delete flare object
			};
			
			if (_currentDayTime == 1) then { //night time
				_kartHeadlightL = "Land_PortableLight_02_single_folded_sand_F" createVehicleLocal (getPos _veh);
				_kartHeadlightL allowDamage false; //disable damage
				_kartHeadlightL attachTo [(vehicle player), [-0.4, -0.05, -0.7]];
				_kartHeadlightL setVectorDirAndUp [[0, -1, 0], [0, 0, 1]];

				_kartHeadlightR = "Land_PortableLight_02_single_folded_sand_F" createVehicleLocal (getPos _veh);
				_kartHeadlightR allowDamage false; //disable damage
				_kartHeadlightR attachTo [(vehicle player), [0.5, -0.05, -0.7]];
				_kartHeadlightR setVectorDirAndUp [[0, -1, 0], [0, 0, 1]];
				
				_areaPos = MKK_areaPosArr select MKK_area; //recover area center
				for "_i" from 0 to 3 do {
					_tmpPos = _areaPos getPos [200, 90 * _i]; //compute light position
					_tmpPos set [2, 110]; //set proper Z
					_tmpLight = "#lightpoint" createVehicleLocal _tmpPos; //create local light source
					_tmpLight setLightIntensity 3000;
					_tmpLight setLightAttenuation [0,0,0,0.01];
					_tmpLight setLightColor [0.95,0.95,1.00];
					_tmpLight setLightDayLight false;
					_flarelights set [_i, _tmpLight]; //update light object
				};
			};
			
			_lastDayTime = _currentDayTime; //backup daytime var
		};
	};
	
	deleteVehicle _kartHeadlightL; //delete headlight object
	deleteVehicle _kartHeadlightR; //delete headlight object
	{deleteVehicle _x} forEach _flarelights; //delete flare object
};

_scriptVote = {}; _handleVote = scriptNull; //script var and handle id for vote screen
_scriptTeam = {}; _handleTeam = scriptNull; //script var and handle id for team screen
_scriptIntro = {}; _handleIntro = scriptNull; //script var and handle id for intro screen
_scriptRound = {}; _handleRound = scriptNull; //script var and handle id for round
_scriptScore = {}; _handleScore = scriptNull; //script var and handle id for score screen

//script to terminate all handles if player exit vehicle
[[_handleWarn, _handleVote, _handleIntro, _handleRound, _handleScore]] spawn {
	_handlesArr = _this select 0; //recover handles array
	waitUntil {sleep 1; (vehicle player) == player}; //wait for player to exit vehicle
	{if !(isNull _x) then {terminate _x}} forEach _handlesArr; //terminate all scripts
};

//main loop
while {sleep 1; (vehicle player) != player} do {
	_playerVeh = vehicle player; //backup player vehicle
	player allowDamage false; //disable player damage
	_playerVeh allowDamage false; //disable player vehicle damage, exit spectator mode re-enable it
	
	waitUntil {sleep 0.5; isNull (findDisplay 49) || {(vehicle player) == player}}; //wait until pause display closed
	
	//vote for day time
	if ((call MKK_fnc_time) < MKK_voteTimeEnd && {isNull _handleVote}) then { //proper time but no handle
		if (_scriptVote isEqualTo {}) then {_scriptVote = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenVote.sqf"}; //load and compile vote script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleScore}; //wait for score screen script end
		_handleVote = [] spawn _scriptVote; //run vm for vote screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//vote for area
	if ((call MKK_fnc_time) < MKK_voteAreaEnd && {isNull _handleVote}) then { //proper time but no handle
		if (_scriptVote isEqualTo {}) then {_scriptVote = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenVote.sqf"}; //load and compile vote script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleVote}; //wait for score screen script end
		_handleVote = [] spawn _scriptVote; //run vm for vote screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//vote for game mode
	if ((call MKK_fnc_time) < MKK_voteModeEnd && {isNull _handleVote}) then { //proper time but no handle
		if (_scriptVote isEqualTo {}) then {_scriptVote = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenVote.sqf"}; //load and compile vote script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleVote}; //wait for area vote script end
		_handleVote = [] spawn _scriptVote; //run vm for vote screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//vote for game parameters
	if ((call MKK_fnc_time) < MKK_voteRulesEnd && {isNull _handleVote}) then { //proper time but no handle
		if (_scriptVote isEqualTo {}) then {_scriptVote = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenVote.sqf"}; //load and compile vote script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleVote}; //wait for vote 0 screen script end
		_handleVote = [] spawn _scriptVote; //run vm for vote screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//team selection
	if ((call MKK_fnc_time) < MKK_teamEnd && {isNull _handleTeam}) then { //proper time but no handle
		if (_scriptTeam isEqualTo {}) then {_scriptTeam = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenTeam.sqf"}; //load and compile team script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleVote}; //wait for vote 1 screen script end
		_handleTeam = [] spawn _scriptTeam; //run vm for team screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//intro
	if ((call MKK_fnc_time) < MKK_introEnd && {isNull _handleIntro}) then { //proper time but no handle
		if (_scriptIntro isEqualTo {}) then {_scriptIntro = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenIntro.sqf"}; //load and compile intro script
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		waitUntil {sleep 0.5; isNull _handleTeam}; //wait for team screen script end
		_handleIntro = [] spawn _scriptIntro; //run vm for intro screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
	
	//round
	if ((call MKK_fnc_time) < MKK_roundEnd && {isNull _handleRound}) then { //proper time but no handle
		if (_scriptRound isEqualTo {}) then {_scriptRound = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_round.sqf"}; //load and compile round script
		waitUntil {sleep 0.5; ((call MKK_fnc_time) + 5) > MKK_introEnd && {MKK_mode != -1} && {MKK_modeRules != -1}}; //wait for game mode and its parameters set
		_handleRound = [] spawn _scriptRound; //run vm for current round
		waitUntil {sleep 0.5; isNull _handleIntro}; //wait for intro screen script end
		[_playerVeh, 1] remoteexec ["setFuel", _playerVeh]; //initial refuel
		
		[_playerVeh] spawn { //refuel and repair player vehicle loop
			params ["_playerVeh"];
			while {sleep 10; (call MKK_fnc_time) < MKK_roundEnd && {(vehicle player) != player}} do {
				if (MKK_mode != 1) then {[_playerVeh, 1] remoteexec ["setFuel", _playerVeh]}; //refuel only if not balloon mode
				[_playerVeh, 0] remoteexec ["setDamage", _playerVeh]; //repair vehicle
			};
		};
	};
	
	//score
	if ((call MKK_fnc_time) < MKK_scoreEnd && {isNull _handleScore}) then { //proper time but no handle
		if (_scriptScore isEqualTo {}) then {_scriptScore = compile preprocessFileLineNumbers "notMarioKartKnockoff\notMarioKartKnockoff_screenScore.sqf"}; //load and compile score script
		waitUntil {sleep 0.5; isNull _handleRound}; //wait for round script end
		[_playerVeh, 0] remoteexec ["setFuel", _playerVeh]; //empty player vehicle tank
		_handleScore = [] spawn _scriptScore; //run vm for score screen
		player setVariable ["MKK_pointsLast", -999]; //reset player last point
	};
};

removeAllActions player; //remove all player actions
removeAllActions (vehicle player); //remove all player vehicle actions

player setVariable ["MKK_init", false, true]; //reset player initialized var
player setVariable ["MKK_inKart", false, true]; //reset player in kart var
player allowDamage _playerAllowDamage; //player allow damage state from start of the script
[_playerVeh, false] remoteexec ["allowDamage", _playerVeh]; //for whatever reason, when player exit vehicle, damages are allowed on vehicle

["notMarioKartKnockoff_player.sqf: Player remote end"] call NNS_fnc_debugOutput;