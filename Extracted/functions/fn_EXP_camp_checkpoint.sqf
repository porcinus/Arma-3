/*
	Author: Nelson Duarte

	Description:
		Set's a mission checkpoint, in single-player an auto save happens, in multiplayer a new respawn position is added

	Parameters:
		_target: The target namespace
		_position: The desired position
		_name: The name of the position

	Returns:
		Added respawn position identifier
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
params
[
	["_target", missionNamespace, [missionNamespace, sideUnknown, grpNull, objNull]],
	["_position", "", ["", grpNull, objNull, []]],
	["_name", "", [""]]
];

// Save game in single player
if (!isMultiplayer) then
{
	saveGame;
	[_target, ""];
}
else
{
	[_target, _position, _name] call BIS_fnc_addRespawnPosition;
};