/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Set's camera focus

	Parameter(s):
	_this select 0: Object	- The camera
	_this select 1: Array	- The new focus

	Returns:
	Nothing
*/

// Parameters
private _camera = _this param [0, objNull, [objNull]];
private _focus	= _this param [1, [-1, -1], [[]]];

// Set
_camera setVariable ["Focus", _focus];