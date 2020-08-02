/*
	Author: Nelson Duarte

	Description:
	Get's the mission state as an integer

	Parameters:
		Nothing

	Returns:
		The mission state integer
*/

// Common defines
#include "\A3\Missions_F_Exp\Campaign\commonDefines.inc"

// Return state of mission as integer
switch (missionNamespace getVariable [VAR_SS_STATE, STATE_WAITING]) do
{
	case STATE_WAITING : 	{0};
	case STATE_INTRO : 		{1};
	case STATE_LOADOUT : 	{2};
	case STATE_STARTED : 	{3};
	default 				{-1};
};