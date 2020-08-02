/*
WARLORDS-SPECIFIC FUNCTION

Author: Josef Zemánek

Description: Sets up a path and behavior for AI to a specific sector.
*/

_grp = _this # 0;
_tgt = _this # 1;

_pos = position _tgt;

_wp1 = _grp addWaypoint [[_pos, random (((_tgt getVariable "Size") / 2) * 0.75), random 360] call BIS_fnc_relPos, 0];
_wp1 setWaypointType "SAD";

_wp2 = _grp addWaypoint [[_pos, random (((_tgt getVariable "Size") / 2) * 0.75), random 360] call BIS_fnc_relPos, 0];
_wp2 setWaypointType "SAD";

//_wp3 = _grp addWaypoint [waypointPosition _wp1, 0];
//_wp3 setWaypointType "CYCLE";

(leader _grp) setVariable ["BIS_WL_curWP", _wp1];

if (waypointType [_grp, currentWaypoint _grp] != "GETIN") then {
	_grp setCurrentWaypoint _wp1;
};