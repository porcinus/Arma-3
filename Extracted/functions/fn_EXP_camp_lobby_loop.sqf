/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_loop.sqf

		Campaign Lobby: Update UI Loop

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

private _display		= findDisplay IDD_CAMPAIGN_LOBBY;

if (isNil { _display }) exitWith {};

if (isNull _display) exitWith {};

// Reselect mission (log out fix)

// Selected option
private _selectedMissionOptionCtrls 		= uiNamespace getVariable "A3X_UI_LOBBY_MISSION_OPTION_SELECTED";
private _selectedMissionOptionGroup			= controlNull;
private _selectedMissionOptionLine			= controlNull;
private _selectedMissionOptionText			= controlNull;
private _selectedMissionOptionIcon			= controlNull;
private _selectedMissionOptionButton		= controlNull;

if !(isNil { _selectedMissionOptionCtrls }) then
{
	_selectedMissionOptionGroup			= _selectedMissionOptionCtrls select 0;
	_selectedMissionOptionLine			= _selectedMissionOptionCtrls select 1;
	_selectedMissionOptionText			= _selectedMissionOptionCtrls select 2;
	_selectedMissionOptionIcon			= _selectedMissionOptionCtrls select 3;
	_selectedMissionOptionButton		= _selectedMissionOptionCtrls select 4;
};

// Grab player controls
private _playerCtrlSlots = uiNamespace getVariable "A3X_UI_LOBBY_PLAYER_SLOTS";

// Reset group status
for "_i" from 0 to (count _playerCtrlSlots - 1) do
{
	// Player controls
	private _playerCtrlArray		= _playerCtrlSlots select _i;
	private _playerGroup 			= _playerCtrlArray select 0;
	private _playerNameCtrl			= _playerCtrlArray select 1;
	private _playerHostCtrl			= _playerCtrlArray select 2;
	private _playerStatusCtrl		= _playerCtrlArray select 3;

	// Reset controls
	_playerNameCtrl		ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_PlayerOpenSlot"));
	_playerNameCtrl		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_25] call BIS_fnc_HEXtoRGB);
	_playerNameCtrl		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_50] call BIS_fnc_HEXtoRGB);

	_playerGroup		ctrlShow true;
	_playerHostCtrl		ctrlShow false;
	_playerStatusCtrl	ctrlShow false;
};

// Find players
private _connectedPlayers 			= missionNamespace getVariable "A3X_UI_LOBBY_PLAYERS";

// Populate the player controls
if !(isNil { _connectedPlayers }) then
{
	for "_i" from 0 to (count _connectedPlayers - 1) do
	{
		// Player
		private _player				= _connectedPlayers select _i select 0;
		private _status				= _connectedPlayers select _i select 1;
		private _host				= _connectedPlayers select _i select 2;

		// Player controls
		private _playerCtrlArray 	= _playerCtrlSlots select ((count _playerCtrlSlots - 1) - (count _connectedPlayers - 1) + _i);
		private _playerGroup 		= _playerCtrlArray select 0;
		private _playerNameCtrl		= _playerCtrlArray select 1;
		private _playerHostCtrl		= _playerCtrlArray select 2;
		private _playerStatusCtrl	= _playerCtrlArray select 3;

		// Add player name
		_playerNameCtrl ctrlSetText _player;

		// Grab player squad name
		private _playerName 			= call BIS_fnc_EXP_camp_lobby_getPlayerSquadName;

		// Show host icon
		if (_host) then
		{
			_playerHostCtrl ctrlShow true;
		};

		switch (_status) do
		{
			// Connecting
			case 0:
			{
				_playerNameCtrl		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_YELLOW	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerNameCtrl		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK 	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_YELLOW	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetText 			PICTURE_CAMPAIGN_LOBBY_PLAYER_STATUS_CONNECTING;
				_playerStatusCtrl	ctrlShow				true;
			};

			// Connected
			case 1:
			{
				_playerNameCtrl		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerNameCtrl		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_ORANGE	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetText				PICTURE_CAMPAIGN_LOBBY_PLAYER_STATUS_CONNECTED;
				_playerStatusCtrl	ctrlShow				true;
			};

			// Ready
			case 2:
			{
				_playerNameCtrl		ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerNameCtrl		ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK 	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_GREEN	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
				_playerStatusCtrl	ctrlSetText				PICTURE_CAMPAIGN_LOBBY_PLAYER_STATUS_READY;
				_playerStatusCtrl	ctrlShow				true;
			};
		};

		// Manage current player name colour (overrides status)
		if (_playerName == _player) then
		{
			_playerNameCtrl	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_BLACK 	+ ALPHA_75] call BIS_fnc_HEXtoRGB);
			_playerNameCtrl ctrlSetTextColor 		([CAMPAIGN_LOBBY_COLOR_BLUE 	+ ALPHA_100] call BIS_fnc_HEXtoRGB);
		};
	};
};

// Commit
for "_i" from 0 to (count _playerCtrlSlots - 1) do
{
	// Player controls
	private _playerCtrlArray 	= _playerCtrlSlots select _i;
	private _playerGroup 		= _playerCtrlArray select 0;
	private _playerNameCtrl		= _playerCtrlArray select 1;
	private _playerHostCtrl		= _playerCtrlArray select 2;
	private _playerStatusCtrl	= _playerCtrlArray select 3;

	// Reset controls
	_playerGroup 		ctrlCommit 0;
	_playerNameCtrl 	ctrlCommit 0;
	_playerHostCtrl 	ctrlCommit 0;
	_playerStatusCtrl 	ctrlCommit 0;
};

// Update UI Mission Manager UI (by selecting selected mission again)
[_selectedMissionOptionButton, 3] call BIS_fnc_EXP_camp_lobby_UIMissionManager;

// Get host server settings
call BIS_fnc_EXP_camp_lobby_updateHostSettings;
