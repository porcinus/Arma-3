_this spawn {
	disableSerialization;
	_mode = _this select 0;
	if ((_mode == "open") && (time > 1) && (isNil {uiNamespace getVariable "BIS_RscRespawnControls_skipBlackOut"}) && simulationenabled player) then {
		_respawnDelay = playerRespawnTime;
		switch true do {
			case (_respawnDelay > 5): {
				_time = time + 3;
				waitUntil {(time > _time) || (!isNil {uiNamespace getVariable "BIS_RscRespawnControls_skipBlackOut"})};
				if (alive player) exitWith {_mode = "close"};	//safe-check when mission designer manipulates with respawn time (player could get stuck in the respawn screen in that case)
				cutText ["","black out",0.5];
				sleep 1;
				cutText ["","black in"];
				if (alive player) exitWith {_mode = "close"};	//safe-check when mission designer manipulates with respawn time (player could get stuck in the respawn screen in that case)
			};
			case (_respawnDelay > 2): {
				_time = time + 0.5;
				waitUntil {(time > _time) || (!isNil {uiNamespace getVariable "BIS_RscRespawnControls_skipBlackOut"})};
				if (alive player) exitWith {_mode = "close"};	//safe-check when mission designer manipulates with respawn time (player could get stuck in the respawn screen in that case)
				cutText ["","black out",0.5];
				sleep 1;
				cutText ["","black in"];
				if (alive player) exitWith {_mode = "close"};	//safe-check when mission designer manipulates with respawn time (player could get stuck in the respawn screen in that case)
			};
		};
	};

	// Add mission ended event handler and make sure scoreboard show is set to default when mission ends
	// Otherwise, a player which is in respawn menu when mission ends, he will have it's scoreboard not showing up in the debriefing UI
	if (isNil {missionNamespace getVariable "BIS_showRespawnMenu_ended"}) then
	{
		missionNamespace setVariable ["BIS_showRespawnMenu_ended", addMissionEventHandler ["Ended", {showScoretable -1;}]];
	};

	// Add respawn event handler
	// If local player respawns we make sure to reset scoretable visibility
	if (isNil {missionNamespace getVariable "BIS_showRespawnMenu_resp"}) then
	{
		missionNamespace setVariable ["BIS_showRespawnMenu_resp", addMissionEventHandler ["EntityRespawned", {if (_this select 0 == player) then {showScoretable -1;};}]];
	};

	with uiNamespace do
	{
		_fnc_functionTrigger =
		{
			// onRespawnMenu event script call with override
			if (
				getMissionConfigValue "onRespawnMenu" isEqualType ""
				&&
				{compile preprocessFileLineNumbers getMissionConfigValue "onRespawnMenu" count [nil] isEqualTo 1}
			)
			exitWith {};

			with uiNamespace do
			{
				// All these functions must detect if spectator or map is running and use proper controls/display!
				[] spawn BIS_fnc_showRespawnMenuHeader;
				[] spawn BIS_fnc_showRespawnMenuPosition;
				[] spawn BIS_fnc_showRespawnMenuInventory;
				["close"] spawn BIS_fnc_showRespawnMenuInventoryDetails;
			};
		};

		switch _mode do
		{
			case "open":
			{
				waitUntil {!isNil {missionNamespace getVariable "BIS_RscRespawnControlsMap_shown"} || (time > 1)};

				if !(missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]) then
				{
					// Open map and unhide controls group
					openMap [true,true];
					showScoretable 0;
					(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlEnable true;
					(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 0;
					(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
					missionNamespace setVariable ["BIS_RscRespawnControlsMap_shown", true];
					uiNamespace setVariable ["BIS_RscRespawnControls_countDone", false];

					// If handler was added make sure to remove before re-adding
					(uiNamespace getVariable ["BIS_RscRespawnControlsMap_display", displayNull]) displayRemoveEventHandler ["KeyDown", missionNamespace getVariable ["BIS_RscRespawnControls_escHandler", -1]];
					missionNamespace setVariable ["BIS_RscRespawnControls_escHandler", nil];

					// Pause menu handler
					missionNamespace setVariable ["BIS_RscRespawnControls_escHandler", (uiNamespace getVariable ["BIS_RscRespawnControlsMap_display", displayNull]) displayAddEventHandler ["keyDown",
					{
						if ((_this select 1) in actionKeys "IngamePause") then
						{
							uiNamespace setVariable ["BIS_RscRespawnControls_selected",[lbCurSel (uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlLocList"),lbCurSel (uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlRoleList"),lbCurSel (uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlComboLoadout")]];

							// The custom pause menu
							private _pauseDisplay = uiNamespace getVariable ["BIS_RscRespawnControls_pauseDisplay", displayNull];

							// Ingame, open pause menu and hide respawn screen
							if (isNull _pauseDisplay) then
							{
								_pauseDisplay = (findDisplay 46) createDisplay "RscDisplayMPInterrupt";
								uiNamespace setVariable ["BIS_RscRespawnControls_pauseDisplay", _pauseDisplay];
								(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 1;
								(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
								showScoretable 0;
							}
							// In pause menu, close menu and unhide respawn screen
							else
							{
								private _childDestroyed = false;

								if (!isNull (findDisplay 4)) then 	{(findDisplay 4) closeDisplay 2; 	_childDestroyed = true;};
								if (!isNull (findDisplay 5)) then 	{(findDisplay 5) closeDisplay 2; 	_childDestroyed = true;};
								if (!isNull (findDisplay 6)) then 	{(findDisplay 6) closeDisplay 2; 	_childDestroyed = true;};
								if (!isNull (findDisplay 148)) then {(findDisplay 148) closeDisplay 2; 	_childDestroyed = true;};
								if (!isNull (findDisplay 151)) then {(findDisplay 151) closeDisplay 2;	_childDestroyed = true;};
								if (!isNull (findDisplay 162)) then {(findDisplay 162) closeDisplay 2; 	_childDestroyed = true;};

								if (!_childDestroyed) then
								{
									_pauseDisplay closeDisplay 2;
									uiNamespace setVariable ["BIS_RscRespawnControls_pauseDisplay", displayNull];

									if (isNull _pauseDisplay) then
									{
										(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 0;
										(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
									};
								};
							};

							true;
						};
					}]];

					//Scoretable handler -- key 25
					missionNamespace setVariable ["BIS_RscRespawnControls_showScoreHandler", (uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayAddEventHandler ["keyDown",{if ((!visibleScoretable) && {(_this select 1) in actionKeys "NetworkStats"}) then {showScoretable 1}}]];
					missionNamespace setVariable ["BIS_RscRespawnControls_hideScoreHandler", (uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayAddEventHandler ["keyUp",{if (visibleScoretable && {(_this select 1) in actionKeys "NetworkStats"}) then {showScoretable 0}}]];
					//Map handlers
					missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerDraw", (uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlAddEventHandler ["draw","_this call BIS_fnc_showRespawnMenuPositionMap"]];
					missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerMoving", (uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlAddEventhandler ["MouseMoving",{["moving",_this] call BIS_fnc_showRespawnMenuPositionMapHandle}]];	//map moving mouse
					missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerDown", (uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlAddEventhandler ["MouseButtonDown",{["click",_this] call BIS_fnc_showRespawnMenuPositionMapHandle}]];	//map click handler

					//Variables
					missionNamespace setVariable ["BIS_RscRespawnControls_mapInit", true];
					uiNamespace setVariable ["BIS_RscRespawnControls_iconColor", [(side group player)] call BIS_fnc_sideColor];

					call _fnc_functionTrigger;
				};
			};

			case "map":
			{
				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlEnable false;
				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlSetFade 1;
				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlCommit 0;
				missionNamespace setVariable ["BIS_RscRespawnControlsSpectate_shown", false];
				uiNamespace setVariable ["BIS_RscRespawnControlsSpectate_loaded", nil];

				openMap [true,true];
				showScoretable 0;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlEnable true;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 0;
				missionNamespace setVariable ["BIS_RscRespawnControlsMap_shown", true];
				missionNamespace setVariable ["BIS_RscRespawnControls_mapInit", true];

				call _fnc_functionTrigger;

				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
			};

			case "spectate":
			{
				waitUntil {!isNil {uiNamespace getVariable "BIS_RscRespawnControlsSpectate_loaded"}};
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlEnable false;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 1;
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
				openMap [false,false];
				showScoretable -1;
				missionNamespace setVariable ["BIS_RscRespawnControlsMap_shown", false];

				waitUntil {!isNull (uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup")};

				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlEnable true;
				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlSetFade 0;
				missionNamespace setVariable ["BIS_RscRespawnControlsSpectate_shown", true];

				call _fnc_functionTrigger;

				(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlCommit 0;
			};

			case "close":
			{
				showScoretable -1;

				switch true do
				{
					case (missionNamespace getVariable ["BIS_RscRespawnControlsMap_shown", false]): //close map and hide controls group
					{
						(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlEnable false;
						(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlSetFade 1;
						(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlControlsGroup") ctrlCommit 0;
						openMap [false,false];
						missionNamespace setVariable ["BIS_RscRespawnControlsMap_shown", false];
					};

					case (missionNamespace getVariable ["BIS_RscRespawnControlsSpectate_shown", false]):
					{
						(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlEnable false;
						(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlSetFade 1;
						(uiNamespace getVariable "BIS_RscRespawnControlsSpectate_ctrlControlsGroup") ctrlCommit 0;
						missionNamespace setVariable ["BIS_RscRespawnControlsSpectate_shown", false];

						["Terminate"] call BIS_fnc_EGSpectator;
						uiNamespace setVariable ["BIS_RscRespawnControlsSpectate_loaded", nil];
					};
				};

				removeMissionEventHandler ["Ended", missionNamespace getVariable ["BIS_showRespawnMenu_ended", -1]];
				removeMissionEventHandler ["EntityRespawned", missionNamespace getVariable ["BIS_showRespawnMenu_resp", -1]];

				//--- Removing all handlers and other thing which could break the map otherwise

				(uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlRemoveEventHandler ["draw", missionNamespace getVariable ["BIS_RscRespawnControls_mapHandlerDraw", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerDraw", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlRemoveEventHandler ["MouseMoving", missionNamespace getVariable ["BIS_RscRespawnControls_mapHandlerMoving", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerMoving", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_map") ctrlRemoveEventHandler ["MouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_mapHandlerDown", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_mapHandlerDown", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayRemoveEventHandler ["keyDown", missionNamespace getVariable ["BIS_RscRespawnControls_showScoreHandler", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_showScoreHandler", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayRemoveEventHandler ["keyUp", missionNamespace getVariable ["BIS_RscRespawnControls_hideScoreHandler", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_hideScoreHandler", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayRemoveEventHandler ["keyDown", missionNamespace getVariable ["BIS_RscRespawnControls_escHandler", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_escHandler", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_display") displayRemoveEventHandler ["mouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerDisplay", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerDisplay", nil];
				(uiNamespace getVariable "BIS_RscRespawnControlsMap_ctrlDetailsControlsGroup") ctrlRemoveEventHandler ["mouseButtonDown", missionNamespace getVariable ["BIS_RscRespawnControls_detailsHandlerGroup", -1]];
				missionNamespace setVariable ["BIS_RscRespawnControls_detailsHandlerGroup", nil];
			};
		};
	};
};