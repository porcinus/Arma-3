if (BIS_devMode) exitWith {
	// Move instantly
	{
		private _unit = _x;

		_unit setBehaviour "AWARE";
		_unit setUnitPos "AUTO";

		{_unit enableAI _x} forEach ["AUTOTARGET", "MOVE", "TARGET"];
		_unit enableMimics true;
	} forEach [BIS_supportLead, BIS_support1];

	BIS_supportLead setPosATL [4449.52,4310.99,0.00163937];
	BIS_support1 setPosATL [4446.36,4310.22,0.00147438];

	// Initialize IFF
	private _units = [BIS_supportLead, BIS_support1, BIS_support2, BIS_support3];

	{
		private _unit = _x;
		{_unit setVariable [_x, false]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName"];
	} forEach _units;

	[_units] call BIS_fnc_EXP_camp_IFF;

	// Add task
	"BIS_first" call BIS_fnc_missionTasks;

	// Register as over
	BIS_introEnded = true;
};

if (!(isDedicated)) then {
	// Hide the HUD
	showHUD [true, false, false, false, false, false, false, true];

	/*private _animEH = player addEventHandler [
		"AnimStateChanged",
		{
			params ["_unit", "_anim"];

			if (_anim == "AmovPercMstpSlowWrflDnon") then {
				// Remove event handler
				private _animEH = _unit getVariable "BIS_animEH";

				if (!(isNil "_animEH")) then {
					_unit removeEventHandler ["AnimStateChanged", _unit getVariable "BIS_animEH"];
					_unit setVariable ["BIS_animEH", nil];
				};

				// Disable simulation
				_unit enableSimulation false;

				// Reposition
				private _marker = (str _unit) + "Pos";
				_unit setPos (markerPos _marker);
				_unit setDir (markerDir _marker);

				// Remove camera
				BIS_viewLock cameraEffect ["TERMINATE", "BACK"];
				camDestroy BIS_viewLock;

				// Add fake black screen
				BIS_fakeAlpha = 1;
				BIS_fakeBlackScreen = addMissionEventHandler [
					"Draw3D",
					{
						private _pos = [player, 1, direction player] call BIS_fnc_relPos;
						_pos set [2, 1];

						// Draw massive black icon
						drawIcon3D [
							"#(argb,8,8,3)color(0,0,0,1)",
							[1,1,1] + [BIS_fakeAlpha],
							_pos,
							10e10,
							10e10,
							0
						];
					}
				];

				// Allow real black screen when paused
				BIS_fakePause = true;

				private _units = [BIS_supportLead, BIS_support1, BIS_support2, BIS_support3];

				// Hide icons first
				{
					private _unit = _x;
					{_unit setVariable [_x, false]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName"];
				} forEach _units;

				// Initialize IFF
				[_units] call BIS_fnc_EXP_camp_IFF;

				// Remove the normal black screen
				(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "PLAIN"];
			};
		}
	];

	// Store event handler
	player setVariable ["BIS_animEH", _animEH];
	
	// Move into animation
	player playMove "AmovPercMstpSlowWrflDnon";*/
	
	[] spawn {
		scriptName "BIS_fnc_EXP_m01_intro: animation control";
		
		// Move into animation
		waitUntil {time > 0};
		waitUntil {player switchMove "AmovPercMstpSlowWrflDnon"; animationState player == "AmovPercMstpSlowWrflDnon"};
		
		// Disable simulation
		player enableSimulation false;

		// Reposition
		private _marker = (str player) + "Pos";
		player setPos (markerPos _marker);
		player setDir (markerDir _marker);

		// Remove camera
		BIS_viewLock cameraEffect ["TERMINATE", "BACK"];
		camDestroy BIS_viewLock;

		// Add fake black screen
		BIS_fakeAlpha = 1;
		BIS_fakeBlackScreen = addMissionEventHandler [
			"Draw3D",
			{
				private _pos = [player, 1, direction player] call BIS_fnc_relPos;
				_pos set [2, 1];

				// Draw massive black icon
				drawIcon3D [
					"#(argb,8,8,3)color(0,0,0,1)",
					[1,1,1] + [BIS_fakeAlpha],
					_pos,
					10e10,
					10e10,
					0
				];
			}
		];

		// Allow real black screen when paused
		BIS_fakePause = true;

		private _units = [BIS_supportLead, BIS_support1, BIS_support2, BIS_support3];

		// Hide icons first
		{
			private _unit = _x;
			{_unit setVariable [_x, false]} forEach ["BIS_iconAlways", "BIS_iconShow", "BIS_iconName"];
		} forEach _units;

		// Initialize IFF
		[_units] call BIS_fnc_EXP_camp_IFF;

		// Remove the normal black screen
		(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "PLAIN"];
	};
};

sleep 3;

if (!(isDedicated)) then {
	// Fade in game sound
	30 fadeSound 1;
};

sleep 3;

if (isServer) then {
	// Make Support Team start moving
	{
		_x setBehaviour "CARELESS";
		_x setUnitPos "UP";
	} forEach [BIS_supportLead, BIS_support1];

	BIS_supportLead playMove "Acts_SupportTeam_Front_StartMove";
	BIS_support1 playMove "Acts_SupportTeam_Left_StartMove";
};

sleep 1;

if (!(isDedicated)) then {
	// Bohemia Interactive Presents
	[] spawn {
		disableSerialization;
		scriptName "BIS_fnc_EXP_m01_intro: Bohemia Interactive Presents";

		// Create layer, display & control
		private _layerPresents = "BIS_layerBohemiaInteractivePresents" call BIS_fnc_rscLayer;
		_layerPresents cutRsc ["RscDynamicText", "PLAIN"];
		waitUntil {!(isNull (uiNamespace getVariable "BIS_dynamicText"))};
		private _displayPresents = uiNamespace getVariable "BIS_dynamicText";
		uiNamespace setVariable ["BIS_dynamicText", displayNull];
		private _ctrlPresents = _displayPresents displayCtrl 9999;

		// Position control
		_ctrlPresents ctrlSetPosition [
			0 * safeZoneW + safeZoneX,
			0.47 * safeZoneH + safeZoneY,
			safeZoneW,
			safeZoneH
		];

		// Hide & commit
		_ctrlPresents ctrlSetFade 1;
		_ctrlPresents ctrlCommit 0;

		_bisPresents = localize "STR_A3_ApexProtocol_BIS_Presents";

		// Add text
		_ctrlPresents ctrlSetStructuredText parseText _bisPresents;

		// Show text
		_ctrlPresents ctrlSetFade 0;
		_ctrlPresents ctrlCommit 5;

		sleep 11;

		// Hide text
		_ctrlPresents ctrlSetFade 1;
		_ctrlPresents ctrlCommit 5;
	};
};

sleep 11;

if (isServer) then {
	// Play conversation
	private _conversationScript = ["01_Start"] spawn BIS_fnc_missionConversations;
};

sleep 13;

[] spawn {
	scriptName "BIS_fnc_EXP_m01_intro: show IFF";

	{
		// Show icon with sound
		playSound ["ReadoutHideClick2", true];
		_x setVariable ["BIS_iconShow", true, isServer];
		sleep 0.1;
	} forEach [BIS_supportLead, BIS_support1];

	sleep 1;

	// Show names with sound
	playSound ["ReadoutHideClick2", true];

	{
		private _unit = _x;
		{_unit setVariable [_x, true, isServer]} forEach ["BIS_iconName", "BIS_iconAlways"];
	} forEach [BIS_supportLead, BIS_support1];
};

sleep 2;

if (isServer) then {
	// Play conversation
	"05_Online" spawn BIS_fnc_missionConversations;
};

sleep 2;

if (!(isDedicated)) then {
	// Let player move
	player enableSimulation true;
	player switchMove "AmovPercMstpSlowWrflDnon_AmovPercMstpSrasWrflDnon";

	// Show world
	BIS_fakePause = false;

	[] spawn {
		scriptName "BIS_fnc_EXP_m01_intro: show world";

		private _dur = 3;
		private _end = time + _dur;

		// Smoothly fade out the fake black screen
		while {time <= _end} do {
			BIS_fakeAlpha = (_end - time) / _dur;
			sleep 0.01;
		};

		// Remove the fake black screen entirely
		if (!(isNil {BIS_fakeBlackScreen})) then {removeMissionEventHandler ["Draw3D", BIS_fakeBlackScreen]};
		(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "PLAIN"];
	};

	// Show the HUD
	showHUD [true, true, true, true, true, true, true, true];
};

sleep 2;

if (isServer) then {
	// Play conversations
	"10_Spotted" spawn BIS_fnc_missionConversations;
};

sleep 12;

if (isServer) then {
	// Add task
	"BIS_first" call BIS_fnc_missionTasks;

	// Register that the intro ended
	BIS_introEnded = true;
};

sleep 5;

if (!(isDedicated)) then {
	// Situation report
	[
		[localize "STR_A3_exp_m01_sitrep01", 2, 2],
		[localize "STR_A3_exp_m01_sitrep02", 2, 4],
		[localize "STR_A3_exp_m01_sitrep03", 2, 6],
		[localize "STR_A3_exp_m01_sitrep04", 1, 9, 1]
	] spawn BIS_fnc_EXP_camp_SITREP;
};

true