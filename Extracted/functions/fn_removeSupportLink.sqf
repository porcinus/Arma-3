/*
	Author: Josef Zemanek

	Description:
	Removes support types during a mission.

	Parameter(s):
	_this select 0: OBJECT - Requester module
	_this select 1: OBJECT - Provider module

	Returns:
	nothing
*/

_requester = _this param [0, objNull, [objNull]];
_provider = _this param [1, objNull, [objNull]];

_requester synchronizeObjectsRemove [_provider];
_provider synchronizeObjectsRemove [_requester];

BIS_supp_refresh = TRUE; publicVariable "BIS_supp_refresh";

TRUE;