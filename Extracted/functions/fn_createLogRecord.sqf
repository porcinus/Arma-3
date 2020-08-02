/*
	Author: Karel Moricky

	Description:
	Create diary record in unified "Log" subject (create it when it doesn't exist yet)

	Parameter(s):
		0: OBJECT - owner
		1: STRING - title
		2: STRING - text

	Returns:
	STRING
*/

private ["_owner","_title","_text"];
_owner = _this param [0,objnull,[objnull]];
_title = _this param [1,"",[""]];
_text = _this param [2,"",[""]];

if (!isnull _owner && _title != "") then {
	if !(_owner diarysubjectexists "log") then {
		_owner creatediarysubject ["log",localize "STR_UI_DIARY_TITLE"];
	};
	_owner creatediaryrecord ["log",[_title,_text]];
} else {
	""
};