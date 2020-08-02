/*
	File: nearestPosition.sqf
		Author: Joris-Jan van 't Land, optimised by Killzone_Kid

	Description:
		Function to find the nearest Object or position from a list, 
		when compared to a given Object or position.

	Parameters:
		0: Array of Objects, Locations, Groups, markers (String) and / or positions (Array)
		1: Comparator Object, Location, Group, marker (String) or position (Array)
	
	Notes:
		[*] For type Group the position of its leader is used.
	
	Returns:
		Object / Location / Group / marker (String) or position (Array) which is nearest to the comparator
*/

params [["_list", []], ["_to", [0,0,0]], "_from", "_dist"];

/// --- validate general input
#include "..\paramsCheck.inc"
paramsCheck(_list,isEqualType,[])

private _max = -log 0;
private _nearest = [0,0,0];

_to = _to call BIS_fnc_position;
if (!isNil "_to") then
{
	{
		_from = _x call BIS_fnc_position;
		if (!isNil "_from") then
		{	
			_dist = _from distanceSqr _to;
			if (_dist < _max) then 
			{
				_max = _dist; 
				_nearest = _x;
			};
		};
	} 
	count _list;
};

_nearest 