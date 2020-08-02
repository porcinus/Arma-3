/*
	Author: Josef Zemanek

	Description:
	Limits support runs during a mission.

	Parameter(s):
	_this select 0: OBJECT - Requester module
	_this select 1: STRING - Support type:
		"Artillery"
		"Transport"
		"CAS_Heli"
		"CAS_Bombing"
		"Drop"
	_this select 2: NUMBER - Support run limit
		-1: Unlimited

	Returns:
	nothing
*/

_requester = _this param [0, objNull, [objNull]];
_suppType = _this param [1, "", [""]];
_limit = _this param [2, -1, [-1]];

if (_limit < 0) then {_limit = 10e10};

_requester setVariable [format ["BIS_SUPP_limit_%1", _suppType], _limit, TRUE];

BIS_supp_refresh = TRUE; publicVariable "BIS_supp_refresh";

TRUE;