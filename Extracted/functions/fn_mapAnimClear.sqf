/*
	Author:
	Nelson Duarte

	Description:
	Same as mapAnimClear

	Parameters:
	Nothing

	Returns:
	Nothing

	Examples:
	[] call BIS_fnc_mapAnimClear;
*/

deleteVehicle ((missionNamespace getVariable ["BIS_mapAnimation_data", [0.0, 0.0, [], [], 0.0, 0.0, objNull]]) select 6);
removeMissionEventHandler ["EachFrame", missionNamespace getVariable ["BIS_mapAnimation_eachFrame", -1]];
missionNamespace setVariable ["BIS_mapAnimation_isPlaying", nil];
missionNamespace setVariable ["BIS_mapAnimation_eachFrame", nil];
missionNamespace setVariable ["BIS_mapAnimation_data", nil];