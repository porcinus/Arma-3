/*
	Author: Josef Zemanek

	Description:
	Adds support types during a mission.

	Parameter(s):
	_this select 0: OBJECT - Requester unit
	_this select 1: OBJECT - Requester module
	_this select 2: OBJECT - Provider module

	Returns:
	nothing
*/

_reqUnit = _this param [0, objNull, [objNull]];
_requester = _this param [1, objNull, [objNull]];
_provider = _this param [2, objNull, [objNull]];

if (!((_reqUnit in synchronizedObjects _requester) && (_requester in synchronizedObjects _reqUnit))) then {
	_requester synchronizeObjectsAdd [_reqUnit];
	_reqUnit synchronizeObjectsAdd [_requester];
};

if (!((_provider in synchronizedObjects _requester) && (_requester in synchronizedObjects _provider))) then {
	_provider synchronizeObjectsAdd [_requester];
	_requester synchronizeObjectsAdd [_provider];
};

BIS_supp_refresh = TRUE; publicVariable "BIS_supp_refresh";

TRUE;