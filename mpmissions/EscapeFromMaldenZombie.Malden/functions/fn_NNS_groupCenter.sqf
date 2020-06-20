/*
NNS
Output group center position

Example: 
[group player] call BIS_fnc_NNS_groupCenter;

*/

// Params
params [
	["_group",grpNull], //group to monitor
	["_defaultArray",[0,0,0]], //default return
	["_ignore",[]] //ignore unit array
];

if (_group isEqualTo grpNull) exitWith {["BIS_fnc_NNS_groupCenter : Group needed"] call BIS_fnc_NNS_debugOutput; _defaultArray};

_Xmed = 0; //inital X val
_Ymed = 0; //inital Y val
_aliveCount = 0; //alive in group count
_returnArray = _defaultArray; //default return

{
	if (alive _x && {!(_x in _ignore)}) then {
		_tmp = [0,0,0]; //tmp
		if (vehicle _x != _x) then {_tmp = getPos (objectParent _x); //unit in vehicle
		} else {_tmp = getPos _x;}; //unit on foot
		_Xmed = _Xmed + (_tmp select 0); //cumulative X values
		_Ymed = _Ymed + (_tmp select 1); //cumulative Y values
		_aliveCount = _aliveCount + 1; //increment
	};
} forEach units _group; //alive in group loop

if (_aliveCount > 0) then { //NNS: not Original rules -> keep respawn if some player alive or keep respawn
	_returnArray = [round(_Xmed/_aliveCount), round(_Ymed/_aliveCount), 0]; //new respawn position
	//[format["BIS_fnc_NNS_groupCenter : group:%1 center: %2",_group,_returnArray]] call BIS_fnc_NNS_debugOutput;
} else {
	//[format["BIS_fnc_NNS_groupCenter : Warning, all units dead (%1)",_group]] call BIS_fnc_NNS_debugOutput;
};

_returnArray