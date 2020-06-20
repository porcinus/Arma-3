// Add a respawn position
[east,_this select 0] call BIS_fnc_addRespawnPosition;

{_x setpos (getMarkerPos "marker_0");} forEach (units BIS_grpMain); //NNS: move all players to initial respawn
