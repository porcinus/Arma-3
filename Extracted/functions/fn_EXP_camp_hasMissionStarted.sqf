/*
	Author: Nelson Duarte

	Description:
	Returns whether the mission has actually started (see Manager)

	Parameters:
		Nothing

	Returns:
		True if mission was started, false if not
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

[] call BIS_fnc_exp_camp_manager_getState == STATE_STARTED;