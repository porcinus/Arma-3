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
	BIS_fnc_EXP_m04_feed1_viewLock = "Camera" camCreate _pos;
	BIS_fnc_EXP_m04_feed1_viewLock cameraEffect ["INTERNAL", "BACK"];

	// Face the sky to maintain high framerate
	BIS_fnc_EXP_m04_feed1_viewLock camPrepareFOV 0.3;
	BIS_fnc_EXP_m04_feed1_viewLock camCommitPrepared 0;
	[BIS_fnc_EXP_m04_feed1_viewLock, 90, 0] call BIS_fnc_setPitchBank;

	[] spawn {
		scriptName "BIS_fnc_EXP_m04_feed1: video control";

		// Play video
		["\a3\missions_f_exp\video\exp_m04_v01.ogv"] call BIS_fnc_playVideo;

		sleep 1;

		// Disable view lock
		BIS_fnc_EXP_m04_feed1_viewLock cameraEffect ["TERMINATE", "BACK"];
		camDestroy BIS_fnc_EXP_m04_feed1_viewLock;

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
	// Register Support Team moved
	BIS_supportMoved = true;
	publicVariable "BIS_supportMoved";

	// Unhide Support Team
	{
		_x hideObjectGlobal false;
		_x enableSimulationGlobal true;
	} forEach BIS_supportUnits;

	// Unhide extraction truck
	[BIS_extractTruck, BIS_extractTruck getVariable "BIS_alt"] call BIS_fnc_setHeight;
	BIS_extractTruck hideObjectGlobal false;
	BIS_extractTruck enableSimulationGlobal true;

	{
		// Split Support Team
		private _group = createGroup WEST;
		[_x] joinSilent _group;

		// Ensure new group uses vehicle
		_group addVehicle BIS_extractTruck;
	} forEach [BIS_support1, BIS_support2, BIS_support3];

	// Ensure Support Lead uses vehicle
	BIS_supportGroup addVehicle BIS_extractTruck;

	// Move driver into vehicle
	BIS_support1 assignAsDriver BIS_extractTruck;
	BIS_support1 moveInDriver BIS_extractTruck;
	{BIS_support1 disableAI _x} forEach ["AUTOCOMBAT", "AUTOTARGET", "TARGET", "MOVE"];
	{_x setcaptive true;_x allowfleeing 0} forEach [BIS_support1];

	// Move the rest into cargo
	{_x assignAsCargo BIS_extractTruck;_x setcaptive true;_x allowfleeing 0} forEach [BIS_supportLead, BIS_support2, BIS_support3];
	BIS_supportLead moveInCargo [BIS_extractTruck, 15];
	BIS_support2 moveInCargo [BIS_extractTruck, 14];
	BIS_support3 moveInCargo [BIS_extractTruck, 5];

	BIS_extractTruck setCaptive true;
};

true