if (hasInterface) then
{
	if (typeof cameraon == "Seagull") then
	{
		//[<unit>,<killer>,<seagull>]
		["playerRespawnSeagullScript",[player,objnull,cameraon]] call bis_fnc_selectRespawnTemplate;
	}
	else
	{
		//--- Add a loaded event and detect when a save game is loaded in multiplayer
		//--- Trigger respawn counter for the case when player was dead before saving the game
		//--- If the player is waiting for respawn and Counter is a respawn template
		if (isNil {missionNamespace getVariable "BIS_fnc_selectRespawnTemplate_loaded"}) then
		{
			missionNamespace setVariable ["BIS_fnc_selectRespawnTemplate_loaded", addMissionEventHandler ["Loaded",
			{
				if (playerRespawnTime >= 1) then
				{
					private _respawnOrig 		= 0 call bis_fnc_missionRespawnType;
					private _respawnTemplates 	= [configfile >> "CfgRespawnTemplates", "respawnTemplates" + (["", _respawnOrig] call bis_fnc_missionRespawnType)] call bis_fnc_returnConfigEntry;

					if ("Counter" in _respawnTemplates) then
					{
						[player] call BIS_fnc_respawnCounter;
					};
				};
			}]];
		};

		private _fnc_initRespawn =
		{
			disableserialization;
			waituntil {!isnull ([] call bis_fnc_displayMission)};
			"bis_fnc_initRespawn" call bis_fnc_startloadingscreen;
			["initRespawn",[player,objnull]] call bis_fnc_selectRespawnTemplate;
			"bis_fnc_initRespawn" call bis_fnc_endloadingscreen;
		};

		if (isnull ([] call bis_fnc_displayMission)) then {[] spawn _fnc_initRespawn;} else {[] call _fnc_initRespawn;};
	};

	true
};

if (isServer) then
{
	// Handle player disconnection
	// When a player disconnects we need to clear limits from him
	if (isNil {missionNamespace getVariable "BIS_initRespawn_disconnect"}) then
	{
		missionNamespace setVariable ["BIS_initRespawn_disconnect", addMissionEventHandler ["HandleDisconnect",
		{
			with uiNamespace do {[1, _this select 0] call BIS_fnc_showRespawnMenuInventoryLimitRespawn};
			["HandleDisconnect : %1", _this select 0] call BIS_fnc_logFormat;
			false;
		}]];
	};
};