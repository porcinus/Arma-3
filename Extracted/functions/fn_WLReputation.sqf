/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Calculate player's reputiation (how rapidly they lose subordinates).
*/

BIS_manLost = FALSE;

while {TRUE} do {
	_t = time + 120;
	waitUntil {time > _t || BIS_manLost};
	if (BIS_manLost) then {
		BIS_manLost = FALSE;
		if (BIS_WL_matesAvailable > 0) then {
			BIS_WL_matesAvailable = BIS_WL_matesAvailable - 1;
		};
	} else {
		if (BIS_WL_matesAvailable < BIS_WL_maxSubordinates) then {
			BIS_WL_matesAvailable = BIS_WL_matesAvailable + 1;
		};
	};
};