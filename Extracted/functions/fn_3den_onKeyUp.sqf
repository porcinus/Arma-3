/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	A keyboard key is released in 3DEN

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

// The released key
switch (true) do
{
	// Spacebar released
	case (_key == DIK_SPACE && {_shift}):
	{
		missionNamespace setVariable ["BIS_keyframe_spacePressed", nil];
	};

	// Shift released
	case (_key == DIK_LSHIFT):
	{
		missionNamespace setVariable ["BIS_keyframe_shiftPressed", nil];
	};

	// Control released
	case (_key == DIK_LCONTROL):
	{
		missionNamespace setVariable ["BIS_keyframe_controlPressed", nil];
	};
};

// Return
_bConsumeInput;