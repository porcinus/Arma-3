if (missionNamespace getVariable ["BIS_fakePause", false]) then {
	// Ensure the scripts aren't duplicated
	if (!(isNil {BIS_fnc_EXP_m01_handlePause_script})) then {terminate BIS_fnc_EXP_m01_handlePause_script};
	
	BIS_fnc_EXP_m01_handlePause_script = _this spawn {
		disableSerialization;
		scriptName format ["BIS_fnc_EXP_m01_handlePause: fake black screen - %1", _this];
		
		params ["_display"];
		
		// Spawn a real black screen
		titleCut ["", "BLACK FADED", 10e10];
		
		waitUntil {
			// Fake black screen was removed
			!(missionNamespace getVariable ["BIS_fakePause", false])
			||
			// Pause menu was closed
			isNull _display
		};
		
		// Remove black screen
		titleCut ["", "PLAIN"];
	};
};

true