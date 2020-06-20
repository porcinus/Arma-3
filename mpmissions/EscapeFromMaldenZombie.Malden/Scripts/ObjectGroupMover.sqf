/*
NNS : Move all objects/trigger/markers taking a trigger/object as center with a given radius to a random new position.
Important note : Rotation to new location is based on center trigger/object direction.

example : [BIS_Checkpoint_04,[[7919,10098,90],[7810,4210,65]],100] execVM 'ObjectGroupMover.sqf';

*/

params
[
	["_trigger",objNull],
	["_newPosArray",[]], //[[rnd_x1,rnd_y1,rnd_dir1],[rnd_x2,rnd_y2,rnd_dir2],.....]
	["_radius",50], //used for objects detection and waypoint position
	["_stickonground",false] //try to align object on the ground surface
];

limitAngle = { //limit angle within 0-360deg
	params ["_angle"];
	if (_angle > 360) then {_angle = _angle - 360};
	if (_angle < 0) then {_angle = _angle + 360};
	_angle
};

if (_trigger isEqualTo objNull) exitWith {["ObjectGroupMover.sqf : _trigger not exists"] call NNS_fnc_debugOutput;};
if (count _newPosArray < 1) exitWith {["ObjectGroupMover.sqf : _newPosArray is empty"] call NNS_fnc_debugOutput;};

_randPos = _newPosArray call BIS_fnc_selectRandom; //select random position/direction
//_randPos = _newPosArray select 0; //debug

_startPos = getPosATL _trigger; //trigger position
_startDir = 0;
if (typeOf _trigger in ["EmptyDetectorAreaR250","EmptyDetectorAreaR50","EmptyDetectorArea10x10","EmptyDetector"]) then {_startDir = (triggerArea _trigger) select 2; //get trigger direction
} else {_startDir = getDir _trigger;}; //get object direction

_newPosOffsetDir = _startDir - (_randPos select 2); //relative direction offset from trigger to destination

if ((_randPos distance2D _startPos) < 0.1 && abs((_randPos select 2) - _startDir) < 0.1)  exitWith {["ObjectGroupMover.sqf : No move/rotation to do"] call NNS_fnc_debugOutput;};

{
	if(((getMarkerPos _x) distance2D _trigger) <= _radius) then { //marker in radius
		_tmpPos = getMarkerPos  _x; //marker position
		_tmpDist = _tmpPos distance2D _startPos; //distance from trigger
		_tmpRelDir = (((_tmpPos select 1)-(_startPos select 1)) atan2 ((_tmpPos select 0)-(_startPos select 0))); //relative direction from trigger
		_x setMarkerDir 0; //reset marker
		_x setMarkerPos  [(_randPos select 0) + (_tmpDist * cos(_tmpRelDir + _newPosOffsetDir)), (_randPos select 1) + (_tmpDist * sin(_tmpRelDir + _newPosOffsetDir))]; //move marker to new location
	};
} foreach allmapmarkers; //marker detection loop, need to be done first as all triggers will be moved after

{
	_tmpPos = getPosATL _x; //object position
	_tmpDist = _x distance2D _startPos; //distance from trigger
	_tmpRelDir = (((_tmpPos select 1)-(_startPos select 1)) atan2 ((_tmpPos select 0)-(_startPos select 0))); //relative direction from trigger
	if (typeOf _x in ["EmptyDetectorAreaR250","EmptyDetectorAreaR50","EmptyDetectorArea10x10","EmptyDetector"]) then { //is a trigger
		_tmpData = triggerArea _x; //recover trigger data
		_x setTriggerArea [_tmpData select 0, _tmpData select 1, ((_tmpData select 2) - _newPosOffsetDir) call limitAngle, _tmpData select 3]; //set trigger new direction
	} else {_x setDir ((getDir _x) - _newPosOffsetDir) call limitAngle;}; //set object new direction
	_x setPosATL  [(_randPos select 0) + (_tmpDist * cos(_tmpRelDir + _newPosOffsetDir)), (_randPos select 1) + (_tmpDist * sin(_tmpRelDir + _newPosOffsetDir)), 0]; //move object to new location
	if (_stickonground) then {_x setVectorUp surfaceNormal position _x;}; //try to align object on the ground surface
} forEach (_trigger nearObjects _radius); //object detection loop

[format["ObjectGroupMover.sqf : Objects around '%1' radius:%2m moved from [%3, %4] to [%5, %6] (%7m)",_trigger,_radius,_startPos select 0,_startPos select 1,_randPos select 0,_randPos select 1,(_randPos distance2D _startPos)]] call NNS_fnc_debugOutput; //debug
