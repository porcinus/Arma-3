/*
	Author: Nelson Duarte

	Description:
	Triggers corresponding event for given mission state

	Parameters:
		_state: The mission state

	Returns:
		Nothing
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Parameters
private _state = _this param [0, STATE_WAITING, [STATE_WAITING]];

// Trigger event
private _eventType = switch (_state) do
{
	case STATE_WAITING : 		{EVENT_WAITING};
	case STATE_INTRO : 		{EVENT_INTRO};
	case STATE_LOADOUT : 		{EVENT_LOADOUT};
	case STATE_STARTED : 		{EVENT_STARTED};
	default 			{""};
};

// Trigger event
if (_eventType != "") then
{
	[missionNamespace, _eventType] call BIS_fnc_callScriptedEventHandler;
}
else
{
	if (DEBUG_SHOW_ERRORS) then
	{
		["Invalid state provided: %1", _state] call BIS_fnc_error;
	};
};