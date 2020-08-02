/*
	Author: Nelson Duarte

	Description:
	Handles match start synchronization between server and clients

	The following states are valid:
	- Waiting	: State is set when joining the mission
	- Intro		: State is set when mission intro starts
	- Loadout	: State is set when mission loadout selection starts
	- Started	: State is set when mission gameplay starts

	Parameters:
		_introVideos: The videos directory to play, empty array leads to skipping intro videos completely
		_introVideosSubtitles: The subtitles files to execute for intro videos
		_minWaitDelay: The time to wait after waiting has been completed
		_minLoadoutDelay: The time to wait after loadout has been completed
		_maxWaitDelay: The maximum time to wait for all players during the waiting, if reached, mission is forced onto next state
		_maxLoadoutDelay: The maximum time to wait for all players during the loadout, mission is forced onto next state
		_bWantsLoadoutSelection: Whether or not to go into loadout selection, if false this is skipped
		_bNoCinematics: Whether to force no cinematics, these need to be handled manually then

	Returns:
		Nothing
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Validate script schedule
if (!canSuspend) exitWith
{
	if (DEBUG_SHOW_ERRORS) then
	{
		"Unable to execute function on non-scheduled env, please use spawn instead of call!" call BIS_fnc_error;
	};
};

// Parameters
params
[
	["_introVideos", [], [[]]],
	["_introVideosSubtitles", [], [[]]],
	["_minWaitDelay", 2.0, [0.0]],
	["_minLoadoutDelay", 2.0, [0.0]],
	["_maxWaitDelay", 30.0, [0.0]],
	["_maxLoadoutDelay", 300.0, [0.0]],
	["_bWantsLoadoutSelection", true, [true]],
	["_bNoCinematics", false, [false]]
];

// Store global config params
missionNamespace setVariable [VAR_SS_INTRO_VIDEOS, _introVideos];
missionNamespace setVariable [VAR_SS_INTRO_VIDEOS_SUBTITLES, _introVideosSubtitles];
missionNamespace setVariable [VAR_SS_NO_CINEMATICS, _bNoCinematics];

// If we are dealing with a machine which has a player then initalize him
if (hasInterface) then
{
	// Wait for player to become valid
	waitUntil {!isNil {player} && {!isNull player}};

	// So every player will always trigger this no matter what since they might join after waiting has started
	[STATE_WAITING] call BIS_fnc_exp_camp_manager_triggerEvent;

	// Public event handler notify
	VAR_SS_STATE addPublicVariableEventHandler [missionNamespace,
	{
		// The new state
		private _state = missionNamespace getVariable [VAR_SS_STATE, STATE_WAITING];

		// Handle event change by calling corresponding event
		[_state] call BIS_fnc_exp_camp_manager_triggerEvent;
	}];

	// Respawn event handler for deletion of old body
	// Handles only initial respawn, removed after that
	missionNamespace setVariable [VAR_SS_RESPAWN_BODY, player addEventHandler ["Respawn",
	{
		// Params
		params [["_newBody", objNull, [objNull]], ["_oldBody", objNull, [objNull]]];

		// Remove event - this won't work since AIII-49150 - it will "block" another respawn handler and mission will be stuck
		/* if (!isNil {missionNamespace getVariable VAR_SS_RESPAWN_BODY}) then
		{
			_newBody removeEventHandler ["Respawn", missionNamespace getVariable VAR_SS_RESPAWN_BODY];
		}; */
		// Delete old body
		if (!isNull _oldBody) then
		{
			if (isNil "BIS_AIII_49150") then //workaround (AIII-49150)
			{
				BIS_AIII_49150 = true;
				deleteVehicle (_oldBody);
			};
		};
	}]];
};

// Now wait until session begins
waitUntil { sleep 0.1; time > 0 };

// Server only initialization
if (isServer) then
{
	// The current time multiplier
	private _timeMultiplier = timeMultiplier;

	// Set the time multiplier
	// This ensures mission starts at the same time of day
	// Disregarding how long players spent in the synchronization period
	setTimeMultiplier 0.1;

	if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Waiting for players to preload" call BIS_fnc_log};

	// The desired player count from those connected but still loading
	// If single-player we just want one
	private _desiredPlayers = if (isMultiplayer) then {[] call BIS_fnc_listPlayers} else {if (hasInterface) then {[player]} else {[]}};

	// Wait until count matches
	waitUntil
	{
		// Those that join during sync process are also added
		if (isMultiplayer) then {_desiredPlayers = [] call BIS_fnc_listPlayers};

		// The list of players that are still preloading
		private _playersFinishedPreload = missionNamespace getVariable [VAR_SS_PRELOAD_PLAYERS, []];
		private _playersInPreload = _desiredPlayers - _playersFinishedPreload;

		// If max delay is reached start imediately
		// Otherwise wait for players ping
		time >= _maxWaitDelay
		||
		{count _playersInPreload < 1}
	};

	if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Players preloaded, waiting for minimum delay" call BIS_fnc_log};

	// Target delay time
	private _targetDelay = time + _minWaitDelay;

	// Wait for initial delay
	waitUntil {time >= _targetDelay};

	if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Minimum delay finished" call BIS_fnc_log};

	// Start intro if requested
	// Intro is special in that it won't require synchronization
	// A player can skip intro and go directly to loadout
	if (count _introVideos > 0 && {isMultiplayer}) then
	{
		// Set state of mission to intro
		[STATE_INTRO] call BIS_fnc_exp_camp_manager_setState;

		// Some delay
		sleep 1;
	};

	// Start loadout selection if requested and we are in multiplayer
	if (_bWantsLoadoutSelection && {isMultiplayer}) then
	{
		if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Waiting for players to select loadout" call BIS_fnc_log};

		// Set state of mission to loadout selection
		[STATE_LOADOUT] call BIS_fnc_exp_camp_manager_setState;

		// Update desired players
		_desiredPlayers = if (isMultiplayer) then {[] call BIS_fnc_listPlayers} else {if (hasInterface) then {[player]} else {[]}};

		// Target delay time
		_targetDelay = time + _maxLoadoutDelay;

		// Wait until all players finished loadout selection
		waitUntil
		{
			// Those that join during sync process are also added
			if (isMultiplayer) then {_desiredPlayers = [] call BIS_fnc_listPlayers};

			// The list of players that are still in intro
			private _playersFinishedLoadout = missionNamespace getVariable [VAR_SS_LOADOUT_PLAYERS, []];
			private _playersInLoadout = _desiredPlayers - _playersFinishedLoadout;

			// If max delay is reached start imediately
			// Otherwise wait for players ping
			time >= _targetDelay
			||
			{count _playersInLoadout < 1}
		};

		if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Loadout complete, starting loadout minimum delay" call BIS_fnc_log};

		// Force respawn for players which may still be on the loadout menu
		0 remoteExecCall ["setPlayerRespawnTime", TARGET_ALL];

		// Target delay time
		_targetDelay = time + _minLoadoutDelay;

		// Wait for initial delay
		waitUntil {time >= _targetDelay};

		if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Loadout minimum delay complete" call BIS_fnc_log};
	};

	// Start mission
	[STATE_STARTED] call BIS_fnc_exp_camp_manager_setState;

	// Reset the time multiplier to default
	setTimeMultiplier _timeMultiplier;

	if (DEBUG_SHOW_LOGS) then {"Mission Manager::Server: Mission started" call BIS_fnc_log};
};
