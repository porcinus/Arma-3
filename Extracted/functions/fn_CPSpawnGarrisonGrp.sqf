/*
	Author: Josef Zemanek

	Description:
	Combat Patrol garrison spawning
*/

params [
	"_grpConfig",
	"_distanceRandom",
	"_cnt"
];

for [{_j = 0}, {_j < _cnt}, {_j = _j + 1}] do {
	_finalSpawnPos = BIS_CP_insertionPos;
	_distance = call _distanceRandom;
	_loops = 0;

	while {_finalSpawnPos distance BIS_CP_insertionPos < 250 && _loops < 100} do {
		_finalSpawnPos = [BIS_CP_targetLocationPos, _distance, [0] call BIS_fnc_CPPickSafeDir] call BIS_fnc_relPos;
		_loops = _loops + 1;
	};
	
	if (_loops < 100) then {

		_finalSpawnPos = [_finalSpawnPos] call BIS_fnc_CPFindEmptyPosition;
		_startDir = BIS_CP_targetLocationPos getDir _finalSpawnPos;
		
		_grp = [_finalSpawnPos, BIS_CP_enemySide, _grpConfig] call BIS_fnc_spawnGroup;
		
		_grp setSpeedMode "LIMITED";
		_grp setBehaviour "SAFE";

		for [{_i = 30}, {_i < 360}, {_i = _i + 30}] do {
			_WPPos = [BIS_CP_targetLocationPos, abs (_distance - 20 + random 40), _startDir + _i] call BIS_fnc_relPos;
			if !(surfaceIsWater _WPPos) then {
				_newWP = _grp addWaypoint [_WPPos, 0];
				_newWP setWaypointBehaviour "SAFE";
				_newWP setWaypointSpeed "LIMITED";
			};
		};

		_newWP = _grp addWaypoint [position leader _grp, 1];
		_newWP setWaypointType "CYCLE";

		["        %1 (%2)", getText (_grpConfig >> "name"), _grp] call BIS_fnc_CPLog;
	};
};