/*
	Author: 
		Karel Moricky, tweaked by Killzone_Kid

	Description:
		Creates GUI background. Pass nil as background position to delete background

	Parameter(s):
		0: ARRAY - background position in format [x,y,w,h]
		1 (Optional): NUMBER or STRING - Rsc layer

	Returns:
		DISPLAY - GUI background display
		
	Example:
		[[0,0,1,1]] call BIS_fnc_guiBackground; // creates default background
		[] call BIS_fnc_guiBackground; // deletes default background
*/

#define DISPLAY_CLASS "RscCommonBackground"

disableserialization;

params 
[
	["_pos", [0,0,0,0], [[]]],
	["_layer", DISPLAY_CLASS, [0, ""]]
];

if !(_pos isEqualTypeArray [0,0,0,0]) exitWith
{
	["Incorrect background position format"] call BIS_fnc_error;
	displayNull
};

_pos params ["_posX", "_posY", "_posW", "_posH"];

uiNamespace setVariable ["RscBackground_X", _posX];
uiNamespace setVariable ["RscBackground_Y", _posY];
uiNamespace setVariable ["RscBackground_W", _posW];
uiNamespace setVariable ["RscBackground_H", _posH];

if ((_layer isEqualType 0 && {_layer > 0}) || (_layer isEqualType "" && {_layer != ""})) exitWith
{
	if (_posW > 0 && _posH > 0) then 
	{
		//--- Show
		_layer cutRsc [DISPLAY_CLASS, "PLAIN"];
		uiNamespace getVariable [DISPLAY_CLASS, displayNull]
	} 
	else 
	{
		//--- Hide
		_layer cutText ["", "PLAIN"];
		displayNull 
	};
};

displayNull 