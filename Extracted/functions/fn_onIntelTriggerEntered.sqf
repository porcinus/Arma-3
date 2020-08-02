// Make sure we are running only on the server machine
if (!isServer) exitWith
{
	"Function must be called on the server only" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
params
[
	["_trigger", objNull, [objNull]],
	["_intel", objNull, [objNull]],
	["_boss", objNull, [objNull]]
];

// Validate trigger
if (isNull _trigger) exitWith
{
	"_trigger is NULL" call BIS_fnc_error;
};

// Validate intel
if (isNull _intel) exitWith
{
	"_intel is NULL" call BIS_fnc_error;
};

// Validate boss
if (isNull _boss) exitWith
{
	"_boss is NULL" call BIS_fnc_error;
};

// Log
["Trigger (%1) entered for intel (%2)", _trigger, _intel] call BIS_fnc_logFormat;

// Delete trigger since we don't need it any more
deleteVehicle _trigger;

// Add respawn position
if (count (_intel getVariable ["BIS_intelRespawnPosition", []]) < 1 && {!BIS_atDevice}) then
{
	// Defense hasn't started yet
	private _pos = [0.0, 0.0, 0.0];
	private _name = "";

	switch (_intel) do
	{
		// Lisbon
		case BIS_intel_1:
		{
			_pos = "BIS_respawn1";
			_name = localize "STR_A3_Exp_m07_respawnLisbon";
		};

		// Madrid
		case BIS_intel_2:
		{
			_pos = "BIS_respawn2";
			_name = localize "STR_A3_Exp_m07_respawnMadrid";
		};

		// Paris
		case BIS_intel_3:
		{
			_pos = "BIS_respawn3";
			_name = localize "STR_A3_Exp_m07_respawnParis";
		};
	};

	// Add and store respawn
	if (_name != "" && {!(_pos isEqualTo [0.0, 0.0, 0.0])}) then
	{
		private _respawn = [WEST, _pos, _name] call BIS_fnc_addRespawnPosition;
		BIS_respawnsApproach = BIS_respawnsApproach + [_respawn];
		_intel setVariable ["BIS_intelRespawnPosition", _respawn];
		["New respawn position added (%1 / %2 / %3)", _pos, _name, _respawn] call BIS_fnc_logFormat;
	};
};

// Check whether this is the boss intel location
if (_intel != [_boss] call BIS_fnc_getBossIntel && {!(missionNamespace getVariable ["BIS_bossWasKilled", false])}) then
{
	// Task state
	[vehicleVarName _intel, "Succeeded", true] call BIS_fnc_taskSetState;

	// Add Tickets
	1 call BIS_fnc_EXP_camp_addTickets;

	// Conversation
	["x00_BossNotHere"] spawn BIS_fnc_missionConversations;

	// Log
	["%1 / %2 / %3", vehicleVarName _intel, "Succeeded", true] call BIS_fnc_logFormat;
};