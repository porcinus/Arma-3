/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    08-08-2016

	fn_EXP_camp_lobby_getHostSettings.sqf

		Campaign Lobby: Grabs the host settings for respawn and revive

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Init
private _bUpdateClients		= _this select 0;
private _bResetSettings		= _this select 1;

// Check if the mission already has the settings defined
private _settingsRespawn	= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_RESPAWN";
private _settingsRevive		= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_REVIVE";
private _bCheckProfile		= false;

// Grab host
private _host				= missionNamespace getVariable ["A3X_UI_LOBBY_HOST", objNull];

// Exit if not host
if (isNull _host || {player != _host}) exitWith {};

// Check host profile if there are no respawn settings
if (isNil { _settingsRespawn }) then
{
	_bCheckProfile = true;
};

// Check host profile if there are no revive settings
if (isNil { _settingsRevive }) then
{
	_bCheckProfile = true;
};

// Check if we should reset settings
if (_bResetSettings) then
{
	_settingsRevive		= nil;
	_settingsRespawn	= nil;
	_bCheckProfile		= false;
};

// Check profile
if (_bCheckProfile) then
{
	// Get respawn and revive settings from profile
 	_settingsRespawn	= profileNamespace getVariable "A3X_UI_LOBBY_SETTINGS_RESPAWN";
 	_settingsRevive		= profileNamespace getVariable "A3X_UI_LOBBY_SETTINGS_REVIVE";
};

// If there are no respawn settings set yet (first time)
if (isNil { _settingsRespawn }) then
{
	// Default setting
	private _bRespawnAlways			= false;
	private _bRespawnLimited		= false;
	private _bRespawnDisabled		= false;

	// Check the difficulty
	switch (difficulty) do
	{
		case 0: {_bRespawnAlways	= true};	// Recruit
		case 1: {_bRespawnLimited	= true};	// Regular
		case 2: {_bRespawnDisabled	= true};	// Veteran
		case 3: {_bRespawnLimited	= true};	// Custom
	};

	// Respawn Strings
	private _strAlways				= "STR_A3_RscDisplayCampaignLobby_Always";
	private _strLimited				= "STR_A3_RscDisplayCampaignLobby_Limited";
	private _strDisabled			= "STR_A3_RscDisplayCampaignLobby_Disabled";

	// Set the respawn array
	_settingsRespawn =
	[
		[0, _strAlways, _bRespawnAlways],
		[1, _strLimited, _bRespawnLimited],
		[2, _strDisabled, _bRespawnDisabled]
	];
};

// If there are no revive settings set yet (first time)
if (isNil { _settingsRevive }) then
{
	// Default setting
	private _bReviveAlways			= false;
	private _bReviveFAK				= false;
	private _bReviveMedic			= false;
	private _bReviveDisabled		= false;

	// Check the difficulty
	switch (difficulty) do
	{
		case 0: {_bReviveAlways		= true};	// Recruit
		case 1: {_bReviveFAK		= true};	// Regular
		case 2: {_bReviveMedic		= true};	// Veteran
		case 3: {_bReviveFAK		= true};	// Custom
	};

	// Revive Strings
	private _strAlways				= "STR_A3_RscDisplayCampaignLobby_Always";
	private _strFAK					= "STR_A3_RscDisplayCampaignLobby_FirstAidKit";
	private _strMedic				= "STR_A3_RscDisplayCampaignLobby_MedicOnly";
	private _strDisabled			= "STR_A3_RscDisplayCampaignLobby_Disabled";

	// Revive Settings
	_settingsRevive =
	[
		[0, _strAlways, _bReviveAlways],
		[1, _strFAK, _bReviveFAK],
		[2, _strMedic, _bReviveMedic],
		[3, _strDisabled, _bReviveDisabled]
	];
};

// Set to mission namespace
missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", _settingsRespawn, true];
missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", _settingsRevive, true];

// If we reset - save profile variables and namespace
if (_bResetSettings) then
{
	profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", _settingsRespawn];
	profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", _settingsRevive];
	saveProfileNamespace;
};

// Update server clients
if (_bUpdateClients) then
{
	remoteExec ["BIS_fnc_EXP_camp_lobby_updateHostSettings"];
};