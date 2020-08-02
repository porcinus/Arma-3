/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    18-04-2016

	fn_EXP_camp_lobby_serverUpdate.sqf

		Campaign Lobby: Server update function (runs on "host" machine for dedicated servers)

	Params

		0:

	Return

		0:
*/

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// This is always run on the host machine
private _host = player;

// Grab player squad name
private _hostName = call BIS_fnc_EXP_camp_lobby_getPlayerSquadName;

// Manage host variable
private _briefingDisplay = displayNull;

// Briefing Display
if (isServer) then
{
	_briefingDisplay = findDisplay 52;
} else
{
	_briefingDisplay = findDisplay 53;
};

private _briefingDiary						= _briefingDisplay displayCtrl 1001;
private _briefingPlayerList					= _briefingDisplay displayCtrl 1002;

// Campaign Lobby display
private _display							= findDisplay IDD_CAMPAIGN_LOBBY;

// Exit if there is no briefing display
if ((isNull _briefingDisplay) || (isNull _display)) exitWith {};

// Select the correct listbox in the briefing display
private _selectDiaryIndex = 3;

if (_briefingDiary lbText _selectDiaryIndex == (localize "STR_A3_cfgdiary_fixedpages_units")) then
{
	_selectDiaryIndex = 4;
};

_briefingDiary lbSetCurSel _selectDiaryIndex;

// Grab connected players
private _briefingPlayers 				= [];
private _connectedPlayers				= missionNamespace getVariable ["A3X_UI_LOBBY_PLAYERS", []];

// Find current players
/*for "_i" from 0 to 10 do
{
	private _player = _briefingPlayerList lbText _i;
	private _image 	= _briefingPlayerList lbPicture _i;
	private _status = -1;
	private _isHost = (_player == _hostName);

	private _connectingIcon	= "a3\ui_f\data\map\diary\icons\playerconnecting_ca.paa";
	private _connectedIcon	= "a3\ui_f\data\map\diary\icons\playerbriefwest_ca.paa";
	private _readyIcon		= "a3\ui_f\data\map\diary\icons\playerwest_ca.paa";

	if (_player == "") exitWith {};

	if (_isHost) then
	{
		_status = 2;
	} else
	{
		if (_image == _connectingIcon) then
		{
			_status = 0;
		} else
		{
			_status = 1;
		};
	};

	_briefingPlayers pushBack [_player, _status, _isHost];
};*/

{
	private _playerName = name _x;
	private _status = -1;
	private _isHost = local _x;

	private _playerSquad	= squadParams _x;

	if (count _playerSquad > 0) then
	{
		private _playerTag = _playerSquad select 0 select 0;
		_playerName = format ["%1 [%2]", _playerName, _playerTag];
	};

	if (_isHost) then
	{
		_status = 2;
	}
	else
	{
		_status = 1;
	};

	_briefingPlayers pushBack [_playerName, _status, _isHost];
}
forEach ([] call BIS_fnc_listPlayers);

// Manual flags
private _update = false;

// Check if there is an active connected player list
if (count _connectedPlayers > 0) then
{
	// Now compare the briefing players to the connected players
	for "_i" from 0 to (count _briefingPlayers - 1) do
	{
		// Grab briefing details
		private _briefingPlayerName		= _briefingPlayers select _i select 0;
		private _briefingPlayerStatus	= _briefingPlayers select _i select 1;
		private _briefingPlayerIsHost	= _briefingPlayers select _i select 2;

		// Init connected player status
		private _connectedPlayerName	= _connectedPlayers select _i select 0;
		private _connectedPlayerStatus	= _connectedPlayers select _i select 1;
		private _connectedPlayerIsHost	= _connectedPlayers select _i select 2;

		// Check if this is a new name (nil)
		switch (isNil { _connectedPlayerName }) do
		{
			// Add new player
			case true:
			{
				_connectedPlayerName	= _briefingPlayerName;
				_connectedPlayerStatus	= _briefingPlayerStatus;
				_connectedPlayerIsHost	= _briefingPlayerIsHost;

				_update = true;
			};

			// Not a new player - update rest
			case false:
			{
				// Update to briefing player name
				if (_briefingPlayerName != _connectedPlayerName) then
				{
					_connectedPlayerName = _briefingPlayerName;
					_update = true;
				};

				// We only care if connected status is 0
				if ((_connectedPlayerStatus == 0) || (_briefingPlayerStatus == 0)) then
				{
					// Has there been a change
					if (_briefingPlayerStatus != _connectedPlayerStatus) then
					{
						_connectedPlayerStatus = _briefingPlayerStatus;
						_update = true;
					};
				};

				// Check host
				if (str _briefingPlayerIsHost != str _connectedPlayerIsHost) then
				{
					if (_briefingPlayerIsHost) then
					{
						_connectedPlayerIsHost = true;
					} else
					{
						_connectedPlayerIsHost = false;
					};

					_update = true;
				};
			};
		};

		// Update connected players array
		if (_update) then
		{
			_connectedPlayers set [_i,[_connectedPlayerName, _connectedPlayerStatus, _connectedPlayerIsHost]];
		};
	};

	// If there still a count discrepancy - fix it with the updated values
	if (count _briefingPlayers != count _connectedPlayers) then
	{
		private _tempConnectedPlayers = [];

		for "_i" from 0 to (count _briefingPlayers - 1) do
		{
			_tempConnectedPlayers pushBack (_connectedPlayers select _i);
		};

		_connectedPlayers = _tempConnectedPlayers;
		_update = true;
	};
} else
{
	_connectedPlayers = _briefingPlayers;
	_update = true;
};

// Update and broadcast
if (_update) then
{
	missionNamespace setVariable ["A3X_UI_LOBBY_PLAYERS", _connectedPlayers, true];
	remoteExec ["BIS_fnc_EXP_camp_lobby_updatePlayers"];
};