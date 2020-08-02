/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's this timeline playback as reverse or not

	Parameter(s):
	_this select 0: Object		- The timeline
	_this select 1: Alpha		- Current timeline alpha
	_this select 1: DeltaT		- Delta time

	Returns:
	Nothing
*/

#include "\A3\Modules_f\Animation\commonDefines.inc"

// Parameters
params [["_timeline", objNull, [objNull]], ["_alpha", 0.0, [0.0]], ["_deltaTime", 0.0, [0.0]]];

// Apply alpha modifiers
if (_timeline getVariable ["InterpMode", LINEAR] != LINEAR) then
{
	_alpha = switch (_timeline getVariable ["InterpMode", LINEAR]) do
	{
		case CUBIC :			{[0.0, 0.0, 1.0, 1.0, _Alpha] call BIS_fnc_bezierInterpolate;};
		case EASEIN : 			{[0.0, 1.0, _Alpha] call BIS_fnc_easeIn;};
		case EASEOUT :			{[0.0, 1.0, _Alpha] call BIS_fnc_easeOut;};
		case EASEINOUT :		{[0.0, 1.0, _Alpha] call BIS_fnc_easeInOut;};
		case HERMITE :			{[0.0, 1.0, _Alpha] call BIS_fnc_hermite;};
		case BERP :				{[0.0, 1.0, _Alpha] call BIS_fnc_berp;};
		case BOUNCEIN :			{[0.0, 1.0, _Alpha] call BIS_fnc_bounceIn;};
		case BOUNCEOUT :		{[0.0, 1.0, _Alpha] call BIS_fnc_bounceOut;};
		case BOUNCEINOUT :		{[0.0, 1.0, _Alpha] call BIS_fnc_bounceInOut;};
		case QUINTICIN :		{[0.0, 1.0, _Alpha] call BIS_fnc_quinticIn;};
		case QUINTICOUT :		{[0.0, 1.0, _Alpha] call BIS_fnc_quinticOut;};
		case QUINTICINOUT :		{[0.0, 1.0, _Alpha] call BIS_fnc_quinticInOut;};
	};
};

// Iterate the curves that this timeline should simulate
{
	private _curve = _x;

	// Tick curve in 3DEN
	if (is3DEN) then
	{
		[_curve, _deltaTime] call BIS_fnc_richCurve_edenTick;
	};

	// Gather curve simulated objects
	private _simulatedObjects = [_curve] call BIS_fnc_richCurve_getSimulatedObjects;

	// In case we have simulated objects, simulate them
	if (count _simulatedObjects > 0) then
	{
		private _orientationMode	= [_curve] call BIS_fnc_richCurve_getOrientationMode;
		private _pos				= [_curve, _alpha, 2] call BIS_fnc_richCurve_getCurveValueVector;
		private _d					= [0.0, 0.0, 0.0];
		private _u					= [0.0, 0.0, 0.0];

		if (_orientationMode > 0) then
		{
			private _firstKey			= [_curve] call BIS_fnc_richCurve_getFirstKey;
			private _lastPos			= _curve getVariable ["_lastPos", getPosASLVisual _firstKey];
			private _lastDir			= _curve getVariable ["_lastDir", vectorDirVisual _firstKey];
			private _lastUp				= _curve getVariable ["_lastUp", vectorUpVisual _firstKey];
			private _isLookAt			= _orientationMode > 1;
			private _isMovementDir		= _orientationMode == 3;
			private _lookAtPos			= if (_isLookAt) then {if (_isMovementDir) then {_pos} else {[_curve] call BIS_fnc_richCurve_getLookAtPosition}} else {[0.0, 0.0, 0.0]};
			private _lookAt				= if (!_isLookAt) then {[[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]} else {if (_isMovementDir) then {[_lastPos, _pos] call BIS_fnc_findLookAt} else {[_pos, _lookAtPos] call BIS_fnc_findLookAt}};
			private _dir				= if (!_isLookAt) then {[_curve, _alpha, 3] call BIS_fnc_richCurve_getCurveValueVector} else {_lookAt select 0};
			private _up					= if (!_isLookAt) then {[_curve, _alpha, 4] call BIS_fnc_richCurve_getCurveValueVector} else {_lookAt select 1};

			// TODO - Fixme
			// Our final dir and up vectors
			// Hack to smooth out rotation when orientation is following movement direction
			_d = if (_alpha > 0.0) then {[_lastDir, _dir, _deltaTime, 1.0] call BIS_fnc_interpolateVector} else {_dir};
			_u = if (_alpha > 0.0) then {[_lastUp, _up, _deltaTime, 1.0] call BIS_fnc_interpolateVector} else {_up};

			// Save current orientation for next frame
			_curve setVariable ["_lastDir", _d];
			_curve setVariable ["_lastUp", _u];
		};

		// Save current position so we can use it on the next simulation step
		_curve setVariable ["_lastPos", _pos];

		// Apply transformation to simulated objects
		{
			// Animate location
			_x setPosASL _pos;

			// Animate orientation
			if (_orientationMode > 0) then
			{
				_x setVectorDirAndUp [_d, _u];
			};

			// Animate camera specific properties
			if (_x isKindOf "Camera_F") then
			{
				[_x, [_curve, _alpha, 5] call BIS_fnc_richCurve_getCurveValueFloat] call BIS_fnc_camera_setFOV;
			};
		}
		forEach _simulatedObjects;

		// 3DEN path visualizer (for cases there's no simulated objects, we can still see the animated path)
		if (is3DEN && {get3DENIconsVisible select 1} && {_pos isEqualTypeArray [0.0, 0.0, 0.0]}) then
		{
			drawIcon3D ["\A3\Ui_f\data\GUI\Cfg\Cursors\hc_move_gs.paa", [0,1,0,1], ASLToAGL _pos, 0.5, 0.5, 0, "", 1, 0.02, "TahomaB"];
		};
	};

	// Trigger event
	if (!is3DEN) then
	{
		private _nearestKeys = [_curve, _alpha] call BIS_fnc_richCurve_getKeysAtTime;
		private _curKey = _nearestKeys select 0;

		if (!(_curKey getVariable ["_keyEventHandled", false])) then
		{
			[_curKey] call compile (_curKey getVariable ["Event", ""]);
			[_curKey, "reached", [_curKey]] call BIS_fnc_callScriptedEventHandler;
			_curKey setVariable ["_keyEventHandled", true];
		};
	};
}
forEach ([_timeline] call BIS_fnc_timeline_getSimulatedCurves);