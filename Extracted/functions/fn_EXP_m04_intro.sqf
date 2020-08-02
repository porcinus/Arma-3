if (BIS_devMode) exitWith {"BIS_capture" call BIS_fnc_missionTasks; BIS_introEnded = true; BIS_heli1 flyInHeight 10; BIS_takeOff = true};

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
				_unit setPos (markerPos _marker);
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

if (isServer) then {
	// Play conversation
	"01_Blocking" spawn BIS_fnc_missionConversations;
};

sleep 1;

if (!(isDedicated)) then {
	// Situation report
	[
		[localize "STR_A3_EXP_m04_sitrep01", 2, 2],	// ToDo: localize
		[localize "STR_A3_EXP_m04_sitrep02", 2, 3],				// ToDo: localize
		[localize "STR_A3_EXP_m04_sitrep03", 1, 5, 1]							// ToDo: localize
	] spawn BIS_fnc_EXP_camp_SITREP;
};

sleep 15;

if (!(isDedicated)) then {
	// Fade in game sound
	6 fadeSound 1;
};

sleep 3;

if (!(isDedicated)) then {
	// Move player out of locked pose
	player enableSimulation true;
	player switchMove "AmovPercMstpSrasWrflDnon";

	// Fade in the world
	(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "BLACK IN", 3];
};

if (isServer) then {
	// Register that the intro ended
	BIS_introEnded = true;
};

sleep 3;

if (isServer) then {
	// Add task
	"BIS_capture" call BIS_fnc_missionTasks;

	// Let helicopter take off
	BIS_heli1 flyInHeight 10;
	BIS_takeOff = true;
};

true