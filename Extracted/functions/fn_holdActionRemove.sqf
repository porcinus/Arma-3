#include "defines.inc"
/*
	Author: Jiri Wainar

	Description:
	Removes a hold action. If the removed hold actions was the last one, disable the scripted  framework.

	Parameters:
	X: OBJECT - object action is attached to
	X: NUMBER - action ID

	Example:
	[_target,_actionID] call bis_fnc_holdActionRemove;

	Returns:
	Nothing.
*/

params
[
	["_target",objNull,[objNull]],
	["_actionID",-1,[123]]
];

_target removeAction _actionID;