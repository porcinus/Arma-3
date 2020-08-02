/*
	Author: Nelson Duarte

	Description:
	A player is registered for given state

	Parameters:
		_who: The player to be registered
		_listId: The state corresponding list, and where given player will be added to

	Returns:
		Nothing
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Server only
if (!isServer) exitWith
{
	if (DEBUG_SHOW_ERRORS) then
	{
		"Function must be called only on the server!" call BIS_fnc_error;
	};
};

// Parameters
params [["_who", objNull, [objNull]], ["_listId", "", [""]]];

// The current list
private _list = missionNamespace getVariable [_listId, []];

// Register
if (!isNull _who) then
{
	_list pushBackUnique _who;
	missionNamespace setVariable [_listId, _list];
};