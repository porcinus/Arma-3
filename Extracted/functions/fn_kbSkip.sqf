/*
	Author: Karel Moricky

	Description:
	Skip conversation. Currently played sentence will be finished

	Parameter(s):
	_this select 0: STRING - Topic name
	_this select 1 (Optional): STRING - container name (default: current mission ID)

	Returns:
	NUMBER
*/

private ["_topicName","_mission","_wait","_varName"];

_topicName =	_this param [0,"",["",objnull]];
_mission =	_this param [1,missionname,[""]];
_wait =		_this param [2,false,[false,[],0]];

_varName = if (_topicname isequaltype objnull) then {
	_topicName getvariable ["bis_fnc_kbtell",""]
} else {
	_mission + "_" + _topicName
};


//--- Just asking
if (_wait isequaltype []) exitwith {
	private ["_return"];
	_return = bis_functions_mainscope getvariable _varName;
	if (isnil "_return") then {
		_return = -1;
	} else {
		if (count  _wait > 0) then {
			bis_functions_mainscope setvariable [_varName,nil];
		};
	};
	_return
};

//--- Set
if (_varName == "") exitwith {_wait};
if (_wait isequaltype true) then {_wait = [0,1] select _wait;};
bis_functions_mainscope setvariable [_varName,_wait];
_wait