/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Play a given announcer message.
*/

if (isNil "BIS_WL_soundMsgBuffer") then {
	BIS_WL_soundMsgBuffer = [];
	[] spawn {
		while {TRUE} do {
			waitUntil {count BIS_WL_soundMsgBuffer > 0};
			playSound (BIS_WL_soundMsgBuffer select 0);
			BIS_WL_soundMsgBuffer deleteAt 0;
			sleep 2;
		};
	};
};

if (BIS_WL_voice == 1) then {
	BIS_WL_soundMsgBuffer pushBack format ["BIS_WL_%1_%2", _this, side group player];
};