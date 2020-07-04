if (isServer) then {
	_enemyCounts = param [0,1,[999]];
	if (_enemyCounts == 0) then {missionNamespace setVariable ["BIS_LimitEnemyCount",false]};
	if (_enemyCounts == 1) then {missionNamespace setVariable ["BIS_LimitEnemyCount",true]};
	publicVariable "BIS_LimitEnemyCount";
};
