// Make sure we are running only on the server machine
if (!isServer) exitWith
{
	"Function must be called on the server only" call BIS_fnc_error;
};

// Campaign common includes
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Defines
#define MIN_NR_UNITS 2
#define MAX_DIST	 250

// Parameters
params [["_group", grpNull, [grpNull]], ["_position", [0,0,0], [[]]]];

// Validate group
if (isNull _group) exitWith
{
	"Provided _group is NULL" call BIS_fnc_error;
};

// Validate position
if (count _position != 3 || {_position isEqualTo [0,0,0]}) exitWith
{
	["Provided _position (%1) is INVALID", _position] call BIS_fnc_error;
};

// The support group
private _supportGroup = grpNull;

// Go through all groups of same side and find one which can give help
{
	if (side _x == side _group && {{alive _x && {_x distance _position <= MAX_DIST}} count units _x >= MIN_NR_UNITS}) exitWith
	{
		_supportGroup = _x;
	};
}
forEach allGroups;

// Did we found a helper group?
if (!isNull _supportGroup) then
{


	// Log
	["%1 asked for help at %2 and %3 responded to the call", _group, _position, _supportGroup] call BIS_fnc_logFormat;
};