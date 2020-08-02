// Disable everything other than dialogues
enableSentences false;

if (!(isDedicated)) then {
	if (!alive player) then {
		setPlayerRespawnTime 0;
		openMap false;
		sleep 0.1;
	};
	if (alive player) then {
		// Disable & reset damage, move out of incapacitated state
		player setCaptive true;
		player allowDamage false;
		player setDamage 0;
		player setUnconscious false;
	};
};

if (isServer) then {
	// Register ending
	BIS_missionEnding = true;

	// Add task
	"BIS_extract" call BIS_fnc_missionTasks;

	// Play conversation
	"107_ProceedToExtract" call BIS_fnc_missionConversations;
	sleep 2;

	// Fade out
	BIS_fnc_EXP_m07_ending_fadeOut = true;
	publicVariable "BIS_fnc_EXP_m07_ending_fadeOut";
};

// Wait for fade out
waitUntil {missionNamespace getVariable ["BIS_fnc_EXP_m07_ending_fadeOut", false]};

if (isServer) then {
	// Remove and disable player respawns
	BIS_respawnEnabled = false;
	{_x call BIS_fnc_removeRespawnPosition} forEach BIS_respawnsPlayers;
};

if (!(isDedicated)) then {
	// Fade out
	3 fadeSound 0;
	titleCut ["", "BLACK OUT", 3];
};

sleep 4;

if (isServer) then {
	// Delete remaining enemy and un-needed units
	{if (alive _x && { (_x call BIS_fnc_objectSide) == RESISTANCE }) then {deleteVehicle _x}} forEach allUnits;
	{if (alive _x) then {deleteVehicle _x}} forEach (BIS_viper3 + BIS_viper4 + BIS_extractUnits);

	// Delete existing helicopters
	{
		private _heli = _x;
		private _units = units group driver _heli;
		{deleteVehicle _x} forEach (_units + [_heli]);
	} forEach [BIS_heliExtract, BIS_heliSling, BIS_heliAttack];

	// Spawn new ones
	for "_i" from 1 to 3 do {
		// Determine details
		private ["_class", "_pos", "_dir", "_alt", "_var"];
		switch (_i) do {
			case 1: {
				// Extraction heli
				_class = "B_Heli_Light_01_F";
				_pos = [13728.8,12262.1,11];
				_dir = 65.0655;
				_alt = 9;
				_var = "BIS_heliExtract";
			};

			case 2: {
				// Slingload heli
				_class = "B_Heli_Transport_03_F";
				_pos = [13789.3,12279.5,11];
				_dir = 292.741;
				_alt = 8;
				_var = "BIS_heliSling";
			};

			case 3: {
				// Attack heli
				_class = "B_Heli_Attack_01_F";
				_pos = [13813.2,12294,17];
				_dir = 16.3215;
				_alt = 10;
				_var = "BIS_heliAttack";
			};
		};

		// Create helicopter
		private _info = [[10,10,10], 0, _class, WEST, true] call BIS_fnc_spawnVehicle;
		_info params ["_heli", "_crew", "_group"];

		// Assign variable
		missionNamespace setVariable [_var, _heli, true];

		// Stop heli from taking damage or being attacked
		_heli allowDamage false;
		_heli setCaptive true;

		{
			private _unit = _x;

			// Disable unwanted AI
			{_unit disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET"];
			_unit allowFleeing 0;
			_unit setCombatMode "BLUE";

			// Prevent damage and attack
			_unit allowDamage false;
			_unit setCaptive true;
		} forEach _crew;

		// Move the helicopter into position
		_heli setPosASL _pos;
		_heli setDir _dir;
		_heli flyInHeight _alt;

		// Lock it
		_heli lock true;

		// Add waypoint to make it conform to altitude
		_pos set [2, 0];
		private _wp = _group addWaypoint [_pos, 0];
		_wp setWaypointPosition [_pos, 0];
		_wp setWaypointType "MOVE";
		_group setCurrentWaypoint _wp;

		if (_i == 1) then {
			// Move players into the helicopter
			[_heli, "BIS_fnc_EXP_m07_boardHeli", BIS_fnc_EXP_m07_endingServer_players] call BIS_fnc_MP;
		};
	};

	{
		private _unit = _x;

		// Reset AI
		_unit setBehaviour "AWARE";
		_unit setCombatMode "BLUE";
		_unit disableAI "AUTOCOMBAT";
		{_unit enableAI _x} forEach ["MOVE", "PATH"];

		// Board slingload heli
		_unit assignAsCargo BIS_heliSling;
		_unit moveInCargo BIS_heliSling;
	} forEach [BIS_ai_1, BIS_ai_2, BIS_ai_3, BIS_ai_4];

	// Hide existing device
	BIS_device hideObjectGlobal true;

	// Create slingloadable variant
	private _device = createVehicle ["Land_Device_slingloadable_F", [10,10,10], [], 0, "NONE"];
	_device setPosASL (getPosASL BIS_device);
	_device setDir (direction BIS_device);

	// Kill light
	_device setHit ["Light_1_hit", 1];

	// Attach device to slingload heli
	BIS_heliSling setSlingLoad _device;

	// Turn lights back on
	{_x setDamage 0} forEach BIS_portLights_objects;
	[2, [0]] call BIS_fnc_portLights;
};

sleep 2;

if (isServer) then {
	// Fade in
	BIS_fnc_EXP_m07_ending_fadeIn = true;
	publicVariable "BIS_fnc_EXP_m07_ending_fadeIn";
};

// Wait for fade in
waitUntil {missionNamespace getVariable ["BIS_fnc_EXP_m07_ending_fadeIn", false]};

if (!(isDedicated)) then {
	// Fade sound in
	15 fadeSound 0.4;
};

sleep 7;

if (isServer) then {
	[] spawn {
		scriptName "BIS_fnc_EXP_m07_ending: final conversation";

		// Play conversation
		"110_Outro" call BIS_fnc_missionConversations;
		sleep 1;

		// Grab position
		private _pos = markerPos "BIS_heliLeave";

		{
			// Take off
			_x flyInHeight 50;

			private "_wp";
			private _group = group driver _x;

			if (_x == BIS_heliExtract) then {
				// Players' helicopter flies more to the left
				_wp = _group addWaypoint [markerPos "BIS_playersLeaveA", 0, 0, ""];
				_group addWaypoint [markerPos "BIS_playersLeaveB", 0, 1, ""];
				_wp setWaypointSpeed "FULL";
			};

			if (_x == BIS_heliSling) then {
				// Make slingload heli climb
				_wp = _group addWaypoint [markerPos "BIS_heliLeave", 0];
				// Wait for it to climb
				//sleep 2;
			};

			if (_x == BIS_heliAttack) then {
				_wp = _group addWaypoint [markerPos "BIS_heliAttackLeave", 0];
				_wp setWaypointSpeed "FULL";
			};
			// Fly away
			_wp setWaypointType "MOVE";
			_group setCurrentWaypoint _wp;

			// Succeed task
			if (_x == BIS_heliExtract) then {["BIS_extract", "SUCCEEDED"] call BIS_fnc_missionTasks};
		} forEach [BIS_heliAttack, BIS_heliSling, BIS_heliExtract];
	};
};

sleep 4;

if (!(isDedicated)) then {
	// Take off NVGs, turn off IR
	{player action [_x, player]} forEach ["NVGogglesOff", "IRLaserOff"];
};

sleep 1;

if (!(isDedicated)) then {
	// Fade in screen
	titleCut ["", "BLACK IN", 3];
};

sleep 29;

if (!(isDedicated)) then {
	// Fade out sound
	18 fadeSound 0;
};

sleep 5;

if (!(isDedicated)) then {
	// Fade out world
	[] spawn {
		disableSerialization;
		scriptName "BIS_fnc_EXP_m07_endingClient: forced fade out";
		("BIS_fnc_EXP_m07_endingClient_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK OUT", 7];
	};
};

sleep 8;

if (!(isDedicated)) then {
	// Make sure player is alive, otherwise force respawn
	if (!alive player) then {
		setPlayerRespawnTime 0;
	};

	[] spawn {
		scriptName "BIS_fnc_EXP_m07_endingClient: music control";

		// Open map may cause mause flickering during video and credits, force it off
		openMap false;

		// Calculate when music should start based on length of video
		private _videoDur = 110;
		private _musicCue = 65;
		private _startTime = time + (_videoDur - _musicCue);
		private _fadeDur = 1;
		private _fadeIn = _startTime + (_musicCue - _fadeDur);

		// Wait until music should play
		waitUntil {time >= _startTime};

		// Handle music
		0 fadeMusic 0.1;
		playMusic "AmbientTrack02_F_EXP";

		// Make music flow into credits
		BIS_fnc_EXP_m07_endingClient_trackCount = 0;
		BIS_fnc_EXP_m07_endingClient_musicEH = addMusicEventHandler [
			"MusicStop",
			{
				switch (BIS_fnc_EXP_m07_endingClient_trackCount) do {
					case 0: {
						// Second song
						[] spawn {
							scriptName "BIS_fnc_EXP_m07_endingClient: credits song 2";

							sleep 1;

							0 fadeMusic 1;
							playMusic "LeadTrack01_F_EXP";
						};
					};

					case 1: {
						// Remove eventhandler
						removeMusicEventHandler ["MusicStop", BIS_fnc_EXP_m07_endingClient_musicEH];

						// Third song
						[] spawn {
							scriptName "BIS_fnc_EXP_m07_endingClient: credits song 3";

							sleep 1;

							0 fadeMusic 1;
							playMusic "LeadTrack01_F";
						};
					};
				};

				// Increase index
				BIS_fnc_EXP_m07_endingClient_trackCount = BIS_fnc_EXP_m07_endingClient_trackCount + 1;
			}
		];

		// Wait for the cue to fade in
		waitUntil {time >= _fadeIn};

		// Fade music to max
		_fadeDur fadeMusic 1;
	};

	[] spawn {
		disableSerialization;
		scriptName "BIS_fnc_EXP_m07_ending: final video and credits";

        //("BIS_fnc_EXP_m07_endingClient_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK IN", 1];

		//play final video
		private _videoScript = ["a3\missions_f_exp\video\exp_m07_vout.ogv"] spawn BIS_fnc_playVideo;

		//subtitles
		private _sub = [] execVM "a3\Missions_F_Exp\Campaign\Briefings\EXP_m07_debriefing.sqf";

        waitUntil{scriptDone _videoScript};

		sleep 3;

		// Stop subtitles
		//terminate (missionNamespace getVariable [VAR_SS_INTRO_VIDEOS_SUBTITLES_SCRIPT, scriptNull]);
		BIS_fnc_EXP_camp_playSubtitles_terminate = true;

		// Play credits
		(findDisplay 46) createDisplay "RscCredits";
		[] call BIS_fnc_credits_movie;

		// Wait for the credits to finish
		waitUntil {!(isNil {BIS_fnc_credits_movie_script})};
		waitUntil {scriptDone BIS_fnc_credits_movie_script};

		// Keep volume muted
		0 fadeSound 0;

		// Tell server that the player finished
		player setVariable ["BIS_fnc_EXP_m07_ending_finished", true, if (isMultiplayer) then {2} else {false}];
	};
};

sleep 5;

if (isServer) then {
	// Delete everything in the mission except players and helicopters
	private _objects = entities "All";
	private _units = units group driver BIS_heliExtract;
	_units = _units + [BIS_heliExtract];
	_objects = _objects - _units;
	if (!(isNil {BIS_functions_mainscope})) then {_objects = _objects - [BIS_functions_mainscope]};

	private _keep = [BIS_boss, BIS_HQ, BIS_miller, BIS_ai_1, BIS_ai_2, BIS_ai_3, BIS_ai_4, BIS_james, BIS_falcon1, BIS_falcon2, BIS_falcon3];
	_objects = _objects - _keep;

	{if (!(isPlayer _x) && !(_x isKindOf "Logic")) then {deleteVehicle _x}} forEach _objects;
};

if (!(isDedicated)) then {
	// Spawn camera
	private _camera = "Camera" camCreate [10,10,10];
	_camera cameraEffect ["INTERNAL", "BACK"];

	// Face upwards for most FPS
	_camera camPreparePos (getPosATL BIS_heliExtract);
	_camera camPrepareFOV 0.4;
	_camera camCommitPrepared 0;
	[_camera, 90, 0] call BIS_fnc_setPitchBank;
};

if (isServer) then {
	// Wait for all players to finish or disconnect
	waitUntil {{!(isNull _x) && { !(_x getVariable ["BIS_fnc_EXP_m07_ending_finished", false]) }} count BIS_fnc_EXP_m07_endingServer_players == 0};

	// End the mission
	[["END1", true, 0, false, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
};

true
