/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN 3D drawing

	Parameter(s):
	_this select 0: Object - The curve

	Returns:
	Nothing
*/

// Parameters
params [["_curve", objNull, [objNull]], ["_deltaTime", 0.0, [0.0]]];

// 3DEN
if (!is3DEN || {isNull _curve}) exitWith {};

// Calculate number of segments from curve length
private _segments = 50 max (ceil ([_curve] call BIS_fnc_richCurve_getCurveLength) * (_curve getVariable ["3DENDrawPrecision", 0.25]));

// Check whether we are dirty and whether curve was ever baked
private _dirty 		= _curve getVariable ["_dirty", false];
private _points		= _curve getVariable ["_bakedCurve", []];

// In case we are dirty or we were never baked before
if (_dirty || !(count _points > 0)) then
{
	// The time at which last drag operation was registered
	private _lastDragOperationTime = missionNamespace getVariable ["_lastDragOperationTime", -1];

	// The number of segments to compute
	if (time - _lastDragOperationTime < 0.5) then
	{
		_segments = round (_segments * (_curve getVariable ["3DENDrawPrecisionDrag", 0.25]));
	};

	// Bake the curve
	_points = [_curve, _segments] call BIS_fnc_richCurve_edenBakeCurve3D;

	// Store the points
	_curve setVariable ["_bakedCurve", _points];

	// No longer dirty
	_curve setVariable ["_dirty", false];
};

// Draw the curve
[_points] call BIS_fnc_richCurve_edenDrawCurve3D;

// Draw the control points of each key
if (missionNamespace getVariable ["BIS_keyframe_controlPressed", false]) then
{
	[_curve] call BIS_fnc_richCurve_edenDrawControlPoints3D;
};

// Mouse near curve detection, for in curve key placement
if (missionNamespace getVariable ["BIS_keyframe_shiftPressed", false]) then
{
	// The mouse location projected to world
	private _mouseLoc = AGLToASL (screenToWorld getMousePosition);

	// Compute the nearest segment to mouse location
	private _segment 				= [_curve, _mouseLoc, _points] call BIS_fnc_richCurve_edenComputeNearestSegment;
	private _nearestSegment 		= _segment select 0;
	private _distanceToSegment2D 	= _segment select 1;
	private _prevKey				= _segment select 2;
	private _nextKey				= _segment select 3;

	// Clear nearest point
	_curve setVariable ["_keyPoint", nil];

	// Make sure segment is nearby
	if (_distanceToSegment2D < 20.0) then
	{
		// Compute the nearest point in the segment from mouse location
		private _nearestPoint = (_nearestSegment + [_mouseLoc, false]) call BIS_fnc_nearestPoint;

		// Store the point
		_curve setVariable ["_keyPoint", [ASLToAGL _nearestPoint, _prevKey, _nextKey]];

		// The distance to nearest point
		private _distance2D = _nearestPoint distance2D _mouseLoc;

		// Only handle point if nearby
		if (_distance2D < 20.0) then
		{
			// Draw line between mouse location and nearest point in the baked curve
			drawLine3D [ASLToAGL _mouseLoc, ASLToAGL _nearestPoint, [1, 1, 1, 1]];
			drawIcon3D ["", [1,1,1,1], ASLToAGL (_mouseLoc vectorAdd [0,0,-1]), 0, 0, 0, "PRESS [SHIFT + SPACE] TO PLACE KEY", 1, 0.03, "PuristaMedium"];
		};
	};
};