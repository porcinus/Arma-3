/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    08-08-2016

	fn_EXP_camp_lobby_updateHostSettings.sqf

		Campaign Lobby: Updates all clients with the latest host settings

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Campaign Lobby display
private _display				= findDisplay IDD_CAMPAIGN_LOBBY;

// Init Briefing Display
private _briefingDisplay		= displayNull;

// Grab briefing display
if !(isNull (findDisplay 52)) then
{
	_briefingDisplay			= findDisplay 52;
} else
{
	if !(isNull (findDisplay 53)) then
	{
		_briefingDisplay		= findDisplay 53;
	};
};

// Settings Search Controls (Not in use)
private _settingsSearchGroup	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP);
private _settingsSearchImage	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 1);
private _settingsSearchTitle	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 2);
private _settingsSearchMode		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 3);
private _settingsSearchButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SEARCH_GROUP + 4);

// Settings Reset Controls
private _settingsResetGroup		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP);
private _settingsResetImage		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 1);
private _settingsResetTitle		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 2);
private _settingsResetMode		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 3);
private _settingsResetButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_SETTINGS_GROUP + 4);

// Settings Respawn Controls
private _settingsRespawnGroup	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP);
private _settingsRespawnImage	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 1);
private _settingsRespawnTitle	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 2);
private _settingsRespawnMode	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 3);
private _settingsRespawnButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_RESPAWN_GROUP + 4);

// Settings Revive Controls
private _settingsReviveGroup	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP);
private _settingsReviveImage	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 1);
private _settingsReviveTitle	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 2);
private _settingsReviveMode		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 3);
private _settingsReviveButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 4);

// Military Efficiency Controls
private _militaryGroup			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP);
private _militaryTitle			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 1);
private _militaryMode			= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 2);
private _militaryEfficiency		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_MILITARY_GROUP + 3);

// Grab the variables
private _settingsRespawn		= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_RESPAWN";
private _settingsRevive			= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_REVIVE";

// Grab host
private _host					= missionNamespace getVariable ["A3X_UI_LOBBY_HOST", objNull];

if (isNull _host) then
{
	"Host is NULL" call BIS_fnc_error;
};

if (isNil { _settingsRespawn }) exitWith
{
	// Function to update all machines with host settings
	[true, false] remoteExec ["BIS_fnc_EXP_camp_lobby_getHostSettings", owner _host];
};

if (isNil { _settingsRevive }) exitWith
{
	// Function to update all machines with host settings
	[true, false] remoteExec ["BIS_fnc_EXP_camp_lobby_getHostSettings", owner _host];
};

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

// Disable Search Button
_settingsSearchButton	ctrlShow false;
_settingsSearchButton	ctrlCommit 0;

// Set texts
_settingsResetTitle		ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Reset"));
_settingsResetMode		ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Settings"));
_settingsRespawnTitle	ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Respawn"));
_settingsReviveTitle	ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Revive"));

_militaryTitle			ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Combat"));
_militaryMode			ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_Efficiency"));

// Set mode text
_settingsRespawnMode	ctrlSetText (toUpper (if (isLocalized _respawnMode) then {localize _respawnMode} else {_respawnMode}));
_settingsReviveMode		ctrlSetText (toUpper (if (isLocalized _reviveMode) then {localize _reviveMode} else {_reviveMode}));

// Set respawn colours
switch (_respawnSetting) do
{
	case 0: { _settingsRespawnMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BLUE + ALPHA_100]	call BIS_fnc_HEXtoRGB);	}; // Always (Blue)
	case 1: { _settingsRespawnMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100]	call BIS_fnc_HEXtoRGB);	}; // Limited (Orange)
	case 2: { _settingsRespawnMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_RED + ALPHA_100]		call BIS_fnc_HEXtoRGB);	}; // Disabled (Red)
};

// Set revive colours
switch (_reviveSetting) do
{
	case 0: { _settingsReviveMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BLUE + ALPHA_100]		call BIS_fnc_HEXtoRGB);	}; // Always (Blue)
	case 1: { _settingsReviveMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_YELLOW + ALPHA_100]	call BIS_fnc_HEXtoRGB);	}; // First Aid Kit (Yellow)
	case 2: { _settingsReviveMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100]	call BIS_fnc_HEXtoRGB);	}; // Medic Only (Orange)
	case 3: { _settingsReviveMode ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_RED + ALPHA_100]		call BIS_fnc_HEXtoRGB);	}; // Disabled (Red)
};

// Clients
if (player != _host) then
{
	// Fade reset settings icon and hide text
	_settingsResetImage		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BUTTON + ALPHA_00] call BIS_fnc_HEXtoRGB);
	_settingsResetTitle		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BUTTON + ALPHA_00] call BIS_fnc_HEXtoRGB);
	_settingsResetMode		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BUTTON + ALPHA_00] call BIS_fnc_HEXtoRGB);

	// Show non interactive buttons
	_settingsRespawnImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BUTTON + ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_settingsRespawnTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);

	_settingsReviveImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_BUTTON + ALPHA_100]	call BIS_fnc_HEXtoRGB);
	_settingsReviveTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);

	// Disable buttons
	_settingsResetButton	ctrlShow false;
	_settingsRespawnButton	ctrlShow false;
	_settingsReviveButton	ctrlShow false;

} else // Hosts
{
	// Show reset settings icon and hide text
	_settingsResetImage		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_25] call BIS_fnc_HEXtoRGB);
	_settingsResetTitle		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_25] call BIS_fnc_HEXtoRGB);
	_settingsResetMode		ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_25] call BIS_fnc_HEXtoRGB);

	// Show as interactive
	_settingsRespawnImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);
	_settingsRespawnTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);

	_settingsReviveImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);
	_settingsReviveTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75]	call BIS_fnc_HEXtoRGB);

	// Disable buttons
	_settingsResetButton	ctrlShow true;
	_settingsRespawnButton	ctrlShow true;
	_settingsReviveButton	ctrlShow true;
};

// Commit
_settingsResetImage		ctrlCommit 0;
_settingsResetTitle		ctrlCommit 0;
_settingsResetMode		ctrlCommit 0;

_settingsRespawnImage	ctrlCommit 0;
_settingsRespawnTitle	ctrlCommit 0;
_settingsRespawnMode	ctrlCommit 0;

_settingsReviveImage	ctrlCommit 0;
_settingsReviveTitle	ctrlCommit 0;
_settingsReviveMode		ctrlCommit 0;

_militaryTitle			ctrlCommit 0;
_militaryMode			ctrlCommit 0;

// Update Military Efficiency
[_respawnSetting, _reviveSetting] call BIS_fnc_EXP_camp_lobby_UIMilitaryManager;

// In case local player is not the host
// We store settings locally too, so if this player becomes "host"
// Because the old one left, settings are preserved
if (player != _host) then
{
	profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", _settingsRespawn];
	profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", _settingsRevive];
	saveProfileNamespace;
};