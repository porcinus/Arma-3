/*
NNS
Output group center position

Example: 
[group player] call NNS_fnc_groupCenter;

*/

// Params
params [
	["_group",grpNull], //group to monitor
	["_defaultArray",[0,0,0]], //default return
	["_ignore",[]] //ignore unit array
];

if (_group isEqualTo grpNull) exitWith {["NNS_fnc_groupCenter : Group needed"] call NNS_fnc_debugOutput; _defaultArray};

_Xadd = 0; _Yadd = 0; //inital cumulative val
_aliveCount = 0; //alive in group count
_returnArray = _defaultArray; //default return

{
	if (alive _x && {!(_x in _ignore)}) then { //unit alive and not blacklisted
		_tmp = [0,0,0]; //tmp
		if (vehicle _x != _x) then {_tmp = getPos (objectParent _x)} else {_tmp = getPos _x}; //unit position, in vehicle, on foot
		if !([0,0,0] isEqualTo _tmp) then { //in case something goes wrong
			_tmpX =_tmp select 0; _tmpY = _tmp select 1; //X-Y position
			_Xadd =_Xadd + _tmpX; _Yadd = _Yadd + _tmpY; //cumulative X-Y values
			_aliveCount = _aliveCount + 1; //increment
		};
	};
} forEach units _group; //alive in group loop

if (_aliveCount > 0) then { //at least one valid unit
	_returnArray = [_Xadd/_aliveCount, _Yadd/_aliveCount, 0]; //median position
	//[format["NNS_fnc_groupCenter : group:%1 center: %2",_group,_returnArray]] call NNS_fnc_debugOutput;
} else {
	//[format["NNS_fnc_groupCenter : Warning, all units dead (%1)",_group]] call NNS_fnc_debugOutput;
};

_returnArray