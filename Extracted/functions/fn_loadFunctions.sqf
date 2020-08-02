/*
	Author: Karel Moricky

	Description:
	Compile scripts and save them into globally available functions.

	Parameter(s):
		0: STRING - script path
		1: STRING - variable prefix
		2: ARRAY - list of variables to be declared. Elements can be of following types:
			variable: STRING - variable is (prefix + variable), loaded from (path + variable + ".sqf")
			[variable:STRING,fileName:STRING] - variable is (prefix  variable), loaded from (path + fileName + ".sqf")
		3: BOOL - true for global persistent execution on all clients

	Returns:
	BOOL
*/

private ["_path","_variables","_globalExec","_variable","_fileName"];

_path = _this param [0,"",[""]];
_prefix = _this param [1,"",[""]];
_variables = _this param [2,[],[[]]];
_globalExec = _this param [3,true,[false]];

if (_prefix == "BIS_fnc_") then {_prefix = ""; ["Prefix 'BIS_fnc_' is reserved for functions."] call bis_fnc_error;};
{
	_variable = _x param [0,"",[""]];
	_fileName = _x param [1,_variable,[""]];
	if (_variable != "" && _fileName != "") then {
		_file = format ["scriptname '%1'; private '_fnc_scriptName'; _fnc_scriptName = '%1';",_prefix + _variable] + preprocessfilelinenumbers (_path + _fileName + ".sqf");
		missionnamespace setvariable [_prefix + _variable,compileFinal _file];
	};
} foreach _variables;

//--- Global execution
if (ismultiplayer && isserver && _globalExec) then {
	[
		[_path,_prefix,_variables,false],
		_fnc_scriptName,
		true,
		true,
		true
	] call bis_fnc_mp;
};
true