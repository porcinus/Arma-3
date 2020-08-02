while {!(BIS_alerted)} do {
	// Wait for players to be spotted
	waitUntil {
		private _time = time + 1;
		waitUntil {BIS_alerted || time >= _time};

		BIS_alerted
		||
		{alive _x && { behaviour _x == "COMBAT" }} count BIS_searchers > 0
	};

	if (!(BIS_alerted)) then {
		// Give time to stop the alert
		private _time = time + 4;
		waitUntil {BIS_alerted || time >= _time};

		if (!(BIS_alerted)) then {
			// If players are still spotted
			if (
				{alive _x && { behaviour _x == "COMBAT" }} count BIS_searchers > 0
			) then {
				// Start the hunt
				BIS_alerted = true;
			};
		};
	};
};

// Launch red flare
private _pos = [markerPos "BIS_flareCenter", random 200, random 360] call BIS_fnc_relPos;
_pos set [2, (150 + random 50)];
["RED", _pos, (20 + random 10), true] spawn BIS_fnc_EXP_m04_flareCreate;

// Alert everyone
{
	// So long as they're not in a vehicle or excluded
	if (vehicle _x == _x && { !(_x in BIS_garrison1) }) then {
		_x setBehaviour "AWARE";
		_x setSpeedMode "NORMAL";
	};
} forEach BIS_searchers;

sleep 4;

// Play conversation
if (isServer) then {private _conversationScript = ["x05_Spotted"] spawn BIS_fnc_missionConversations;};

true