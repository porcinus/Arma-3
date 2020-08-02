/*

	PROJECT: R&D
	AUTHOR:  Endstar
	DATE:    15-08-2016

	fn_EXP_camp_lobby_UIMilitaryManager.sqf

		Campaign Lobby: Updates military efficiency based on mission settings

	Params

		0:

	Return

		0:
*/

// Init settings
private _respawnSetting = _this select 0;
private _reviveSetting	= _this select 1;

// Init values
private _respawnValue	= 0;
private _reviveValue	= 0;

// Find Respawn Values
switch (_respawnSetting) do
{
	case 0: { _respawnValue = 0;  };
	case 1: { _respawnValue = 25; };
	case 2: { _respawnValue = 50; };
};

// Find Revive Values
switch (_reviveSetting) do
{
	case 0: { _reviveValue	= 0;  };
	case 1: { _reviveValue	= 25; };
	case 2: { _reviveValue	= 50; };
	case 3: { _reviveValue	= 50; };
};

// Consolidate values
private _final = (_respawnValue + _reviveValue) / 100;

// Update end value
uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_FINAL", _final];

// Check if the loop is already running
private _bInLoop = uiNamespace getVariable "A3X_UI_LOBBY_MILITARY_STATUS";

// If it is running - quit
if !(isNil { _bInLoop }) exitWith {};

// Set as looping
uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS", true];

// The script
private _script = missionNamespace getVariable ["A3X_UI_LOBBY_MILITARY_STATUS_SCRIPT", scriptNull];

// Stop current script if active
if (!isNull _script) then
{
	terminate _script;
	missionNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS_SCRIPT", scriptNull];
};

// Spawned loop
_script = [] spawn
{
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

	// Find current and final values
	private _current	= uiNamespace getVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", 0.0];
	private _final		= uiNamespace getVariable ["A3X_UI_LOBBY_MILITARY_FINAL", 0.0];

	// Total load time
	private _loadTime	= 1.5;

	// Check current load
	if (isNil { _current }) then
	{
		// Set to 0
		_current = 0;

		// Update
		uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", _current];
	};

	// Grab initial time
	private _startTime	= diag_tickTime;

	// Find end time
	private _init		= _current;
	private _range		= abs (_final - _current);
	private _delay		= _loadTime * _range;
	private _endTime	= _startTime + _delay;

	// If there is a range to move between
	if (_range > 0) then
	{
		// Main loop
		waitUntil
		{
			// Re-init
			private _checkFinal		= uiNamespace getVariable ["A3X_UI_LOBBY_MILITARY_FINAL", 0.0];

			if (isNil { _checkFinal }) exitWith { true };

			// If the final position changed, update ranges and times
			if (_checkFinal != _final) then
			{
				_init				= _current;
				_final				= _checkFinal;
				_startTime			= diag_tickTime;
				_range				= abs (_final - _current);
				_delay				= _loadTime * _range;
				_endTime			= _startTime + _delay;
			};

			// Delta time
			private _currentTime 	= diag_tickTime - _startTime;
			private _deltaTime		= if (_currentTime > 0.0 && {_delay != 0.0}) then {_currentTime / _delay} else {0.0};

			// Update value
			private _updateValue	= _init + (_range * _deltaTime);

			// If we are going backwards, subtract the update
			if (_init > _final) then
			{
				_updateValue		= _init - (_range * _deltaTime);
			};

			// Update current value
			_current				= _updateValue;

			// Run update
			[_updateValue] call BIS_fnc_EXP_camp_lobby_updateMilitaryEfficiency;

			// Update vars
			uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", _current];

			(
		 		(diag_tickTime >= _endTime) ||
				(isNull _briefingDisplay) ||
				(isNull _display) ||
				(time > 0) ||
				!(isMultiplayer)
			)
		};
	};

	// Run update
	[_final] call BIS_fnc_EXP_camp_lobby_updateMilitaryEfficiency;

	// Update vars
	uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_CURRENT", _final];
	uiNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS", nil];
};

// Store the script handler, so in case we run this file again and script is still running we can terminate it
missionNamespace setVariable ["A3X_UI_LOBBY_MILITARY_STATUS_SCRIPT", _script];