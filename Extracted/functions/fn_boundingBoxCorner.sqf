/*
	File: 
		fn_boundingBoxCorner.sqf
	
	Author: 
		Karel Moricky, optimised by Killzone_Kid

	Description:
		Returns position of all four bounding box corners
		OR
		Returns position of the nearest corner to the given position

	Parameter(s):
		_this: OBJECT - object with bounding box
		OR
		_this: ARRAY in format:
			0: OBJECT - object with bounding box
			1: ARRAY or OBJECT - position for which the nearest corner is returned

	Returns:
		ARRAY in format [pos1, pos2, pos3, pos4] - 4 corners of the bounding box
		OR
		ARRAY in format [x,y,z] - position of the nearest corner
		
	Example 1:
		_corners = car call BIS_fnc_boundingBoxCorner; 
		
	Example 2:
		_nearestCorner = [car, player] call BIS_fnc_boundingBoxCorner;
*/

params [["_obj", -1], "_pos"];

/// --- validate input
#include "..\paramsCheck.inc"
paramsCheck(_obj,isEqualType,objNull)

if (isNil "_pos") exitWith
{
	((_obj modelToWorld (boundingBox _obj select 0)) + (_obj modelToWorld (boundingBox _obj select 1))) params ["_x1", "_y1", "", "_x2", "_y2"];

	[[_x2, _y2, 0], [_x2, _y1, 0], [_x1, _y1, 0], [_x1, _y2, 0]]
};

if (_pos isEqualTypeAny [objNull,[]]) exitWith
{
	((_obj modelToWorld (boundingBox _obj select 0)) + (_obj modelToWorld (boundingBox _obj select 1))) params ["_x1", "_y1", "", "_x2", "_y2"];

	private _corners = [[_x2, _y2, 0], [_x2, _y1, 0], [_x1, _y1, 0], [_x1, _y2, 0]] apply {[_x distance2D _pos, _x]};
	_corners sort true;
	
	_corners select 0 select 1
};

/// --- wrong _pos type
#define arr [objNull,[]]
paramsCheck(_pos,isEqualTypeAny,arr)