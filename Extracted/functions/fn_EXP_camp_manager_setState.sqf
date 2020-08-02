/*
	Author: Nelson Duarte

	Description:
	Set's the state of the mission

	Parameters:
		_state: The new mission state to set

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
private _state = _this param [0, STATE_WAITING, [STATE_WAITING]];

// Apply new state and replicate it over network
missionNamespace setVariable [VAR_SS_STATE, _state, ISPUBLIC];

// Execute event locally
[_state] call BIS_fnc_exp_camp_manager_triggerEvent;