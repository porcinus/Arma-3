/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's camera vision mode

	Parameter(s):
	_this select 0: Object	- The camera
	_this select 1: Integer	- The vision mode

	Returns:
	Nothing
*/

// Parameters
private _camera		= _this param [0, objNull, [objNull]];
private _visionMode	= _this param [1, 0, [0]];

// Validate camera
if (isNull _camera || {_visionMode == [_camera] call BIS_fnc_camera_getVisionMode}) exitWith {};

// Set the vision mode
_camera setVariable ["VisionMode", _visionMode];

// Cam instance
private _cam = [_camera] call BIS_fnc_camera_getCam;

if (!isNull _cam) then
{
	// If in 3DEN we may have camera PIP enabled
	if (is3DEN) then
	{
		"3DENCameraPIP" setPiPEffect [_visionMode];
	}
	else
	{
		switch (_visionMode) do
		{
			case 1: 	{camUseNVG true;};
			case 2 : 	{true setCamUseTi 0;};
			default 	{camUseNVG false; false setCamUseTi 0;};
		};
	};
};