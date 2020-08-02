/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_UIProgressManager.sqf

		Campaign Lobby: Handles Progress button UI behaviour

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Grab params
private _ctrl = _this select 0;
private _case = _this select 1;

// Campaign Lobby display
private _display							= findDisplay IDD_CAMPAIGN_LOBBY;

// Init Briefing Display
private _briefingDisplay					= displayNull;

// Grab briefing display
if !(isNull (findDisplay 52)) then
{
	_briefingDisplay 						= findDisplay 52;
} else
{
	if !(isNull (findDisplay 53)) then
	{
		_briefingDisplay = findDisplay 53;
	};
};

// Current mission
private _currentMission						= uiNamespace getVariable "A3X_UI_LOBBY_MISSION";
private _currentMissionIndex				= _currentMission select 0;
private _currentMissionOptionGroup			= _currentMission select 1;
private _currentMissionOptionLine			= _currentMission select 2;
private _currentMissionOptionText			= _currentMission select 3;
private _currentMissionOptionIcon			= _currentMission select 4;
private _currentMissionOptionButton			= _currentMission select 5;

// Selected option
private _selectedMissionOptionCtrls 		= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTION_SELECTED";
private _selectedMissionOptionGroup			= _selectedMissionOptionCtrls select 0;
private _selectedMissionOptionLine			= _selectedMissionOptionCtrls select 1;
private _selectedMissionOptionText			= _selectedMissionOptionCtrls select 2;
private _selectedMissionOptionIcon			= _selectedMissionOptionCtrls select 3;
private _selectedMissionOptionButton		= _selectedMissionOptionCtrls select 4;

// Briefing buttons
private _briefingButtonGo				= _briefingDisplay displayCtrl 1;
private _briefingButtonBack				= _briefingDisplay displayCtrl 2;

// Mission option array
private _progressOptionCtrls 			= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTIONS";

if (isNil { _progressOptionCtrls }) exitWith {};

// Init controls
private _progressOptionLogOutText		= _progressOptionCtrls select 0 select 0;
private _progressOptionLogOutButton		= _progressOptionCtrls select 0 select 1;
private _progressOptionApproveText		= _progressOptionCtrls select 1 select 0;
private _progressOptionApproveButton	= _progressOptionCtrls select 1 select 1;

// Create some core empty vars
private _progressCtrlBackground			= controlNull;
private _progressCtrlButton				= controlNull;

// Check which set of controls we should use
for "_i" from 0 to (count _progressOptionCtrls - 1) do
{
	_ctrlText 	= _progressOptionCtrls select _i select 0;
	_ctrlButton	= _progressOptionCtrls select _i select 1;

	if (_ctrl == _ctrlButton) then
	{
		_progressCtrlText	= _ctrlText;
		_progressCtrlButton	= _ctrlButton;
	};
};

// Selected option
private _selectedProgressCtrl 			= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTION_SELECTED";

// Hover option
private _hoverProgressCtrl 				= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTION_HOVER";

// Grab connected players
private _connectedPlayers 				= missionNamespace getVariable "A3X_UI_LOBBY_PLAYERS";

// Init connected player specs and grab player squad name
private _playerName 	= call BIS_fnc_EXP_camp_lobby_getPlayerSquadName;
private _playerIndex 	= 0;
private _playerStatus 	= 0;
private _playerHost 	= isServer;

// Find the host
for "_i" from 0 to (count _connectedPlayers - 1) do
{
	private _player = _connectedPlayers select _i select 0;
	private _status = _connectedPlayers select _i select 1;
	private _host 	= _connectedPlayers select _i select 2;

	if (_playerName == _player) then
	{
		_playerIndex	= _i;
		_playerStatus	= _status;
		_playerHost		= _host;
	};
};

// Check whether there is already a countdown
private _countdown	= missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";

// Is the game launching
private _bLaunching				= false;

if !(isNil { _countdown }) then
{
	_bLaunching					= true;
};

// Is Everyone Ready
private _bEveryoneReady			= false;

if (({(_x select 1) == 2} count _connectedPlayers) == (count _connectedPlayers)) then
{
	_bEveryoneReady				= true;
};

switch (_case) do
{
	// Click
	case 0:
	{
		// Update selected button
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_SELECTED", [_progressCtrlBackground, _progressCtrlButton]];

		// Which button is this
		switch (_progressCtrlButton) do
		{
			// Log out
			case _progressOptionLogOutButton:
			{
				// Manage colour
				_progressCtrlText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_progressCtrlText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);

				// Exit the game
				if (isServer) then
				{
					// Everyone quits on a hosted server
					[0, true] remoteExec ["BIS_fnc_EXP_camp_lobby_go"];
				} else
				{
					// Let player quit
					[0, true] call BIS_fnc_EXP_camp_lobby_go;
				};
			};

			// Approve Button
			case _progressOptionApproveButton:
			{
				// Check if this player is ready
				if (({((_x select 0) == _playerName) && ((_x select 1) == 2)} count _connectedPlayers) > 0) then
				{
					// Check client / server
					if (_playerHost) then
					{
						// Is everyone ready?
						if (_bEveryoneReady) then
						{
							// CLICK TO RUN MISSION
							if !(_bLaunching) then
							{
								_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							};
						} else
						{
							if !(_bLaunching) then
							{
								// ASSETS NOT READY - Begin Countdown
								missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", 0, true];
								[0] execVM "\A3\Missions_F_Exp\Lobby\functions\fn_EXP_camp_lobby_missionCountdown.sqf";
							} else
							{
								missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil, true];
							};
						};
					} else
					{
						// CLICK TO UN-READY!
						_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_RED		+ ALPHA_100] call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
					};
				} else
				{
					// Check client / server
					if (_playerHost) then
					{
						// Server is not ready? (Should never happen yet)
						//_progressOptionApproveBackground ctrlSetBackgroundColor (["00FF90FF"] call BIS_fnc_HEXtoRGB);
						//_progressOptionApproveButton ctrlSetTextColor (["FFFFFFFF"] call BIS_fnc_HEXtoRGB);
					} else
					{
						// CLICK TO READY
						_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText		ctrlSetTextColor 		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
					};
				};

				// Manage Behaviour
				if !(_playerHost) then
				{
					for "_i" from 0 to (count _connectedPlayers - 1) do
					{
						private _player = _connectedPlayers select _i select 0;
						private _status = _connectedPlayers select _i select 1;
						private _host 	= _connectedPlayers select _i select 2;

						if (_playerName == _player) then
						{
							if (_status == 1) then
							{
								[_playerName, 2] remoteExec ["BIS_fnc_EXP_camp_lobby_updatePlayerStatus", 2];
							} else
							{
								[_playerName, 1] remoteExec ["BIS_fnc_EXP_camp_lobby_updatePlayerStatus", 2];
							};
						};
					};
				} else
				{
					if (_bEveryoneReady) then
					{
						// Run the game only when all players are ready
						[1, true] remoteExec ["BIS_fnc_EXP_camp_lobby_Go"];
					};
				};
			};
		};
	};

	// Enter
	case 1:
	{
		// Update selected button
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_HOVER", _ctrl];

		// Which button is this
		switch (_progressCtrlButton) do
		{
			// Log out
			case _progressOptionLogOutButton:
			{
				_progressOptionLogOutText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_100] call BIS_fnc_HEXTORGB);
				_progressOptionLogOutText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXTORGB);
			};

			// Approve Button
			case _progressOptionApproveButton:
			{
				if (_bLaunching) then
				{
					// Is everyone ready?
					if (_bEveryoneReady) then
					{
						_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50]		call BIS_fnc_HEXtoRGB);
					} else
					{
						_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_50]		call BIS_fnc_HEXtoRGB);
					};
				} else
				{
					// Check if this player is ready
					if (({((_x select 0) == _playerName) && ((_x select 1) == 2)} count _connectedPlayers) > 0) then
					{
						// Check client / server
						if (_playerHost) then
						{
							// Is everyone ready?
							if (({(_x select 1) == 2} count _connectedPlayers) == (count _connectedPlayers)) then
							{
								// Server approve mission green
								_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							} else
							{
								// Server approve mission orange
								_progressOptionApproveText	ctrlSetBackgroundColor 	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetTextColor 		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							};
						} else
						{
							// Client is ready
							_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
						};
					} else
					{
						// Check client / server
						if (_playerHost) then
						{
							// Server is not ready? (Should never happen yet)
							//_progressOptionApproveBackground ctrlSetBackgroundColor (["00FF90FF"] call BIS_fnc_HEXtoRGB);
							//_progressOptionApproveButton ctrlSetTextColor (["FFFFFFFF"] call BIS_fnc_HEXtoRGB);
						} else
						{
							// Client is not ready
							_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
						};
					};
				};
			};
		};
	};

	// Exit
	case 2:
	{
		// Update selected button
		uiNamespace setVariable ["A3X_UI_LOBBY_PROGRESS_OPTION_HOVER", nil];

		// Which button is this
		switch (_progressCtrlButton) do
		{
			// Log out
			case _progressOptionLogOutButton:
			{
				_progressOptionLogOutText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_WHITE	+ ALPHA_75] call BIS_fnc_HEXTORGB);
				_progressOptionLogOutText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_75] call BIS_fnc_HEXTORGB);
			};

			// Approve Button
			case _progressOptionApproveButton:
			{
				// If the game is launching
				if (_bLaunching) then
				{
					// Is everyone ready?
					if (_bEveryoneReady) then
					{
						_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75]		call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
					} else
					{
						_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75]		call BIS_fnc_HEXtoRGB);
						_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100]	call BIS_fnc_HEXtoRGB);
					};
				} else
				{
					// Check if this player is ready
					if (({((_x select 0) == _playerName) && ((_x select 1) == 2)} count _connectedPlayers) > 0) then
					{
						// Check client / server
						if (_playerHost) then
						{
							// Is everyone ready?
							if (_bEveryoneReady) then
							{
								// Server approve mission green
								_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
							} else
							{
								// Server approve mission orange
								_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
								_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
							};
						} else
						{
							// Client is ready
							_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_25] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressStandingBy"));
						};
					} else
					{
						// Check client / server
						if (_playerHost) then
						{
							// Server is not ready? (Should never happen yet)
							//_progressOptionApproveBackground ctrlSetBackgroundColor (["00FF90FF"] call BIS_fnc_HEXtoRGB);
							//_progressOptionApproveButton ctrlSetTextColor (["FFFFFFFF"] call BIS_fnc_HEXtoRGB);
							//_progressOptionApproveButton ctrlSetText "APPROVE MISSION";
						} else
						{
							// Client is not ready
							_progressOptionApproveText		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
							_progressOptionApproveText		ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressReady"));
						};
					};
				};
			};
		};
	};
};

// If this is the approve button then do something magical
if (_progressCtrlButton == _progressOptionApproveButton) then
{
	// Update the Mission UI
	[_currentMissionOptionButton, _case] call BIS_fnc_EXP_camp_lobby_UIMissionManager;
};

// Commit all controls
_progressCtrlText	ctrlCommit 0;
_progressCtrlButton	ctrlCommit 0;