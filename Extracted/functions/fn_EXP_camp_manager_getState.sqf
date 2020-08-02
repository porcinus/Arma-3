/*
	Author: Nelson Duarte

	Description:
	Get's the mission state, can be one of "Waiting", "Intro", "Loadout" or "Started"

	Parameters:
		Nothing

	Returns:
		The mission state
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Return state of mission
missionNamespace getVariable [VAR_SS_STATE, STATE_WAITING];