/*
	File: 
		fn_boundingBoxMarker.sqf
	
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Creates marker on object with size of object's bounding box
		The marker could be global, in which case its name would be "boundingBoxMarker_<objectNetId>"
		Or local, in which case its name would be "_boundingBoxMarker_<objectNetId>"
		Advanced option allows to chose marker color, brush, alpha and locality as well as provides method to delete marker

	Parameter(s):
		_this: OBJECT - object for which to creare marker
		OR
		_this: ARRAY in format:
			0: OBJECT - object for which to create marker
			1: BOOLEAN - marker locality. true - global, false - local. Default: true
			2: STRING - marker color. Default: "ColorBlack"
			3: STRING - marker brush. Default: "Solid"
			4: NUMBER - marker alpha. Default: 1
		OR
		_this: ARRAY in format:
			0: BOOLEAN - true: delete global marker, false: delete local marker
			1: OBJECT - object for which to delete marker

	Returns:
		STRING - name of the marker or "" in delete mode
		
	Example 1:
		_blackGlobalMarker = car call BIS_fnc_boundingBoxMarker; // create default black global marker for car
		
	Example 2:
		_redLocalMarker = [car, false, "ColorRed", "SolidFull", 0.7] call BIS_fnc_boundingBoxMarker; // create/update local red marker for car
		
	Example 3:
		[false, car] call BIS_fnc_boundingBoxMarker; // delete local marker for car
*/

// --- old way of creating marker for backward compatibility
if (_this isEqualType objNull) exitWith
{
	boundingBoxReal _this params ["_leftBackBottom", "_rightFrontTop"];
	private _mrk = format ["boundingBoxMarker_%1", _this call BIS_fnc_netId];
	
	if (_mrk isEqualTo createMarker [_mrk, _this]) then
	{
		_mrk setMarkerShape "RECTANGLE";
		_mrk setMarkerColor "ColorBlack";
		private _diff = _rightFrontTop vectorDiff _leftBackBottom;
		_mrk setMarkerSize [(_diff vectorDotProduct [1,0,0]) / 2, (_diff vectorDotProduct [0,1,0]) / 2];
	};

	_mrk setMarkerDir getDir _this;
	_mrk setMarkerPos (_this modelToWorld (_leftBackBottom vectorAdd _rightFrontTop vectorMultiply 0.5));
	
	_mrk
};

// --- delete marker routine
if (_this isEqualTypeParams [false, objNull]) exitWith
{
	params ["_global", "_obj"];
	
	if (_global) then 
	{
		deleteMarker format ["boundingBoxMarker_%1", _obj call BIS_fnc_netId];
	}
	else
	{
		deleteMarkerLocal format ["_boundingBoxMarker_%1", _obj call BIS_fnc_netId];
	};
	
	""
};

params ["_obj", ["_global", true], ["_color", "ColorBlack"], ["_brush", "Solid"], ["_alpha", 1]];

/// --- validate input
#include "..\paramsCheck.inc"
#define arr1 [_obj,_global,_color,_brush,_alpha]
#define arr2 [objNull,true,"","",0]
paramsCheck(arr1,isEqualTypeParams,arr2)

boundingBoxReal _obj params ["_leftBackBottom", "_rightFrontTop"];
private _pos = _obj modelToWorld (_leftBackBottom vectorAdd _rightFrontTop vectorMultiply 0.5);
private _dir = getDir _obj;	

// --- global marker, default
if (_global) exitWith
{
	private _mrk = format ["boundingBoxMarker_%1", _obj call BIS_fnc_netId];
	
	if (_mrk isEqualTo createMarker [_mrk, _obj]) then // marker is new
	{
		_mrk setMarkerShape "RECTANGLE";
		private _diff = _rightFrontTop vectorDiff _leftBackBottom;
		_mrk setMarkerSize [(_diff vectorDotProduct [1,0,0]) / 2, (_diff vectorDotProduct [0,1,0]) / 2];
	};
	
	// --- save some bandwidth
	if !(markerColor _mrk isEqualTo _color) then {_mrk setMarkerColor _color};
	if !(markerBrush _mrk isEqualTo _brush) then {_mrk setMarkerBrush _brush};
	if !(markerAlpha _mrk isEqualTo _alpha) then {_mrk setMarkerAlpha _alpha};
	if !(markerDir _mrk isEqualTo _dir) then {_mrk setMarkerDir _dir};
	if !(markerPos _mrk isEqualTo _pos) then {_mrk setMarkerPos _pos};
	
	_mrk
};

// --- local marker wanted
private _mrk = format ["_boundingBoxMarker_%1", _obj call BIS_fnc_netId];

if (_mrk isEqualTo createMarkerLocal [_mrk, _obj]) then // marker is new
{
	_mrk setMarkerShapeLocal "RECTANGLE";
	private _diff = _rightFrontTop vectorDiff _leftBackBottom;
	_mrk setMarkerSizeLocal [(_diff vectorDotProduct [1,0,0]) / 2, (_diff vectorDotProduct [0,1,0]) / 2];
};

_mrk setMarkerColorLocal _color;
_mrk setMarkerBrushLocal _brush;
_mrk setMarkerAlphaLocal _alpha;
_mrk setMarkerDirLocal _dir;
_mrk setMarkerPosLocal _pos;

_mrk