/*
	Author: Nelson Duarte <@Nelson_G_Duarte>

	Description:
	3DEN selected entities changes

	Parameter(s):
	Nothing

	Returns:
	Nothing
*/

private _selection 			= (get3DENSelected "") select 3;
private _entityListDirty 	= missionNamespace getVariable ["_entityListDirty", false];

private ["_timelines", "_curves", "_keys", "_controlPoints", "_cameras"];

if (_entityListDirty) then
{
	_timelines 		= allMissionObjects "Timeline_F";
	_curves			= allMissionObjects "Curve_F";
	_keys			= allMissionObjects "Key_F";
	_controlPoints	= allMissionObjects "ControlPoint_F";
	_cameras		= allMissionObjects "Camera_F";
	
	missionNamespace setVariable ["_entityListDirty", false];
	missionNamespace setVariable ["_entityList", [_timelines, _curves, _keys, _controlPoints, _cameras]];
}
else
{
	_timelines 		= (missionNamespace getVariable ["_entityList", [[], [], [], [], []]]) select 0;
	_curves			= (missionNamespace getVariable ["_entityList", [[], [], [], [], []]]) select 1;
	_keys			= (missionNamespace getVariable ["_entityList", [[], [], [], [], []]]) select 2;
	_controlPoints	= (missionNamespace getVariable ["_entityList", [[], [], [], [], []]]) select 3;
	_cameras		= (missionNamespace getVariable ["_entityList", [[], [], [], [], []]]) select 4;
};

// Reset selected flag on old selected entities
{
	_x setVariable ["_edenSel", nil];
}
forEach (_timelines + _curves + _keys + _controlPoints + _cameras);

// Flag selected entities
{
	if (_x isKindOf "Timeline_F" || {_x isKindOf "Curve_F"} || {_x isKindOf "Key_F"} || {_x isKindOf "ControlPoint_F"} || {_x isKindOf "Camera_F"}) then
	{
		_x setVariable ["_edenSel", true];
	};
}
forEach _selection;
/*
// Change selection state of old cameras
{
	_x setVariable ["_selected", false];
	[_x, false] call BIS_fnc_camera_edenSelectionChanged;
}
forEach _cameras;

// Change selection state of new cameras
{
	// First found only
	if (true) exitWith
	{
		_x setVariable ["_selected", true];
		[_x, true] call BIS_fnc_camera_edenSelectionChanged;
	};
}
forEach _cameras;
*/