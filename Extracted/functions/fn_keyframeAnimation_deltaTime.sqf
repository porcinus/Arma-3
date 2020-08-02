#include "\a3\functions_f\debug.inc"

// Pre-init event
// Register each frame before all others
addMissionEventHandler ["EachFrame",
{
	PROFILING_START("BIS_fnc_keyframeAnimation_deltaTime");

	// Compute deltaT
	missionNamespace setVariable ["BIS_deltaTime", ["DeltaTime"] call BIS_fnc_deltaTime];

	PROFILING_STOP("BIS_fnc_keyframeAnimation_deltaTime");
}];

// Log it
"DeltaTime computation started" call BIS_fnc_log;