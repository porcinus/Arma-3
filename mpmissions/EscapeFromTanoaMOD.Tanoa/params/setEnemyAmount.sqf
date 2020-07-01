if (isServer) then {
	_enemyAmount = param [0,1,[999]];
	missionNamespace setVariable ["BIS_EnemyAmount",_enemyAmount,true];
	publicVariable "BIS_EnemyAmount";
};
