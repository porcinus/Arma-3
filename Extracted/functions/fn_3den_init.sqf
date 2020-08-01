/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN initialization

	Parameter(s):
	Nothing

	Returns:
	Nothing
*/

// The display
private _display = findDisplay 313;

// Validate display
if (isNull _display) exitWith
{
	"Unable to get 3DEN display" call BIS_fnc_error;
};

// Input handling
_display displayAddEventHandler ["KeyDown", {_this call BIS_fnc_3den_onKeyDown;}];
_display displayAddEventHandler ["KeyUp", {_this call BIS_fnc_3den_onKeyUp;}];
