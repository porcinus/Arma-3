/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_go.sqf

		Campaign Lobby: Run Mission

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Grab case
private _case			= _this param [0, 0, [0]];
private _closeBriefing	= _this param [1, false, [false]];

// Grab display controls
private _display			= findDisplay IDD_CAMPAIGN_LOBBY;
private _briefingDisplay	= displayNull;

// Grab briefing display
if !(isNull (findDisplay 52)) then
{
	_briefingDisplay = findDisplay 52;
}
else
{
	if !(isNull (findDisplay 53)) then
	{
		_briefingDisplay = findDisplay 53;
	};
};

// If this is dedicated, just quit
if (isDedicated) exitWith {};

// If the display has already closed (usually dedicated server forced timeout related), just clear vars
if (isNull _display) then
{
	// Clear vars
	["RscDisplayCampaignLobby"] call BIS_fnc_EXP_camp_lobby_clearVars;
};

// Grab host
private _host					= missionNamespace getVariable ["A3X_UI_LOBBY_HOST", objNull];

// If this is the host, then we want to publicize our mission settings for Respawn and Revive
if (player == _host) then
{
	// Save host settings to mission variables
	private _settingsRespawn	= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_RESPAWN";
	private _settingsRevive		= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_REVIVE";

	// Find out what the settings are
	private _respawnSetting		= nil;
	private _respawnMode		= "";
	private _reviveSetting		= nil;
	private _reviveMode			= "";

	// Go through respawn settings
	{
		if (_x select 2) exitWith
		{
			_respawnSetting		= _x select 0;
			_respawnMode		= _x select 1;
		};
	} foreach _settingsRespawn;

	// Go through revive settings
	{
		if (_x select 2) exitWith
		{
			_reviveSetting		= _x select 0;
			_reviveMode			= _x select 1;
		};
	} foreach _settingsRevive;

	// Register the settings for the mission to utilize
	missionNamespace setVariable ["#xdres", _respawnSetting, true];
	missionNamespace setVariable ["#xdrev", _reviveSetting, true];
};

// Run the game only when all players are ready
_display closeDisplay _case;
if (_closeBriefing) then {_briefingDisplay closeDisplay _case};

// Clear vars
["RscDisplayCampaignLobby"] call BIS_fnc_EXP_camp_lobby_clearVars;