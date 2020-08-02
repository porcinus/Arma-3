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

// Lobby UI defines
disableSerialization;
#include "\A3\Missions_F_Exp\Lobby\headers\ui_campaignLobbyDefines.inc"

// Grab countdown variable
private _countdown = missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";

// Create one if it doesn't exist
if (isNil { _countdown }) then
{
	missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", 0, true];
};

// Begin countdown
private _startTime = diag_tickTime;

// Run the UI loop everywhere
[1] remoteExec ["BIS_fnc_EXP_camp_lobby_UIMissionCountdown"];

// Grab original host
private _originalHost			= missionNamespace getVariable "A3X_UI_LOBBY_HOST";

waitUntil
{
	// Grab connected players
	private _connectedPlayers 	= missionNamespace getVariable "A3X_UI_LOBBY_PLAYERS";
	private _host				= missionNamespace getVariable "A3X_UI_LOBBY_HOST";
	private _currentTime		= missionNamespace getVariable "A3X_UI_LOBBY_MISSION_COUNTDOWN";
	private _timer				= diag_tickTime - _startTime;

	// Escape if there was a disconnection
	if (isNil { _connectedPlayers }) exitWith { true };

	// Check if the original host left
	if (_originalHost != _host) exitWith { true };

	// Escape if time ends or we pause launch
	if !(isNil { _currentTime }) then
	{
		_currentTime = _timer;
		missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", round _currentTime, true];
	};

	uiSleep 0.25;

	// Check if the original host left
	if (_originalHost != _host) exitWith { true };

	// Escape if there was a disconnection
	if (isNil { _connectedPlayers }) exitWith { true };

	// Run mission if time ends
	if (_timer >= 10) exitWith
	{
		[1, true] remoteExec ["BIS_fnc_EXP_camp_lobby_Go"];
		true
	};

	// Run the game only when all players are ready
	if (({(_x select 1) == 2} count _connectedPlayers) == (count _connectedPlayers)) exitWith
	{
		[1, true] remoteExec ["BIS_fnc_EXP_camp_lobby_Go"];
		true
	};

	// Escape if the timer runs out of if it is shut down
	((_timer >= 10) || (isNil { _currentTime}))
};

missionNamespace setVariable ["A3X_UI_LOBBY_MISSION_COUNTDOWN", nil, true];