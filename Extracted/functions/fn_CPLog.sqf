/*
	Author: Josef Zemanek

	Description:
	Combat Patrol dedicated logging fnc
*/

// --- debug logs for Combat Patrol mode

if (cheatsEnabled) then {
	_this set [0, "[CP] " + (_this select 0)];
	textLogFormat _this;
};