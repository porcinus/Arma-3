// Disable everything other than dialogues
enableSentences false;

if (!(isDedicated)) then {
	if (alive player) then {
		// Disable & reset damage, move out of incapacitated state
		player setCaptive true;
		player allowDamage false;
		player setDamage 0;
		player setUnconscious false;
	};

	// Fade out
	[] spawn {
		disableSerialization;
		scriptName "BIS_fnc_EXP_m01_endingClient: fade out";
		("BIS_fnc_EXP_m01_endingClient_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK OUT", 1];
	};
};

sleep 1;

private "_video";
if (!(isDedicated)) then {
	private _pos = getPosATL player;
	_pos set [2, 1];

	// Create camera to lock player's view
	BIS_fnc_EXP_m01_endingClient_viewLock = "Camera" camCreate _pos;
	BIS_fnc_EXP_m01_endingClient_viewLock cameraEffect ["INTERNAL", "BACK"];

	// Face the sky to maintain high framerate
	BIS_fnc_EXP_m01_endingClient_viewLock camPrepareFOV 0.3;
	BIS_fnc_EXP_m01_endingClient_viewLock camCommitPrepared 0;
	[BIS_fnc_EXP_m01_endingClient_viewLock, 90, 0] call BIS_fnc_setPitchBank;

	// Prevent player from being engaged and taking damage
	player setCaptive true;
	player allowDamage false;

	// Fade out sound
	10 fadeSound 0;

	[] spawn {
		scriptName "BIS_fnc_EXP_m01_endingClient: video control";

        //("BIS_fnc_EXP_m01_endingClient_layerBlackScreen" call BIS_fnc_rscLayer) cutText ["", "BLACK IN", 1];

		//play video
		private _videoScript = ["\a3\missions_f_exp\video\exp_m01_v01.ogv"] spawn BIS_fnc_playVideo;

		//subtitles
		private _sub = [] execVM "a3\Missions_F_Exp\Campaign\Briefings\EXP_m01_debriefing.sqf";

        waitUntil{scriptDone _videoScript};

		sleep 1;

		// Tell server that the player is ready
		player setVariable ["BIS_fnc_EXP_m01_endingClient_finished", true, if (isMultiplayer) then {2} else {false}];
	};
};

sleep 3;

if (isServer) then {
	// Grab everything
	private _objects = entities "All";

	// Define objects to keep
	private _keep = [BIS_HQ, BIS_cop1, BIS_radio1, BIS_monitor1, BIS_monitor2, BIS_lamp1, BIS_case1];
	_keep = _keep + (BIS_supportUnits + BIS_firstUnits + BIS_sentryUnits + BIS_secondUnits + BIS_reinfUnits);
	if (!(isNil {BIS_functions_mainscope})) then {_keep = _keep + [BIS_functions_mainscope]};
	_objects = _objects - _keep;

	// Delete everything
	{if (!(isPlayer _x)) then {deleteVehicle _x}} forEach _objects;

	// Wait for all players to finish videos
	waitUntil {{!(isNull _x) && { !(_x getVariable ["BIS_fnc_EXP_m01_endingClient_finished", false]) }} count BIS_fnc_EXP_m01_endingServer_players == 0};

	// End the mission everywhere
	[["END1", true, 0, false, false], "BIS_fnc_endMission", true, true] call BIS_fnc_MP;
};