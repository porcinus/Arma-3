/*
	Author: Nelson Duarte

	Description:
	Returns intersections under cursor

	Parameters:
	_this:

	Returns:
	ARRAy of intersections, see https://community.bistudio.com/wiki/lineIntersectsSurfaces
*/
params
[
	["_mouseX", 0.0, [0.0]],
	["_mouseY", 0.0, [0.0]],
	["_ignoredObject1", objNull, [objNull]],
	["_ignoredObject2", objNull, [objNull]],
	["_sortMode", true, [true]],
	["_maxResults", 1, [0]],
	["_primaryLOD", "VIEW", [""]],
	["_secondaryLOD", "FIRE", [""]]
];

private ["_locationStart", "_locationEnd"];
_locationStart = AGLToASL positionCameraToWorld [0,0,0];
_locationEnd = AGLToASL screenToWorld [_mouseX, _mouseY];

// Do collision test
lineIntersectsSurfaces [_locationStart, _locationEnd, _ignoredObject1, _ignoredObject2, _sortMode, _maxResults];