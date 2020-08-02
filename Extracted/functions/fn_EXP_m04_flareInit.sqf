params [["_mode", "INIT", [""]], ["_info", [], [[]]]];

if (_mode == "UPDATE") then {
	// Remove all deleted flares from arrays
	{if (isNull _x) then {BIS_activeFlares = BIS_activeFlares - [_x]}} forEach BIS_activeFlares;
	{if (isNull _x) then {BIS_activeLights = BIS_activeLights - [_x]}} forEach BIS_activeLights;
	
	// Grab new flare info
	_info params ["_flare", "_light"];
	
	// Add new flare info to arrays
	BIS_activeFlares = BIS_activeFlares + [_flare];
	BIS_activeLights = BIS_activeLights + [_light];
	
	// Handle fake light
	[_light, _flare] spawn BIS_fnc_EXP_m04_flareLight;
} else {
	// Initialize handling of active flares
	// Find all active scripted flares
	BIS_activeFlares = (allMissionObjects "F_20mm_White_Infinite" + allMissionObjects "F_20mm_Red_Infinite");
	BIS_activeLights = allMissionObjects "#lightpoint";
	
	if (isMultiplayer) then {
		// Catch all future updates to the array (addPublicVariableEventHandler must be spawned)
		[] spawn {
			scriptName "BIS_fnc_EXP_m04_flareInit: add public variable eventhandler";
			
			// Add public variable eventhandler
			"BIS_newFlare" addPublicVariableEventHandler {
				// Update local state
				["UPDATE", _this select 1] call BIS_fnc_EXP_m04_flareInit;
			};
		};
	};
	
	// Process existing flares
	for "_i" from 0 to ((count BIS_activeFlares) - 1) do {["UPDATE", [BIS_activeFlares select _i, BIS_activeLights select _i]] call BIS_fnc_EXP_m04_flareInit};
};

true