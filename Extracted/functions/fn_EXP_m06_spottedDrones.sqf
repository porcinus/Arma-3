// Wait for status to synchronize
waitUntil {{isNil _x} count ["BIS_spottedUGV", "BIS_spottedTurret"] == 0};

if (isServer) then {
	// Handle spotting UGVs
	[] spawn {
		scriptName "BIS_fnc_EXP_m06_spottedDrones: server UGV control";

		waitUntil {BIS_spottedUGV};

		// Play conversation
		private _conversationScript = ["55_UGV_Spotted"] spawn BIS_fnc_missionConversations;
	};

	// Handle spotting turrets
	[] spawn {
		scriptName "BIS_fnc_EXP_m06_spottedDrones: server turret control";

		waitUntil {BIS_spottedTurret};

		// Play conversation
		private _conversationScript = ["60_Turret_Spotted"] spawn BIS_fnc_missionConversations;
	};
};

if (!(isDedicated)) then {
	// Wait for player to exist
	waitUntil {!(isNull player)};

	if (!(BIS_spottedUGV)) then {
		// Client-side UGV control
		[] spawn {
			scriptName "BIS_fnc_EXP_m06_spottedDrones: client UGV control";

			private _drones = [BIS_UGV1, BIS_UGV2];

			waitUntil {
				// Someone else spotted a UGV
				BIS_spottedUGV
				||
				{
					// Player is close enough to a UGV
					{vehicle player distance _x <= 10} count _drones > 0
					&&
					// Player is looking at a UGV
					{ {cursorObject == _x} count _drones > 0 }
				}
			};

			if (!(BIS_spottedUGV)) then {
				// Register that a UGV was spotted
				BIS_spottedUGV = true;
				publicVariable "BIS_spottedUGV";
			};
		};
	};

	if (!(BIS_spottedTurret)) then {
		// Client-side turret control
		[] spawn {
			scriptName "BIS_fnc_EXP_m06_spottedDrones: client turret control";

			private _drones = [BIS_turret1];

			waitUntil {
				// Someone else spotted a UGV
				BIS_spottedTurret
				||
				{
					// Player is close enough to a UGV
					{vehicle player distance _x <= 10} count _drones > 0
					&&
					// Player is looking at a UGV
					{ {cursorObject == _x} count _drones > 0 }
				}
			};

			if (!(BIS_spottedTurret)) then {
				// Register that a UGV was spotted
				BIS_spottedTurret = true;
				publicVariable "BIS_spottedTurret";
			};
		};
	};
};

true