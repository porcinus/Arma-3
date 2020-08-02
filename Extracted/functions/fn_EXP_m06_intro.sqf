// Let the boat move
(driver BIS_civBoat1) enableAI "MOVE";

if (BIS_devMode) exitWith {BIS_meetUp = true; true};

// Detect when the player's animation changes
if (!(isDedicated)) then {
	private _animEH = player addEventHandler [
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
				private _pos = markerPos _marker;
				_pos set [2,0];
				_unit setPosATL _pos;
				_unit setDir (markerDir _marker);

				// Remove camera
				BIS_viewLock cameraEffect ["TERMINATE", "BACK"];
				camDestroy BIS_viewLock;
			};
		}
	];

	// Store event handler
	player setVariable ["BIS_animEH", _animEH];

	// Move into animation
	player playMove "AmovPercMstpSlowWrflDnon";
};

sleep 1;

if (!(isDedicated)) then {
	// Fade in game sound
	30 fadeSound 1;
};

sleep 2;

if (!(isDedicated)) then {
	[] spawn {
		scriptName "BIS_fnc_EXP_m06_intro: mission start";

		// Situation report
		private _script = [
			[localize "STR_A3_Exp_m06_sitrep01", 2, 3],
			[localize "STR_A3_Exp_m06_sitrep02", 2, 4],
			[localize "STR_A3_Exp_m06_sitrep03", 1, 5, 1]
		] spawn BIS_fnc_EXP_camp_SITREP;

		waitUntil {scriptDone _script};

		// Move player out of locked pose
		player enableSimulation true;
		player switchMove "AmovPercMstpSlowWrflDnon_AmovPercMstpSrasWrflDnon";

		// Fade in world
		(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "BLACK IN", 3];
	};
};

sleep 8;

// Play conversation
if (isServer) then {private _conversationScript = ["01_Start"] spawn BIS_fnc_missionConversations;};
true