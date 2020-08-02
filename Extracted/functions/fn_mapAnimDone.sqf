/*
	Author:
	Nelson Duarte

	Description:
	Same as mapAnimAdd but with possibility for non linear zoom and position interpolation modes

	Parameters:
	Nothing

	Returns:
	Bool - False if map animation is in progress, true if not

	Examples:
	[] call BIS_fnc_mapAnimDone;
*/

!(missionNamespace getVariable ["BIS_mapAnimation_isPlaying", false]);