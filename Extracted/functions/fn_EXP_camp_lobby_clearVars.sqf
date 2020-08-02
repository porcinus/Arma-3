/*

	PROJECT:	R&D
	AUTHOR:		Endstar
	DATE:		18-04-2016

	fn_EXP_camp_lobby_clearVars.sqf

		Campaign Lobby: Clear variables

	Params

		0:

	Return

		0:
*/

// Check Resource
private ["_resource"];
_resource = _this select 0;

if (isNil { _this }) then
{
	_resource = "";
};

// Check resources to determine variable clearance
switch (_resource) do
{
	// Campaign Lobby
	case "RscDisplayCampaignLobby":
	{
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTIONS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTION_SELECTED", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTION_HOVER", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_PLAYER_SLOTS", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTIONS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_SELECTED", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_HOVER", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_FINAL", nil];

		missionNamespace setVariable ["A3X_UI_LOBBY_PLAYERS", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_HOST", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_DEDICATED", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil];

		missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", nil];
	};

	// Default is all
	default
	{
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_VIDEO", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTIONS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTION_SELECTED", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MISSION_OPTION_HOVER", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_PLAYER_SLOTS", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTIONS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_SELECTED", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_HOVER", nil];

		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", nil];
		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_FINAL", nil];

		missionNamespace setVariable ["A3X_UI_LOBBY_PLAYERS", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_HOST", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_DEDICATED", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil];

		missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", nil];
		missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", nil];
	};
};