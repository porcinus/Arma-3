/*
	Author: Nelson Duarte

	Description:
		Changes AI skill based on player count, responding to player connected / player disconnected events

	Parameters:
		_this select 0: Mode 		- True to enable, false to disable
		_this select 1: Affected Sides 	- The affected sides and their skill sets

	Returns:
		Nothing
*/

// Server only
if (!isServer) exitWith
{
	"Function must be executed only on the server" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
params
[
	["_mode", true, [true]],
	["_affectedSides", [], [[]]]
];

#define AFFECTED_SIDES _affectedSides

// Validate mode, do not allow double initialization
if (_mode && {missionNamespace getVariable ["BIS_exp_camp_dynamicEnemySkill_init", false]}) exitWith
{
	"Already initialized, terminate to be able to initialize again" call BIS_fnc_error;
};

// Validate mode, do not allow terminating while initialization did not occur
if (!_mode && {!(missionNamespace getVariable ["BIS_exp_camp_dynamicEnemySkill_init", false])}) exitWith
{
	"Not initialized, please initialize to be able to terminate" call BIS_fnc_error;
};

// Depending on the mode, enable / disable functionality
if (_mode) then
{
	// Flag as initialized
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_init", true];

	// Calculate skill imediatly
	// Further adjustments are done through PlayerConnected / PlayerDisconnected
	{
		_x call BIS_fnc_exp_camp_setSkill;
	}
	forEach AFFECTED_SIDES;

	// Player connected
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_playerConnected", addMissionEventHandler ["PlayerConnected",
	{
		{
			_x call BIS_fnc_exp_camp_setSkill;
		}
		forEach AFFECTED_SIDES;
	}]];

	// Player disconnected
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_playerDisconnected", addMissionEventHandler ["PlayerDisconnected",
	{
		{
			_x call BIS_fnc_exp_camp_setSkill;
		}
		forEach AFFECTED_SIDES;
	}]];

	// Log
	if (DEBUG_SHOW_LOGS) then
	{
		["Initialized: %1 / %2", _mode, _affectedSides] call BIS_fnc_logFormat;
	};
}
else
{
	// Flag as not initialized
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_init", nil];

	// Clear event handlers
	removeMissionEventHandler ["PlayerConnected", missionNamespace getVariable ["BIS_exp_camp_dynamicEnemySkill_playerConnected", -1]];
	removeMissionEventHandler ["PlayerDisconnected", missionNamespace getVariable ["BIS_exp_camp_dynamicEnemySkill_playerDisconnected", -1]];

	// Clear variables
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_playerConnected", nil];
	missionNamespace setVariable ["BIS_exp_camp_dynamicEnemySkill_playerDisconnected", nil];

	// Log
	if (DEBUG_SHOW_LOGS) then
	{
		"Terminated" call BIS_fnc_log;
	};
};