/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    08-08-2016

	fn_EXP_camp_lobby_UISettingsManager.sqf

		Campaign Lobby: Handles the mission settings for Respawn and Revive

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Grab params
private _ctrl					= _this select 0;
private _case					= _this select 1;

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

// Settings Respawn Controls
private _settingsReviveGroup	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP);
private _settingsReviveImage	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 1);
private _settingsReviveTitle	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 2);
private _settingsReviveMode		= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 3);
private _settingsReviveButton	= _display displayCtrl (IDC_CAMPAIGN_LOBBY_TABLET_BUTTON_REVIVE_GROUP + 4);

// Grab the variables
private _settingsRespawn	= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_RESPAWN";
private _settingsRevive		= missionNamespace getVariable "A3X_UI_LOBBY_SETTINGS_REVIVE";

// Grab host
private _host				= missionNamespace getVariable "A3X_UI_LOBBY_HOST";

// We only let hosts adjust the controls
if (player != _host) exitWith {};

// Flash control
private _fn_flashControl =
{
	// Spawn
	private _nul = _this spawn
	{
		// Normal init
		disableSerialization;
		#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

		// Init params
		private _ctrl	= _this select 0;
		private _color1 = _this select 1;
		private _color2 = _this select 2;
		private _bText	= _this select 3;
		private _delay	= _this select 4;

		// Check if text or background
		if (_bText) then
		{
			// First color
			_ctrl ctrlSetTextColor _color1;
			_ctrl ctrlCommit 0;

			uiSleep _delay;

			// Second color
			_ctrl ctrlSetTextColor _color2;
			_ctrl ctrlCommit 0;
		} else
		{
			// First color
			_ctrl ctrlSetBackgroundColor _color1;
			_ctrl ctrlCommit 0;

			uiSleep _delay;

			// Second color
			_ctrl ctrlSetBackgroundColor _color2;
			_ctrl ctrlCommit 0;
		};
	};
};

// Check control
switch (_ctrl) do
{
	// Search button
	case _settingsSearchButton:
	{
		// Check input type
		switch (_case) do
		{
			// Click
			case 0:
			{
				// Do nothing
			};

			// Enter
			case 1:
			{
				// Do nothing
			};

			// Exit
			case 2:
			{
				// Do nothing
			};
		};
	};

	// Reset button
	case _settingsResetButton:
	{
		switch (_case) do
		{
			// Click
			case 0:
			{
				// Button Flash Red
				[
					_settingsResetImage,
					[CAMPAIGN_LOBBY_COLOR_RED + ALPHA_100] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Title Flash Red
				[
					_settingsResetTitle,
					[CAMPAIGN_LOBBY_COLOR_RED + ALPHA_100] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Mode Flash Red
				[
					_settingsResetMode,
					[CAMPAIGN_LOBBY_COLOR_RED + ALPHA_100] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Reset settings
				[true, true] remoteExec ["BIS_fnc_EXP_camp_lobby_getHostSettings"];
			};

			// Enter
			case 1:
			{
				// Orange
				_settingsResetImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_settingsResetTitle ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_settingsResetMode	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);

				_settingsResetImage	ctrlCommit 0;
				_settingsResetTitle	ctrlCommit 0;
				_settingsResetMode	ctrlCommit 0;
			};

			// Exit
			case 2:
			{
				// Normal
				_settingsResetImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXtoRGB);
				_settingsResetTitle ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXtoRGB);
				_settingsResetMode	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_25] call BIS_fnc_HEXtoRGB);

				_settingsResetImage	ctrlCommit 0;
				_settingsResetTitle	ctrlCommit 0;
				_settingsResetMode	ctrlCommit 0;
			};
		};
	};

	// Respawn button
	case _settingsRespawnButton:
	{
		switch (_case) do
		{
			// Click
			case 0:
			{
				// Flash White Image
				[
					_settingsRespawnImage,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Flash White Title
				[
					_settingsRespawnTitle,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Check if settings respawn is available
				if !(isNil { _settingsRespawn }) then
				{
					// Go through respawn settings
					for "_i" from 0 to (count _settingsRespawn - 1) do
					{
						// Init params
						private _mode		= _settingsRespawn select _i select 0;
						private _setting	= _settingsRespawn select _i select 1;
						private _bEnabled	= _settingsRespawn select _i select 2;

						// Check which is enabled
						if (_bEnabled) exitWith
						{
							(_settingsRespawn select _i) set [2, false];			// Turn off the old

							if (_i == (count _settingsRespawn - 1)) then
							{
								(_settingsRespawn select 0) set [2,true];			// Turn on the new (first option)
							} else
							{
								(_settingsRespawn select (_i + 1)) set [2,true];	// Turn on the new (next option)
							};
						};
					} foreach _settingsRespawn;

					// Update mission namespace variable
					missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", _settingsRespawn, true];

					remoteExec ["BIS_fnc_EXP_camp_lobby_updateHostSettings"];

					// Save to profile namespace
					profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_RESPAWN", _settingsRespawn];
					saveprofileNamespace;
				};
			};

			// Enter
			case 1:
			{
				// White
				_settingsRespawnImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_settingsRespawnTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);

				_settingsRespawnImage	ctrlCommit 0;
				_settingsRespawnTitle	ctrlCommit 0;
			};

			// Exit
			case 2:
			{
				// Normal
				_settingsRespawnImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
				_settingsRespawnTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75]  call BIS_fnc_HEXtoRGB);

				_settingsRespawnImage	ctrlCommit 0;
				_settingsRespawnTitle	ctrlCommit 0;
			};
		};
	};

	// Revive button
	case _settingsReviveButton:
	{
		switch (_case) do
		{
			// Click
			case 0:
			{
				// Flash White Image
				[
					_settingsReviveImage,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Flash White Title
				[
					_settingsReviveTitle,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_75] call BIS_fnc_HEXtoRGB,
					[CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB,
					true,
					0.05
				] call _fn_flashControl;

				// Check if settings respawn is available
				if !(isNil { _settingsRevive }) then
				{
					// Go through respawn settings
					for "_i" from 0 to (count _settingsRevive - 1) do
					{
						// Init params
						private _mode		= _settingsRevive select _i select 0;
						private _setting	= _settingsRevive select _i select 1;
						private _bEnabled	= _settingsRevive select _i select 2;

						// Check which is enabled
						if (_bEnabled) exitWith
						{
							(_settingsRevive select _i) set [2, false];			// Turn off the old

							if (_i == (count _settingsRevive - 1)) then
							{
								(_settingsRevive select 0) set [2,true];		// Turn on the new (first option)
							} else
							{
								(_settingsRevive select (_i + 1)) set [2,true];	// Turn on the new (next option)
							};
						};
					} foreach _settingsRevive;

					// Update mission namespace variable
					missionNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", _settingsRevive, true];

					remoteExec ["BIS_fnc_EXP_camp_lobby_updateHostSettings"];

					// Save to profile namespace
					profileNamespace setVariable ["A3X_UI_LOBBY_SETTINGS_REVIVE", _settingsRevive];
					saveprofileNamespace;
				};
			};

			// Enter
			case 1:
			{
				// White
				_settingsReviveImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_settingsReviveTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);

				_settingsReviveImage	ctrlCommit 0;
				_settingsReviveTitle	ctrlCommit 0;
			};

			// Exit
			case 2:
			{
				// Normal
				_settingsReviveImage	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
				_settingsReviveTitle	ctrlSetTextColor ([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXtoRGB);

				_settingsReviveImage	ctrlCommit 0;
				_settingsReviveTitle	ctrlCommit 0;
			};
		};
	};
};