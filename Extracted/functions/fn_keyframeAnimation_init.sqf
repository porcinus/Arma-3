// Iterate timelines
{
	// Iterate simulated curves
	{
		// Compute curve
		[_x, true] call BIS_fnc_richCurve_compute;
	}
	forEach ([_x] call BIS_fnc_timeline_getSimulatedCurves);
}
forEach (allMissionObjects "Timeline_F");