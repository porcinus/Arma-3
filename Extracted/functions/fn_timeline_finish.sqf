/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	Called when timeline finishes playing (reaches it's end)

	Parameter(s):
	_this select 0: Object - The timeline

	Returns:
	Nothing
*/

// Parameters
private _timeline = _this param [0, objNull, [objNull]];

// Validate object
if (isNull _timeline) exitWith
{
	// Log error
	"Invalid timeline object provided" call BIS_fnc_error;
};

// Flag as finished
_timeline setVariable ["Finished", true];

// Trigger event
if (!is3DEN) then
{
	[_timeline, "finished", [_timeline]] call BIS_fnc_callScriptedEventHandler;
	[_timeline] call compile (_timeline getVariable ["EventFinished", ""]);
};

// If in 3DEN we play again
if (is3DEN) then
{
	[_timeline] call BIS_fnc_timeline_play;
}
// Destroy if requested
else
{
	if (_timeline getVariable ["DestroyWhenFinished", false]) then
	{
		deleteVehicle _timeline;
	};
};