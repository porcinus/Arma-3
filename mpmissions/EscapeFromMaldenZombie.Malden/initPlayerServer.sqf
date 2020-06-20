[east,_this select 0] call BIS_fnc_addRespawnPosition; // Add a respawn position
/*
{
	//_x setpos ((getMarkerPos "marker_0") getPos [5, random 360]); //teleport unit to initial respawn
	//[_x, "marker_0"] call BIS_fnc_moveToRespawnPosition;
	if (getPlayerUID _x == "_SP_AI_") then {_x enableGunLights "forceOn"; _x action ["GunLightOn", _x];}; //try to force light on for AI
} forEach (units BIS_grpMain);
*/
// all players related loop
/*
[] spawn {
	_vehiFuel = [];
	while {true} do {
	};
};
*/
