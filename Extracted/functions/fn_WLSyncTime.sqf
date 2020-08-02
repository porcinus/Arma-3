/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Introduces a synchronized time value for server and clients.
OBSOLETE NOW AFTER (call BIS_fnc_WLSyncedTime) FIX
*/

if (isServer) then {
	addMissionEventHandler ["PlayerConnected", {
		BIS_WL_forceTimeSync = TRUE;
	}];
	missionNamespace setVariable ["BIS_WL_syncedTime", time, TRUE];
	BIS_WL_forceTimeSync = FALSE;
	[] spawn {
		_lastSync = time;
		while {TRUE} do {
			if (time > (_lastSync + 15) || BIS_WL_forceTimeSync) then {
				missionNamespace setVariable ["BIS_WL_syncedTime", time, TRUE];
				_lastSync = time;
				BIS_WL_forceTimeSync = FALSE;
			};
			sleep 0.25;
			BIS_WL_syncedTime = time;
		};
	};
} else {
	waitUntil {!isNil "BIS_WL_syncedTime"};
	[] spawn {
		while {TRUE} do {
			sleep 0.25;
			BIS_WL_syncedTime = BIS_WL_syncedTime + 0.25;
		};
	};
};