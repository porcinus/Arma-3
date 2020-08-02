/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_missionCountdown.sqf

		Campaign Lobby: Countdown to run mission

	Params

		0:

	Return

		0:
*/

_nul = [] spawn
{
	// Lobby UI defines
	disableSerialization;
	#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

	// Grab display controls
	private _display						= findDisplay IDD_CAMPAIGN_LOBBY;
	private _host							= missionNamespace getVariable "A3X_UI_LOBBY_HOST";
	private _bIsHost						= false;

	// If there is no host - then exit and update
	if (isNil { _host }) exitWith { true };

	// Check host
	if (_host == player) then
	{
		_bIsHost = true;
	};

	// Mission option array
	private _progressOptionCtrls 			= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTIONS";

	if (isNil { _progressOptionCtrls }) exitWith {};

	// Grab approve button control
	private _progressOptionApproveText		= _progressOptionCtrls select 1 select 0;
	private _progressOptionApproveButton	= _progressOptionCtrls select 1 select 1;

	// Now check if the mission countdown is legit
	private _bMissionCountdown				= missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";

	// If the mission countdown has begun
	if !(isNil { _bMissionCountdown }) then
	{
		// Exit check
		private _exit						= false;

		// Begin the countdown UI update
		waitUntil
		{
			// Check host
			private _currentHost			= missionNamespace getVariable "A3X_UI_LOBBY_HOST";

			// If nil host then exit
			if (isNil { _currentHost }) then { _exit = true };

			// Rage quit if the host changed
			if !(isNil { _currentHost }) then
			{
				if (_currentHost != _host) then
				{
					_exit = true;
				};
			};

			// Exit if necessary
			if (_exit) exitWith
			{
				missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil]; // Manage locally
			};

			// Set the time
			_countdown	= missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";

			// Escape if the time is no longer legit
			if (isNil { _countdown }) exitWith { true };

			// Update progress approve text
			_progressOptionApproveText ctrlSetText (format ["%1: %2", toUpper (localize "STR_A3_RscDisplayCampaignLobby_MissionLaunching"), 10 - _countdown]);
			_progressOptionApproveText ctrlCommit 0;

			uiSleep 0.1;

			((_countdown >= 10) || (isNil { _countdown }) || (isNull _display) || (time > 0))
		};


		// If host change approve string as necessary
		if (_bIsHost) then
		{
			_progressOptionApproveText ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
		} else
		{
			_progressOptionApproveText ctrlSetText (toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressReady"));
		};

		_progressOptionApproveText ctrlCommit 0;

		//_currentMissionOptionLine	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE		+ ALPHA_100] call BIS_fnc_HEXtoRGB);
		//_currentMissionOptionText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE		+ ALPHA_100] call BIS_fnc_HEXtoRGB);
	};
};