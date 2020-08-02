// Make sure we are running only on the server machine
if (!isServer) exitWith
{
	"Function must be called on the server only" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
params [["_group", grpNull, [grpNull]], ["_unit", objNull, [objNull]]];

// Validate group
if (isNull _group) then
{
	"Provided _group is NULL" call BIS_fnc_error;
};

// Validate group
if (isNull _unit) then
{
	"Provided _unit is NULL" call BIS_fnc_error;
};

// Make sure group has any units that could call for help
if ({alive _x} count units _group < 1) exitWith
{
	["Group (%1) cannot call for help since it does not have any units left!", _group] call BIS_fnc_logFormat;
};

// Make sure group did not call for help yet
if (_group getVariable ["BIS_coop_campaign_m07_groupNeedsHelp", false]) exitWith
{
	// Log
	["Group (%1) cannot call for help multiple times!", _group] call BIS_fnc_logFormat;
};

// Flag
_group setVariable ["BIS_coop_campaign_m07_groupNeedsHelp", true];

// Call for help
[_group, getPosASL _unit] call BIS_fnc_onGroupNeedsHelp;