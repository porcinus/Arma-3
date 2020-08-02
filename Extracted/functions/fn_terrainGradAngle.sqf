/************************************************************
	Terrain Gradient Angle
	Author: Petr Ondracek

Description: 
Returns the gradient angle (in radians) of the terrain at a specified position and a compass direction. It is an angle of the slope of a tangent plane to the terrain at the specified position in the specified direction. 

Parameters:	
0: OBJECT or ARRAY - object or its position
1: NUMBER - direction where should be gradient calculated (compass direction)
2: NUMBER (optional) - which stepsize should be used

Returns: 
NUMBER

Example: [getPos player, getDir player] call BIS_fnc_terrainGradient
*************************************************************/

	private ["_result","_pos0","_pos1","_dir","_delta"];
	_pos0 = _this param [0,objnull,[objnull,[]]];
	_dir = _this param [1,0,[0]];
	_delta = _this param [2,1.0,[0]];
	
	//if an object, not position, was passed in, then get its position
	if(typename _pos0 == "OBJECT") then {_pos0 = getposASL _pos0};
	//check if position wasn't planar
	if (count _pos0==2) then
	{
		_pos0 = [(_pos0 select 0), (_pos0 select 1), getTerrainHeightASL _pos0];
	};
		
	_pos1 = [_pos0,_delta,_dir] call BIS_fnc_relPos;
	_pos0 = getTerrainHeightASL [_pos0 select 0, _pos0 select 1];
	_pos1 = getTerrainHeightASL [_pos1 select 0, _pos1 select 1];
	
	_result = (atan((_pos1-_pos0)/_delta));	
	
	_result



	