// Disable everything other than dialogues
enableSentences false;

if (!(isDedicated)) then {
	if (alive player) then {
		// Disable & reset damage, move out of incapacitated state
		player setCaptive true;
		player allowDamage false;
		player setDamage 0;
		player setUnconscious false;
		["",0,player] call bis_fnc_reviveOnState;
		player setVariable ["#rev", 0, true];
	};

	// Fade out
	titleCut ["", "BLACK OUT", 1];
};

sleep 1;

if (!(isDedicated)) then {
	private _pos = getPosATL (vehicle player);
	_pos set [2, 1];

	// Create camera to lock player's view
	BIS_fnc_EXP_m04_feed2_viewLock = "Camera" camCreate _pos;
	BIS_fnc_EXP_m04_feed2_viewLock cameraEffect ["INTERNAL", "BACK"];

	// Face the sky to maintain high framerate
	BIS_fnc_EXP_m04_feed2_viewLock camPrepareFOV 0.3;
	BIS_fnc_EXP_m04_feed2_viewLock camCommitPrepared 0;
	[BIS_fnc_EXP_m04_feed2_viewLock, 90, 0] call BIS_fnc_setPitchBank;

	[] spawn {
		scriptName "BIS_fnc_EXP_m04_feed2: video control";

		// Play video
		["\a3\missions_f_exp\video\exp_m04_v02.ogv"] call BIS_fnc_playVideo;

		sleep 1;

		// Disable view lock
		BIS_fnc_EXP_m04_feed2_viewLock cameraEffect ["TERMINATE", "BACK"];
		camDestroy BIS_fnc_EXP_m04_feed2_viewLock;

		if (alive player) then {
			// Allow damage
			player setCaptive false;
			player allowDamage true;
		};

		// Return to world
		titleCut ["", "BLACK IN", 1];

		// Enable sentences
		enableSentences true;
	};
};

sleep 3;

if (isServer) then {
	// Spawn search parties
	[] spawn BIS_fnc_EXP_m04_search;
};

true