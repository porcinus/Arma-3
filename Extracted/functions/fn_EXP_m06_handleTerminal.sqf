// Wait for the status to sync
waitUntil {{isNil _x} count ["BIS_terminalSpotted", "BIS_terminalConnected"] == 0};

if (isServer) then {
	[] spawn {
		scriptName "BIS_fnc_EXP_m06_handleTerminal: server control";

		// Wait for someone to spot the terminal
		waitUntil {BIS_terminalSpotted};

		// Play conversation
		private _conversationScript = ["50_Terminal_Spotted"] spawn BIS_fnc_missionConversations;

		// Wait for someone to connect
		waitUntil {isUAVConnected BIS_UAV1};

		// Mark drone as connected
		BIS_terminalConnected = true;
		publicVariable "BIS_terminalConnected";

		sleep 1;

		if (!(BIS_firstUAV)) then {
			// Player accessed other drones first
			private _conversationScript = ["30_UAV_Connected"] spawn BIS_fnc_missionConversations;
		};
	};
};

if (!(isDedicated)) then {
	if (!(BIS_terminalSpotted)) then {
		waitUntil {
			// Someone else spotted the terminal
			BIS_terminalSpotted
			||
			{
				(
					// Player is close enough
					vehicle player distance BIS_terminal1 <= 8
					&&
					// Player is looking at the terminal
					{ cursorObject == BIS_terminal1 }
				)
			}
		};

		if (!(BIS_terminalSpotted)) then {
			// Register that the player spotted the terminal
			BIS_terminalSpotted = true;
			publicVariable "BIS_terminalSpotted";

			// Play sound
			playSound ["ReadoutHideClick2", true];
		};
	};

	if (!(BIS_terminalConnected)) then {
		// Store alpha of icon
		BIS_terminalAlpha = 0;

		// Draw terminal icon
		addMissionEventHandler [
			"Draw3D",
			{
				// Do nothing if it was connected to
				if (missionNamespace getVariable ["BIS_terminalConnected", false]) exitWith {};

				private _icon = "a3\ui_f\data\igui\cfg\cursors\watch_ca.paa";
				private _color = [1,1,1];

				// Get the position of the terminal
				private _pos = getPosATLVisual BIS_terminal1;
				_pos set [2, (_pos select 2) + 0.5];

				// Draw icon
				drawIcon3D [
					_icon,
					_color + [BIS_terminalAlpha],
					_pos,
					1,
					1,
					0
				];
			}
		];

		private _fadeIcons = {
			scriptName format ["BIS_fnc_EXP_m06_handleTerminal: _fadeIcons - %1", _this];

			params ["_max", "_min"];

			private _range = _max - _min;
			private _dest = getPosATLVisual BIS_terminal1;
			private _dist = vehicle player distance _dest;

			while {!(BIS_terminalConnected)} do {
				if (_dist > _max) then {
					// Hide icon
					BIS_terminalAlpha = 0;

					// Wait for player to get close
					waitUntil {
						BIS_terminalConnected
						||
						{ vehicle player distance _dest <= _max }
					};
				};

				if (!(BIS_terminalConnected)) then {
					while {
						!(BIS_terminalConnected)
						&&
						{
							_dist = vehicle player distance _dest;
							_dist <= _max
						}
					} do {
						private _diff = _dist - _min;
						private ["_alphaIcon", "_alphaElse"];

						if (_diff <= 0) then {
							// Full visibility
							BIS_terminalAlpha = 1;
						} else {
							// Visibility relative to distance
							private _ratio = 1 - (_diff / _range);
							BIS_terminalAlpha = _ratio;
						};

						sleep 0.01;
					};

					// Ensure icon is hidden
					BIS_terminalAlpha = 0;
				};

				// Ensure icon is hidden
				BIS_terminalAlpha = 0;
			};
		};

		// Handle visibility of terminal icon
		[30, 25] spawn _fadeIcons;
	};
};

true