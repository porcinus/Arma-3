/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_updatePlayers.sqf

		Campaign Lobby: Updates UI based on player status changes

	Params

		0:

	Return

		0:
*/

if (!hasInterface) exitWith {};

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Campaign Lobby display
private _display							= findDisplay IDD_CAMPAIGN_LOBBY;

// Grab connected players
private _connectedPlayers 					= missionNamespace getVariable ["A3X_UI_LOBBY_PLAYERS", []];

// If there are no players, leave
if (count _connectedPlayers < 1) exitWith {};

// Init connected player specs
private _playerName 	= name player;
private _playerIndex 	= 0;
private _playerStatus 	= 0;
private _playerHost 	= true;

// Check if there's a tag on this player
private _playerSquad	= squadParams player;

// If there is a tag, add it to the end of the name for comparison
if (count _playerSquad > 0) then
{
	private _playerTag = _playerSquad select 0 select 0;
	_playerName = format ["%1 [%2]", _playerName, _playerTag];
};

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

// Grab progress options
private _progressOptionCtrls 			= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTIONS";

// If there are no progress options, leave
if (isNil { _progressOptionCtrls }) exitWith {};

private _progressOptionLogOutText		= _progressOptionCtrls select 0 select 0;
private _progressOptionLogOutButton		= _progressOptionCtrls select 0 select 1;
private _progressOptionApproveText 		= _progressOptionCtrls select 1 select 0;
private _progressOptionApproveButton	= _progressOptionCtrls select 1 select 1;

// Check hover and selected progress controls
private _hoverProgressCtrl				= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTION_HOVER";
private _selectedProgressCtrl			= uiNamespace getVariable "A3X_UI_LOBBY_PROGRESS_OPTION_SELECTED";

if (isNil { _hoverProgressCtrl }) 		then {_hoverProgressCtrl 	= controlNull; };
if (isNil { _selectedProgressCtrl }) 	then {_selectedProgressCtrl = [controlNull, controlNull]; };

// Check whether this is the server
if (_playerHost) then
{
	// Is everyone ready?
	if (({(_x select 1) == 2} count _connectedPlayers) == (count _connectedPlayers)) then
	{
		if (_progressOptionApproveButton == _hoverProgressCtrl) then
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
		} else
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_75] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
		};
	} else
	{
		if (_progressOptionApproveButton == _hoverProgressCtrl) then
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
		} else
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_75] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressApprove"));
		};
	};
} else
{
	// Check if this player is ready
	if (({((_x select 0) == _playerName) && ((_x select 1) == 2)} count _connectedPlayers) > 0) then
	{
		if (_progressOptionApproveButton == _hoverProgressCtrl) then
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_25] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressStandingBy"));
		} else
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_GREEN + ALPHA_75] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressStandingBy"));
		};
	} else
	{
		if (_progressOptionApproveButton == _hoverProgressCtrl) then
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_WHITE + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressReady"));
		} else
		{
			_progressOptionApproveText	ctrlSetBackgroundColor	([CAMPAIGN_LOBBY_COLOR_ORANGE + ALPHA_75] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetTextColor		([CAMPAIGN_LOBBY_COLOR_BLACK + ALPHA_100] call BIS_fnc_HEXtoRGB);
			_progressOptionApproveText	ctrlSetText				(toUpper (localize "STR_A3_RscDisplayCampaignLobby_ProgressReady"));
		};
	};
};

// Commit mission progress
_progressOptionApproveText		ctrlCommit 0;
_progressOptionApproveButton	ctrlCommit 0;

call BIS_fnc_EXP_camp_lobby_loop;