if (isServer) then {
	// Unhide plane
	{
		_x enableSimulationGlobal true;
		_x hideObjectGlobal false;
	} forEach BIS_plane;
};

if (BIS_devMode) exitWith {BIS_introEnded = true; "BIS_RV" call BIS_fnc_missionTasks; true};

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

sleep 2;

if (!(isDedicated)) then {
	// Start fading in the world
	15 fadeSound 1;
};

sleep 3;

if (!(isDedicated)) then {
	// Situation report
	[
		[localize "STR_A3_EXP_m02_SitrepText_1", 2, 4],
		[localize "STR_A3_EXP_m02_SitrepText_2", 2, 3],
		[localize "STR_A3_EXP_m02_SitrepText_3", 1, 7, 1]
	] spawn BIS_fnc_EXP_camp_SITREP;
};

sleep 8;

if (isServer) then {
	// Play conversation
	"01_Start" spawn BIS_fnc_missionConversations;
};

sleep 8;

if (!(isDedicated)) then {
	// Move player out of locked pose
	player enableSimulation true;
	player switchMove "AmovPercMstpSlowWrflDnon_AmovPercMstpSrasWrflDnon";

	// Fade in the world
	(uiNamespace getVariable "BIS_layerBlackScreen") cutText ["", "BLACK IN", 3];
};

if (isServer) then {
	"BIS_RV" call BIS_fnc_missionTasks;
};

true