/*
	Author: 
		Killzone_Kid
	
	Description:
		Created a local marker from serialized data
	
	Parameter(s):
		0: STRING - marker data from BIS_fnc_markerToString
	
	Returns:
		STRING - created local marker 
		or 
		"" on error or if marker exists
	
	Example:
		["|marker_0|[4359.1,4093.51,0]|mil_objective|ICON|[1,1]|0|Solid|Default|1|An objective"] call BIS_fnc_stringToMarkerLocal;
*/

params [["_markerData","",[""]]];

if (_markerData isEqualTo "") exitWith 
{
	["Marker data is empty"] call BIS_fnc_error;
	""
};

_markerData splitString (_markerData select [0,1]) params
[
	"_markerName", 
	"_markerPos", 
	"_markerType",
	"_markerShape",
	"_markerSize",
	"_markerDir",
	"_markerBrush",
	"_markerColor",
	"_markerAlpha",
	["_markerText",""]
];

private _markerLocal = createMarkerLocal [_markerName, parseSimpleArray _markerPos];

_markerLocal setMarkerTypeLocal _markerType;
_markerLocal setMarkerShapeLocal _markerShape;
_markerLocal setMarkerSizeLocal parseSimpleArray _markerSize;
_markerLocal setMarkerDirLocal parseNumber _markerDir;
_markerLocal setMarkerBrushLocal _markerBrush;
_markerLocal setMarkerColorLocal _markerColor;
_markerLocal setMarkerAlphaLocal parseNumber _markerAlpha;
_markerLocal setMarkerTextLocal _markerText;

_markerLocal 