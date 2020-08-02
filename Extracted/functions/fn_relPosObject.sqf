/*******************************************************************************

	Author: Jiri Wainar

	Description:
	Place object relative to another object.

	Parameter(s):
	_this select 0: OBJECT - parent object
	_this select 1: OBJECT - child object what will be placed
	_this select 2: ARRAY  - offset [x,y,z] in parent object coords
	_this select 3: SCALAR (optional) - direction of the child object

	Example:
	[BIS_briefingTable,BIS_map,[0,0,1]] call BIS_fnc_relPosObject;

	Returns:
	-

	Example of quick preview code:
	[BIS_briefingTable,BIS_map,[0,-0.58,0.857],98] call BIS_fnc_relPosObject;
	BIS_briefingTable setPos getPos BIS_briefingTable;

*******************************************************************************/

private["_parent","_child","_offset","_dir","_localPos","_worldPos"];

_parent    = _this param [0,objNull,[objNull]];
_child     = _this param [1,objNull,[objNull]];
_offset    = _this param [2,[0,0,0],[[]]];
_dir 	   = _this param [3,0,[123]];
_parentSim = _this param [4,false,[false]];
_childSim  = _this param [5,false,[false]];

//get the anchor position
_localPos = [_parent worldToModel (getPosATL _parent),_offset] call BIS_fnc_vectorAdd;
_worldPos = _parent modelToWorld _localPos;
_worldPos = ATLtoASL _worldPos;

_child setPosASL _worldPos;
_child setDir ((getDir _parent) + _dir);

_parent enableSimulation _parentSim;
_child enableSimulation _childSim;