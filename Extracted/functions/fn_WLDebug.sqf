/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Debug logging.
*/

_log = _this;

if (cheatsEnabled) then {
	_log set [0, "[WL] " + (_log # 0)];
	textLogFormat _log;
};