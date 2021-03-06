/*
	Author: Karel Moricky

	Description:
	Header function of local mission conversations

	Parameter(s):
		0: STRING - unique mode
		1 (Optional): ANY - additional params

	Returns:
	BOOL
*/

private ["_mode","_function"];
_mode = _this param [0,"",[""]];
_function = _this param [2,BIS_fnc_missionConversationsLocal,[{},""]];
_this = _this param [1,[]];

//--- Extract the function when only variable was passed in
if (typename _function == typename "") then {_function = missionnamespace getvariable [_function,BIS_fnc_missionTasksLocal];};
_function = _function param [0,BIS_fnc_missionTasksLocal,[{}]];

switch _mode do {
	_this call _function;
	default {
		["Mode '%1' not defined in %2",_mode,_function] call bis_fnc_error;
	};
};
true