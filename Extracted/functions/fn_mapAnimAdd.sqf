/*
	Author:
	Nelson Duarte

	Description:
	Same as mapAnimAdd but with possibility for non linear zoom and position interpolation modes

	Parameters:
	_this select 0: FLOAT	- The animation duration in seconds
	_this select 1: FLOAT	- The zoom value
	_this select 2: ARRAY	- The position vector
	_this select 3: INTEGER	- The interpolation mode for the zoom
	_this select 4: INTEGER	- The interpolation mode for the position
	_this select 5: FLOAT	- The zoom value to start animation from, if not set the current map zoom is used
	_this select 6: ARRAY	- The position vector to start animation from, if not set the current map position is used

	Returns:
	Nothing

	Examples:
	[2.0, 0.05, getPos player] call BIS_fnc_mapAnimAdd;
*/

#include "\a3\functions_f\debug.inc"
#include "\A3\Modules_f\Animation\commonDefines.inc"

// If we are not in the map, nothing to do here
if (!visibleMap) exitWith
{
	"Unable to play Map Animation when not in the Map" call BIS_fnc_error;
};

// Function parameters
params
[
	["_duration", 1.0, [0.0]],
	["_toZoom", 0.05, [0.0]],
	["_toPosition", [0.0, 0.0, 0.0], [[]]],
	["_interpModeZoom", 12, [0]],
	["_interpModePosition", 12, [0]],
	["_fromZoom", ctrlMapScale  ((findDisplay 12) displayCtrl 51), [0.0]],
	["_fromPosition", ((findDisplay 12) displayCtrl 51) ctrlMapScreenToWorld [0.5, 0.53], [[]]]
];

// We want x, y and z
if (count _fromPosition < 3) then
{
	_fromPosition pushBack 0.0;
};

// Make sure we are not in an animation already
// If we are, stop the old transition and proceed with the new one
if (missionNamespace getVariable ["BIS_mapAnimation_isPlaying", false]) then
{
	[] call BIS_fnc_mapAnimClear;
};

// Create the timeline
private _timeline = createAgent ["Timeline_F", position cameraOn, [], 0, "CAN_COLLIDE"];

// Prepare animation data by storing current position so we can read it next frame
missionNamespace setVariable ["BIS_mapAnimation_data", [_fromZoom, _toZoom, _fromPosition, _toPosition, _interpModeZoom, _interpModePosition, _timeline]];

// Setup then timeline
[_timeline, _duration] call BIS_fnc_timeline_setLength;

// Timeline stops playing
[_timeline, "finished",
{
	[] call BIS_fnc_mapAnimClear;

}] call BIS_fnc_addScriptedEventHandler;

// Create animation tick event, here we will update the animation each frame
missionNamespace setVariable ["BIS_mapAnimation_eachFrame", addMissionEventHandler ["EachFrame",
{
	// If map was closed, abort the animation
	if (!visibleMap) exitWith
	{
		[] call BIS_fnc_mapAnimClear;
	};

	PROFILING_START("BIS_fnc_mapAnimAdd");

	// The animation data
	(missionNamespace getVariable ["BIS_mapAnimation_data", []]) params
	[
		["_fromZoom", 1.0, [0.0]],
		["_toZoom", 1.0, [0.0]],
		["_fromPosition", [0.0, 0.0, 0.0], [[]]],
		["_toPosition", [0.0, 0.0, 0.0], [[]]],
		["_interpModeZoom", 1, [0]],
		["_interpModePosition", 1, [0]],
		["_timeline", objNull, [objNull]]
	];

	// The timeline alpha value, is the position in the animation, between 0 (start) and 1 (end)
	private _alpha = [_timeline] call BIS_fnc_timeline_getAlpha;

	// Interpolate zoom
	private _newZoom = switch (_interpModeZoom) do
	{
		case LINEAR :			{[_fromZoom, _toZoom, _alpha] call BIS_fnc_lerp;};
		case CUBIC :			{[_fromZoom, _fromZoom, _toZoom, _toZoom, _alpha] call BIS_fnc_bezierInterpolate;};
		case EASEIN : 			{[_fromZoom, _toZoom, _alpha] call BIS_fnc_easeIn;};
		case EASEOUT :			{[_fromZoom, _toZoom, _alpha] call BIS_fnc_easeOut;};
		case EASEINOUT :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_easeInOut;};
		case HERMITE :			{[_fromZoom, _toZoom, _alpha] call BIS_fnc_hermite;};
		case BERP :				{[_fromZoom, _toZoom, _alpha] call BIS_fnc_berp;};
		case BOUNCEIN :			{[_fromZoom, _toZoom, _alpha] call BIS_fnc_bounceIn;};
		case BOUNCEOUT :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_bounceOut;};
		case BOUNCEINOUT :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_bounceInOut;};
		case QUINTICIN :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_quinticIn;};
		case QUINTICOUT :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_quinticOut;};
		case QUINTICINOUT :		{[_fromZoom, _toZoom, _alpha] call BIS_fnc_quinticInOut;};
	};

	// Interpolate position
	private _newPosition = switch (_interpModePosition) do
	{
		case LINEAR :			{[_fromPosition, _toPosition, _alpha] call BIS_fnc_lerpVector;};
		case CUBIC :			{[_fromPosition, _fromPosition, _toPosition, _toPosition, _alpha] call BIS_fnc_bezierInterpolateVector;};
		case EASEIN : 			{[_fromPosition, _toPosition, _alpha] call BIS_fnc_easeInVector;};
		case EASEOUT :			{[_fromPosition, _toPosition, _alpha] call BIS_fnc_easeOutVector;};
		case EASEINOUT :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_easeInOutVector;};
		case HERMITE :			{[_fromPosition, _toPosition, _alpha] call BIS_fnc_hermiteVector;};
		case BERP :				{[_fromPosition, _toPosition, _alpha] call BIS_fnc_berpVector;};
		case BOUNCEIN :			{[_fromPosition, _toPosition, _alpha] call BIS_fnc_bounceInVector;};
		case BOUNCEOUT :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_bounceOutVector;};
		case BOUNCEINOUT :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_bounceInOutVector;};
		case QUINTICIN :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_quinticInVector;};
		case QUINTICOUT :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_quinticOutVector;};
		case QUINTICINOUT :		{[_fromPosition, _toPosition, _alpha] call BIS_fnc_quinticInOutVector;};
	};

	// Animate the map
	mapAnimAdd [0.0, _newZoom, _newPosition];
	mapAnimCommit;

	PROFILING_STOP("BIS_fnc_mapAnimAdd");
}]];

// Force initial update
mapAnimAdd [0.0, _fromZoom, _fromPosition];
mapAnimCommit;

// Flag as playing the animation
missionNamespace setVariable ["BIS_mapAnimation_isPlaying", true];

// Play the animation
[_timeline] call BIS_fnc_timeline_play;