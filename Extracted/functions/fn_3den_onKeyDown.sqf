/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	A keyboard key is pressed in 3DEN

	Parameter(s):
	_this select 0: Display	- The display control
	_this select 1: Scalar 	- The pressed button
	_this select 2: Bool 	- State of SHIFT
	_this select 3: Bool 	- State of CTRL
	_this select 4: Bool 	- The state of ALT

	Returns:
	Bool - Whether or not to consume the input
*/

#include "\A3\ui_f\hpp\defineDIKCodes.inc"

// Parameters
private _display 	= _this param [0, displayNull, [displayNull]];
private _key		= _this param [1, -1, [-1]];
private _shift		= _this param [2, false, [false]];
private _ctrl		= _this param [3, false, [false]];
private _alt		= _this param [4, false, [false]];

// Whether input should be consumed
private _bConsumeInput = false;

// The pressed key
switch (true) do
{
	// Spacebar pressed
	case (_key == DIK_SPACE && {_shift}):
	{
		if !(missionNamespace getVariable ["BIS_keyframe_spacePressed", false]) then
		{
			// All curve objects
			private _entities 		= all3DENEntities;
			private _objects 		= _entities select 3;
			private _curves			= [];

			// Filter by class
			{
				if (_x isKindOf "Curve_F") then
				{
					_curves pushBackUnique _x;
				};
			}
			forEach _objects;

			// Iterate curves
			{
				private _curve = _x;

				// Curve must have key point and be selected in 3DEN
				if (!isNil {_curve getVariable "_keyPoint"} && {[_x] call BIS_fnc_richCurve_edenIsSelected}) then
				{
					// All the keys currently registered with the curve
					private _keys = [_curve] call BIS_fnc_richCurve_getKeys;

					// The point
					private _point = _curve getVariable "_keyPoint";
					private _pos = _point select 0;
					private _prev = _point select 1;
					private _next = _point select 2;

					// The time between
					private _time = [[_prev] call BIS_fnc_key_getConfigTime, [_next] call BIS_fnc_key_getConfigTime, 0.5] call BIS_fnc_lerp;

					// Do 3DEN history collection to avoid multiple history entries from creating the key
					collect3DENHistory
					{
						// Create key
						private _key = create3DENEntity ["Logic", "Key_F", _pos];
						private _bConnected = add3DENConnection ["Sync", [get3DENEntity (get3DENEntityID _key)], get3DENEntity (get3DENEntityID _curve)];
						[_key, 1] call BIS_fnc_key_setInterpMode;
						[_key, _time] call BIS_fnc_key_setTime;
						[_key, 10.0] call BIS_fnc_key_setArriveTangentWeight;
						[_key, 10.0] call BIS_fnc_key_setLeaveTangentWeight;

						// Create control points
						for "_i" from 0 to 1 do
						{
							private _posCP = if (_i == 0) then {_key modelToWorldVisual [0.0, 10.0, 0.0]} else {_key modelToWorldVisual [0.0, -10.0, 0.0]};
							private _controlPoint = create3DENEntity ["Logic", "ControlPoint_F", _posCP];
							private _bConnectedCP = add3DENConnection ["Sync", [get3DENEntity (get3DENEntityID _controlPoint)], get3DENEntity (get3DENEntityID _key)];
							[_controlPoint, _i == 0] call BIS_fnc_controlPoint_setIsArrive;
						};
					};

					// Consume input
					_bConsumeInput = true;
				};
			}
			forEach _curves;

			missionNamespace setVariable ["BIS_keyframe_spacePressed", true];
		};
	};

	// Shift pressed
	case (_key == DIK_LSHIFT):
	{
		missionNamespace setVariable ["BIS_keyframe_shiftPressed", true];
	};

	// Control pressed
	case (_key == DIK_LCONTROL):
	{
		missionNamespace setVariable ["BIS_keyframe_controlPressed", true];
	};

	// F10 pressed
	case (_key == DIK_F10):
	{
		{
			if ([_x] call BIS_fnc_timeline_edenIsSelected && {[_x] call BIS_fnc_timeline_isPlaying}) then
			{
				[_x] call BIS_fnc_timeline_play;
			};
		}
		forEach (missionNamespace getVariable ["Timelines", []]);
	};
};

// Return
_bConsumeInput;